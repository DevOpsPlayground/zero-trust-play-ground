package opa.examples

import data.servers
import data.networks
import data.ports

violations[server] {
    server := servers[_]
    server.protocols[_] == "http"
    public_servers[server]
}

public_servers[server] {
    some i, j
    server := servers[_]
    server.ports[_] == ports[i].id
    ports[i].networks[_] == networks[j].id
    networks[j].public == true
}


==

[
  {
    "op": "add",
    "path": "-",
    "value": {
      "id": "s1",
      "name": "app",
      "protocols": [
        "http",
        "https",
        "ssh"
      ],
      "ports": [
        "p1",
        "p2",
        "p3"
      ]
    }
  },
  {
    "op": "add",
    "path": "-",
    "value": {
      "id": "s2",
      "name": "db",
      "protocols": [
        "mysql"
      ],
      "ports": [
        "p3"
      ]
    }
  },
  {
    "op": "add",
    "path": "-",
    "value": {
      "id": "s3",
      "name": "cache",
      "protocols": [
        "memcache"
      ],
      "ports": [
        "p3"
      ]
    }
  },
  {
    "op": "add",
    "path": "-",
    "value": {
      "id": "s4",
      "name": "dev",
      "protocols": [
        "http",
        "https",
        "ssh"
      ],
      "ports": [
        "p1",
        "p2"
      ]
    }
  }
]


How it works

https://www.openpolicyagent.org/docs/v0.12.2/how-does-opa-work/