package eu.sternbauer

import org.neo4j.driver.Record

/**
 * Handles the query building and result formatting with Neo4J.
 * Uses [Neo4jConnector] to hold the connection and execute queries.
 */
class GraphOptions {
    private val connector : Neo4jConnector = Neo4jConnector()

    /**
     * Gets all nodes from the database.
     * Formats the output with label name and attributes of the node per list element
     */
    fun getAllNodes() : List<String> {
        val allNodesQuery = "MATCH (n) RETURN n, labels(n);"
        val conResult = connector.executeQuery(allNodesQuery)

        return conResult.stream()
            .map { "${it.get("labels(n)")}" +
                    "${it.get("n").asMap()}" }
            .toList()
    }

    /**
     * Gets all labels used in the nodes. Each distinct label in one entry of the return list
     */
    fun getAllNodeLabels() : List<String> {
        val allNodesQuery = "MATCH (n) RETURN distinct labels(n)"
        val conResult = connector.executeQuery(allNodesQuery)

        return conResult.stream()
            .flatMap { r: Record ->
                r["labels(n)"].asList().stream()
            }
            .map { it.toString() }
            .distinct()
            .toList()
    }

    /**
     * Gets all relationship types from the database. Each distinct type in one entry of the return list
     */
    fun getAllRelationshipTypes() : List<String> {
        val allRelQuery = "MATCH ()-[r]-() RETURN distinct type(r)"
        val conResult = connector.executeQuery(allRelQuery)

        return conResult.stream()
            .map { it["type(r)"].toString() }
            .distinct()
            .map { it.substring(1, it.length - 1) }
            .toList()
    }

    /**
     * Gets all the nodes having one distinct label.
     * Each node with label and properties is one entry in the return list
     */
    fun getAllNodesWithLabel(label: String) : List<String> {
        val queryNodesWithLabel = "MATCH (n:$label) RETURN n"
        val conResult = connector.executeQuery(queryNodesWithLabel)

        return conResult.stream()
            .flatMap { r -> r.fields().stream()}
            .map { it.value().asMap() }
            .map { "Label: $label ; Attributes: ${it.map { (t, u) -> "$t: $u" }}"}
            .toList()
    }

    /**
     * Gets all relationships in the database with a given type (name).
     * Each relation with start/end node and the relation in between is one entry in the return list.
     */
    fun getAllRelationsWithType(type: String) : List<String> {
        val queryNodesWithLabel = "MATCH (n1)-[r:$type]->(n2) RETURN n1, labels(n1), r, n2, labels(n2)"
        println(queryNodesWithLabel)
        val conResult = connector.executeQuery(queryNodesWithLabel)

        return conResult.stream()
            .map { "${it.get("labels(n1)")}" +
                    "${it.get("n1").asMap()}" +
                    "-[:$type]->" +
                    "${it.get("labels(n2)")}" +
                    "${it.get("n2").asMap()}"
            }
            .toList()
    }

    /**
     * Handles custom filter options by for Nodes and Relations.
     * Takes a label, as a string, and multiple filters, as a map, with the selection whether to search
     * within Nodes or Relations with the passed search criteria
     */
    fun customFilter(selection: Int, label: String, filters: Map<String, String>) : List<String> {
        return when (selection) {
            0 -> customFilterNode(label, filters)
            1 -> customFilterRelation(label, filters)
            else -> listOf("")
        }
    }

    /**
     * Handles custom search for a node.
     * Constructs the query and returns the result in a list. Each entry is one node in the list,
     * including its labels and properties.
     */
    private fun customFilterNode(label: String, filters: Map<String, String>) : List<String> {
        val query = "MATCH (n$label {${filters.map { (k, v) -> "$k: $v" }.joinToString(", ")}}) RETURN n, labels(n)"
        val conResult = connector.executeQuery(query)

        return conResult.stream()
            .map { "${it.get("labels(n)").asList().joinToString(", ")}: " +
                    it.get("n").asMap().map { (k, v) -> "$k=$v" }.joinToString(", ")
            }
            .toList()
    }

    /**
     * Handles custom search for a relationship.
     * Constructs the query and returns the result in a list. Each entry is one relation in the list,
     * including the starting node label, the end node label, the relationship with its type and all properties.
     */
    private fun customFilterRelation(label: String,filters: Map<String, String>) : List<String> {
        val query = "MATCH (n1)-[r$label {${filters.map { (k, v) -> "$k: $v" }.joinToString(", ")}}]->(n2) RETURN labels(n1), r, type(r), labels(n2)"
        println(query)
        val conResult = connector.executeQuery(query)

        return conResult.stream()
            .map { "${it.get("labels(n1)")}" +
                    "-[${it.get("type(r)")}: ${it.get("r").asMap().map { (k, v) -> "$k=$v" }.joinToString(", ")}]->" +
                    "${it.get("labels(n2)")}"
            }
            .toList()
    }
}