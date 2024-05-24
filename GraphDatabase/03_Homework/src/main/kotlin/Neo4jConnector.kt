package eu.sternbauer

import org.neo4j.driver.AuthTokens
import org.neo4j.driver.Driver
import org.neo4j.driver.GraphDatabase
import org.neo4j.driver.Record

class Neo4jConnector() {
    private val dbUri = "neo4j://localhost"
    private val dbUser = "neo4j"
    private val dbPassword = ""

    private var driver : Driver = GraphDatabase.driver(dbUri, AuthTokens.basic(dbUser, dbPassword))

    init {
        driver.verifyConnectivity()
    }

    fun executeQuery(query: String): List<Record> {
        val resAllNodes = driver.executableQuery(query).execute()
        return resAllNodes.records()
    }
}