---
title: "Interact With Protobuf Endpoints in Human-Readable Text Formats Using protoCURL"
date: 2022-12-21T14:20:05+01:00
author: "[Swaneet Sahoo](https://github.com/GollyTicker)"
type: "post"
tags: ["Protocol Buffers","HTTP","REST","Command Line","Open Source"]
image: "protocurl-intro/pexels-edgard-motta-flipped.jpg"
summary: "protoCURL is the command-line tool for interacting with Protobuf over HTTP REST endpoints using human-readable text formats"
draft: true
---

Do you have difficulties debugging [Protocol-Buffers](https://developers.google.com/protocol-buffers)-based HTTP REST endpoints? Since Protobuf uses *binary payloads*, we face the problem, that we *cannot easily write or read our Protobuf payloads* with `curl` directly on the terminal. Ideally, we would like to to use curl with Protobuf just like we use curl with JSON or XML with classic text-based HTTP REST endpoints. [^via-protoc]

To this problem, we present [protoCURL](https://github.com/qaware/protocurl) - cURL for Protobuf: The command line tool to quickly and easily write requests in human-readable text formats on the command line against Protocol Buffer over HTTP endpoints and view the output in a text-based format as well.

This can become handy when debugging Protobuf-based HTTP endpoints when they are used instead of JSON.[^protobuf-uses]

The tool was created by myself ([GollyTicker](https://github.com/GollyTicker)) with initial sponsorship from [QAware](https://qaware.de), because of the need for debugging Protobuf REST APIs in our projects.


&nbsp; <!-- add artificial spacing -->
## An Example with protoCURL

With protoCURL a request can be as simple as this:[^powershell-syntax]
```bash
protocurl -I test/proto -i ..HappyDayRequest -o ..HappyDayResponse \
  -u http://localhost:8080/happy-day/verify \
  -d 'includeReason: true'
```

The command line arguments have this meaning:
* `-I test/proto` points to proto files in the filesystem
* `-i ..HappyDayRequest` and `-o ..HappyDayResponse` tell which message types are used for the input and expected for the output
    * The `..` instructs protocurl to automatically infer the (unique) full package path of the message types
* `-u <url>` is the HTTP REST endpoint url to send the request to
* `-d 'includeReason: true'` describes the input data in the Protobuf Text Format

The Protobuf endpoint uses the proto file [happyday.proto](https://github.com/qaware/protocurl/blob/main/test/proto/happyday.proto) - which consists of these (condensed) request and response messages:

```protobuf
package happyday;

message HappyDayRequest {
  google.protobuf.Timestamp date = 1;
  bool includeReason = 2;
}

message HappyDayResponse {
  bool isHappyDay = 1;
  string reason = 2;
  string formattedDate = 3;
}
```

The server will tell us whether the UTC day of a specific timestamp is a *happy* day or not. We simply say, that everyday, except for Wednesdays, is a *happy* day.[^test-server-code] 

Concretely, given a `HappyDayRequest`,
* the server converts the `date` to `UTC` and sets the boolean `isHappyDay` if and only if the weekday of the date is Wednesday.
* If `includeReason` is set, then a reason for the `isHappyDay` boolean is given as a string.
* The server will also format the date to UTC as `formattedDate`.


The above protoCURL command will produce this output:
```console
=========================== Request Text     =========================== >>>
includeReason: true
=========================== Response Text    =========================== <<<
isHappyDay: true
reason: "Thursday is a Happy Day! ⭐"
formattedDate: "Thu, 01 Jan 1970 00:00:00 GMT"
```

We can now easily see the request and response in the [Protobuf Text Format](https://github.com/qaware/protocurl#protobuf-text-format) without needing to use `protoc` or a full-blown programming language to manually (de-) serialize the content. Since we didn't provide a `date`, the Protobuf server implicitly assumes all of the [timestamp.proto](https://github.com/protocolbuffers/protobuf/blob/main/src/google/protobuf/timestamp.proto) fields to be zero - which corresponds to epoch time `0`.


&nbsp; <!-- add artificial spacing -->
## Explanation

In the background, protocurl essentially does the following:
1. encode the textual Protobuf message to a binary request payload (using a bundled `protoc`)
2. send the binary payload in a POST request to the HTTP REST endpoint (via `curl`, if possible) and receive the binary response payload
3. decode the binary response payload back to text and display it


&nbsp; <!-- add artificial spacing -->
## More Examples

As a second example, let's see, what happens, when we set the `date` to the first Wednesday in 2023:
```bash
protocurl -I test/proto -i ..HappyDayRequest -o ..HappyDayResponse \
  -u http://localhost:8080/happy-day/verify \
  -d 'includeReason: true, date: { seconds: 1672790400 }'
```
Note, the syntax for the text format above.

This will produce:
```console
=========================== Request Text     =========================== >>>
date: {
  seconds: 1672790400
}
includeReason: true
=========================== Response Text    =========================== <<<
reason: "Tough luck on Wednesday... 😕"
formattedDate: "Wed, 04 Jan 2023 00:00:00 GMT"
```

Furthermore, we can also use JSON as the text format:
```bash
protocurl -I test/proto -i ..HappyDayRequest -o ..HappyDayResponse \
  -u http://localhost:8080/happy-day/verify \
  -d "{ \"date\": \"2023-01-01T00:00:00Z\", \"includeReason\": true }"
```

The JSON format is automatically detected and also used for the output:
```console
=========================== Request JSON     =========================== >>>
{"date":"2023-01-01T00:00:00Z","includeReason":true}
=========================== Response JSON    =========================== <<<
{"isHappyDay":true,"reason":"Sunday is a Happy Day! ⭐","formattedDate":"Sun, 01 Jan 2023 00:00:00 GMT"}
```


&nbsp; <!-- add artificial spacing -->
## Reproducing the Examples yourselves

Want to try this out? You can reproduce these examples by taking the following steps:

{{< rawhtml >}}
  <details
    style="border:dashed var(--theme) 0.2em;
    border-radius: 1em;
    padding:0.8em;
    margin-bottom:1.2em"
    >
    <summary>Clone repository and start the test server</summary>
    In your macOS / Linux or Windows MinGW terminal, run:
    <code style="white-space:pre">

  # Clone the repository and enter the directory
  git clone protocurl
  cd protocurl

  # Ensure these are installed and available to you: bash, jq, zip, unzip and curl
  # e.g. sudo apt install bash jq zip unzip curl

  # Download the latest protoc binaries for the tests
  ./release/10-get-protoc-binaries.sh

  # Start server
  (source test/suite/setup.sh && startServer)
  </code>
</details>
{{< /rawhtml >}}


{{< rawhtml >}}
<details
  style="border:dashed var(--theme) 0.2em;
  border-radius: 1em;
  padding:0.8em;
  margin-bottom:1.2em"
  >
    <summary><a href="https://github.com/qaware/protocurl#install">Install protocurl from GitHub</a></summary>
    <p>
        Simply follow the <a href="https://github.com/qaware/protocurl#install">command line installation instructions</a>.
    </p>
    <p>
  When using windows, run <code>protocurl.exe</code> in Powershell or cmd instead of MinGW.
    </p>
    <p>
    If you use docker, then use the command
    <br/>
    <code style="white-space:pre">docker run -v /path/to/proto:/proto qaware/protocurl [...ARGS]</code>
    <br/>
    instead of
  <br/>
    <code style="white-space:pre">protocurl -I /path/to/proto [...ARGS]</code>
    </p>
</details>
{{< /rawhtml >}}

Now you can send requests like the examples above.


&nbsp; <!-- add artificial spacing -->
## Summary

We can use protocurl as a *quick and ergonomic command line* tool to interact with *Protobuf-based HTTP REST endpoints* while working with *human-readable text formats*.

Head over to [protocurl on GitHub](https://github.com/qaware/protocurl) and
* look at the [examples](https://github.com/qaware/protocurl/blob/main/EXAMPLES.md),
* download the [releases](https://github.com/qaware/protocurl/releases),
* read the [command line usage](https://github.com/qaware/protocurl/blob/main/doc/generated.usage.txt)
* contribute by [creating issues](https://github.com/qaware/protocurl/issues) for bugs or feature requests!

&nbsp; <!-- add artificial spacing -->

*[The photo is by Edgard Motta from Pexels.](https://www.pexels.com/photo/arrows-on-a-footpath-12081699/)*

[^protobuf-uses]: In specific scenarios, Protobuf is used instead of JSON, because the built-in schema format as well as the ability to generate code make it a viable choice for keeping consumers and producers of REST APIs consistent with each other and documented. It can also be the serialization for RPC frameworks such as [Twirp](https://github.com/twitchtv/twirp).

[^test-server-code]: [NodeJS-based server implementation](https://github.com/qaware/protocurl/blob/main/test/servers/server.ts)

[^powershell-syntax]: For Powershell, we need to replace `/` by `\` in the path and use a backtick \` instead of `\` as line separators.

[^via-protoc]: In theory, we could manually decode and encode the request and response via `protoc` using the [Protobuf Text Format](https://developers.google.com/protocol-buffers/docs/text-format-spec). But this becomes cumbersome quickly.
