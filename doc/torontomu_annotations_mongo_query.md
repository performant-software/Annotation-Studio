### Update user emails

```
db.annotations.updateMany({
  user: {
    $regex: /@ryerson.ca/
  },
  uri: {
    $regex: /ryerson.covecollective.org|torontomu.covecollective.org/
  }
},
[
  {
    "$set": {
      "user": {
        "$replaceAll": {
          "input": "$user",
          "find": "ryerson.ca",
          "replacement": "torontomu.ca"
        }
      },
      "permissions.admin": {
        $map: {
          input: "$permissions.admin",
          as: "item",
          in: {
            $replaceOne: {
              input: "$$item",
              find: "@ryerson.ca",
              replacement: "@torontomu.ca"
            }
          }
        }
      },
      "permissions.delete": {
        $map: {
          input: "$permissions.delete",
          as: "item",
          in: {
            $replaceOne: {
              input: "$$item",
              find: "@ryerson.ca",
              replacement: "@torontomu.ca"
            }
          }
        }
      },
      "permissions.read": {
        $map: {
          input: "$permissions.read",
          as: "item",
          in: {
            $replaceOne: {
              input: "$$item",
              find: "@ryerson.ca",
              replacement: "@torontomu.ca"
            }
          }
        }
      },
      "permissions.update": {
        $map: {
          input: "$permissions.update",
          as: "item",
          in: {
            $replaceOne: {
              input: "$$item",
              find: "@ryerson.ca",
              replacement: "@torontomu.ca"
            }
          }
        }
      },
    }
  }
])
```

### Update annotation URIs

```
db.annotations.updateMany({
  "uri": {
    $regex: /ryerson.covecollective.org/
  }
},
[
  {
    "$set": {
      "uri": {
        "$replaceAll": {
          "input": "$uri",
          "find": "ryerson.covecollective.org",
          "replacement": "torontomu.covecollective.org"
        }
      },
      
    }
  }
])
```