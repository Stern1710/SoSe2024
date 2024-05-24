package eu.sternbauer

/**
 * Handles the user interaction on the terminal,
 * including inputs, selections, confirmations
 * and output of information in list format.
 */
class TerminalInteractions {
    private val graph = GraphOptions()

    /**
     * Provides the base menu
     */
    fun basicOperations() : Boolean {
        val options = listOf("All Nodes", "All Node Labels", "All Relationship Types", "Custom Filter", "Exit")
        val selection = getOption(options, "Which basic operation would you like to perform?")
        when(selection) {
            0 -> {getAllNodes()}
            1 -> {getAllNodeLabels()}
            2 -> {getAllRelationshipLabels()}
            3 -> {customFilter()}
            else -> {
                println("Exiting program")
                return false
            }
        }
        return true
    }

    /**
     * Handles getting all nodes from [GraphOptions.getAllNodes]
     * and passing them to [printOption]
     */
    private fun getAllNodes() {
        val nodes = graph.getAllNodes()
        printOption(nodes, "These are all nodes")
    }

    /**
     * Handles getting all node labels from [GraphOptions.getAllNodeLabels]
     * and passing them to [printOption]
     */
    private fun getAllNodeLabels() {
        val nodeLabels = graph.getAllNodeLabels()
        val selection = getOption(nodeLabels, "Which node label would you like to inspect further?")

        nodeLabelActions(nodeLabels[selection])
    }

    /**
     * Handles getting all nodes with a given label from [GraphOptions.getAllNodesWithLabel]
     * and passing them to [printOption]
     */
    private fun nodeLabelActions(label: String) {
        val all = graph.getAllNodesWithLabel(label)
        printOption(all, "Here are all nodes with the label $label")
    }

    /**
     * Handles getting all relationship labels from [GraphOptions.getAllRelationshipTypes],
     * getting a selection from [getOption] and calling [relationshipTypeActions] with the selection.
     */
    private fun getAllRelationshipLabels() {
        val relTypes = graph.getAllRelationshipTypes()
        val selection = getOption(relTypes, "Which relationship type would you like to inspect further?")

        relationshipTypeActions(relTypes[selection])
    }

    /**
     * Handles getting all relations with a specified type from [GraphOptions.getAllRelationsWithType]
     * and passing them to [printOption]
     */
    private fun relationshipTypeActions(type: String) {
        val relTyp = graph.getAllRelationsWithType(type)
        printOption(relTyp, "Here are all relationships of type $type")
    }

    /**
     * Implements the functionality for custom filtering.
     * This combines searching in Nodes and Relations for both labels/type and search for properties in them.
     * This function builds the handles the input and passes it to the according function in [GraphOptions]
     */
    private fun customFilter() {
        val options = listOf("Node", "Relation")
        val selection = getOption(options, "Which element would you like specify filters for?")

        val isLabel = getDecision("Do you want to provide a ${if (selection == 0) "label" else "type"}?")
        var label = ""

        if (isLabel) {
            print("Please provide the ${if (selection == 0) "label" else "type"}: ")
            label = readln()
            if (!label.startsWith(":")) label = ":$label"
        }

        val attMap = mutableMapOf<String, String>()

        var attOption = getDecision("Do you want to add a property filter?")
        while (attOption) {
            print("Filter key: ")
            val key = readln()
            print("Filter val: ")
            val value = readln()
            attMap[key] = value

            attOption = getDecision("Do you want to add another property filter?")
        }

        val results = graph.customFilter(selection, label, attMap)
        results.forEach { println(it) }
    }

    /*
     * ------------------------------
     * The functions in this section print all the elements in a list of strings.
     * ------------------------------
    */

    /**
     * Displays a pretext and asks the user for confirmation.
     * It will default to No (false) if neither 'y' nor 'Y' is entered.
     */
    private fun getDecision(preText: String): Boolean {
        print("$preText [y/N] ")
        val input = readln()
        return (input == "y" || input == "Y")
    }

    /**
     * Prints all options passed in the option parameter with a given pretext.
     * It adds an index, starting with 0, in brackets before each option to clearly separate longer outputs
     */
    private fun printOption(options: List<String>, preText: String = "") {
        if (preText != "") println(preText)
        options.forEachIndexed { i, s -> println("\t[$i] $s") }
    }

    /**
     * Prints all options passed in the parameter with a given pretext.
     * It combines [printOption] and [getInput] to print all elements and get an input index
     */
    private fun getOption(options: List<String>, preText: String = "") : Int {
        printOption(options, preText)
        return getInput(options.size)
    }

    /**
     * Gets a number between 0 and the number of options.
     * If the entered number is outside the specified range, the input is repeated.
     */
    private fun getInput(highestOption: Int) : Int {
        var selection : Int = -1

        while (selection < 0) {
            print("Please select an option [0-${highestOption-1}]: ")
            val index = (readlnOrNull()?.toInt() ?: 0 )
            if (index in 0..<highestOption) selection = index
        }
        return selection
    }


}