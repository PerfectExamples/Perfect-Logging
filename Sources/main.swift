//
//  main.swift
//  Perfect-Logging
//
//  Created by Jonathan Guthrie on 2016-12-21.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectLogger

// Define custom log file
LogFile.location = "./customLogFile.log"


// Get an event id so all messages at this level can be "linked" for analysis
let eventid = LogFile.info("Server Setup message")


// Create HTTP server.
let server = HTTPServer()

// Register your own routes and handlers
var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
		request, response in
		response.setHeader(.contentType, value: "text/html")

		LogFile.debug("This is a request log event fired when route hit by a browser.")

		response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
		response.completed()
	}
)

// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

LogFile.info("Server port is: \(server.serverPort)", eventid: eventid)

LogFile.debug("Demonstrating a logging event without the linked event id")


do {
	// Launch the HTTP server.
	LogFile.info("Starting server", eventid: eventid)
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
