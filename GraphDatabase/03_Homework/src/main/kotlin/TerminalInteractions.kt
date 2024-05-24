package eu.sternbauer

class TerminalInteractions {
    private val graph = GraphOptions()

    fun basicOperations() {
        while(true) {
            val options = listOf("All Nodes", "All Node Labels", "All Relationship Types", "Custom Filter", "Exit")
            val selection = getOption(options, "Which basic operation would you like to perform?")
            when(selection) {
                0 -> {getAllNodes()}
                1 -> {getAllNodeLabels()}
                2 -> {getAllRelationshipLabels()}
                3 -> {customFilter()}
                else -> {
                    println("Exiting program")
                    return
                }
            }
        }

    }

    private fun getAllNodes() {
        val nodes = graph.getAllNodes()
        printOption(nodes, "These are all nodes")
    }

    private fun getAllNodeLabels() {
        val nodeLabels = graph.getAllNodeLabels()
        val selection = getOption(nodeLabels, "Which node label would you like to inspect further?")

        nodeLabelActions(nodeLabels[selection])
    }

    private fun nodeLabelActions(label: String) {
        val all = graph.getAllNodesWithLabel(label)
        printOption(all, "Here are all nodes with the label $label")
    }

    private fun getAllRelationshipLabels() {
        val relTypes = graph.getAllRelationshipTypes()
        val selection = getOption(relTypes, "Which relationship type would you like to inspect further?")

        relationshipTypeActions(relTypes[selection])
    }

    private fun relationshipTypeActions(type: String) {
        val relTyp = graph.getAllRelationsWithType(type)
        printOption(relTyp, "Here are all relationships of type $type")
    }

    private fun customFilter() {
        val decision = listOf("Yes", "No")
        val options = listOf("Node", "Relation")
        val selection = getOption(options, "Which element would you like specify filters for?")

        val isLabel = getOption(decision, "Do you want to provide a ${if (selection == 0) "label" else "type"}?")
        var label = ""

        if (isLabel == 0) {
            print("Please provide the ${if (selection == 0) "label" else "type"}?: ")
            label = readln()
            if (!label.startsWith(":")) label = ":$label"
        }

        val attMap = mutableMapOf<String, String>()

        var attOption = getOption(decision, "Do you want to add a property filter?")
        while (attOption == 0) {
            print("Filter key: ")
            val key = readln()
            print("Filter val: ")
            val value = readln()
            attMap[key] = value

            attOption = getOption(decision, "Do you want to add another property filter?")
        }

        val results = graph.customFilter(selection, label, attMap)
        results.forEach { println(it) }
    }

    /*
    * The functions in this section print all the elements in a list of strings.
    */

    private fun getOption(options: List<String>, preText: String = "") : Int {
        printOption(options, preText)
        return getInput(options)
    }

    private fun getInput(options: List<String>) : Int {
        var selection : Int = -1

        while (selection < 0) {
            print("Please select an option [0-${options.size-1}]: ")
            val index = (readlnOrNull()?.toInt() ?: 0 )
            if (index >= 0 && index < options.size) selection = index
        }
        return selection
    }

    private fun printOption(options: List<String>, preText: String = "") {
        if (preText != "") println(preText)
        options.forEachIndexed { i, s -> println("\t[$i] $s") }
    }
}