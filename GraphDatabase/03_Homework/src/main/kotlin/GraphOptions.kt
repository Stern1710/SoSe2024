package eu.sternbauer

import org.neo4j.driver.Record

class GraphOptions {
    private val connector : Neo4jConnector = Neo4jConnector()

    fun getAllNodes() : List<String> {
        val allNodesQuery = "MATCH (n) RETURN n, labels(n);"
        val conResult = connector.executeQuery(allNodesQuery)

        return conResult.stream()
            .map { "${it.get("labels(n)")}" +
                    "${it.get("n").asMap()}" }
            .toList()
    }

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

    fun getAllRelationshipTypes() : List<String> {
        val allRelQuery = "MATCH ()-[r]-() RETURN distinct type(r)"
        val conResult = connector.executeQuery(allRelQuery)

        return conResult.stream()
            .map { it["type(r)"].toString() }
            .distinct()
            .map { it.substring(1, it.length - 1) }
            .toList()

    }

    fun getAllNodesWithLabel(label: String) : List<String> {
        val queryNodesWithLabel = "MATCH (n:$label) RETURN n"
        val conResult = connector.executeQuery(queryNodesWithLabel)

        return conResult.stream()
            .flatMap { r -> r.fields().stream()}
            .map { it.value().asMap() }
            .map { "Label: $label ; Attributes: ${it.map { (t, u) -> "$t: $u" }}"}
            .toList()
    }

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

    fun customFilter(selection: Int, label: String, filters: Map<String, String>) : List<String> {
        return when (selection) {
            0 -> customFilterNode(label, filters)
            1 -> customFilterRelation(label, filters)
            else -> listOf("")
        }
    }

    private fun customFilterNode(label: String, filters: Map<String, String>) : List<String> {
        val query = "MATCH (n$label {${filters.map { (k, v) -> "$k: $v" }.joinToString(", ")}}) RETURN n, labels(n)"
        val conResult = connector.executeQuery(query)

        return conResult.stream()
            .map { "${it.get("labels(n)").asList().joinToString(", ")}: " +
                    it.get("n").asMap().map { (k, v) -> "$k=$v" }.joinToString(", ")
            }
            .toList()
    }

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