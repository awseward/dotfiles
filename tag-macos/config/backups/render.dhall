let mkTemmplateLiteral = λ(key : Text) → "<!--\$${key}-->"

let reduce =
      λ(a : Type) →
      λ(b : Type) →
      λ(fn : a → b → b) →
      λ(b0 : b) →
      λ(xs : List a) →
        List/fold a xs b fn b0

let -- Renders a single replacement
    render_
    : ∀(replacement : { mapKey : Text, mapValue : Text }) →
      ∀(template : Text) →
        Text
    = λ(replacement : { mapKey : Text, mapValue : Text }) →
        Text/replace
          (mkTemmplateLiteral replacement.mapKey)
          replacement.mapValue

let --Renders all replacements in a (Map.Type Text Text)
    render
    : ∀(template : Text) →
      ∀(replacements : List { mapKey : Text, mapValue : Text }) →
        Text
    = reduce { mapKey : Text, mapValue : Text } Text render_

let _tests =
      { t1 = assert : mkTemmplateLiteral "FOO" ≡ "<!--\$FOO-->"
      , t2 =
          let template = "<!--\$FOO-->"

          let replacement = { mapKey = "FOO", mapValue = "bar" }

          in  assert : render_ replacement template ≡ "bar"
      , t3 =
          let template = "<!--\$FOO-->"

          let replacements = toMap { FOO = "bar" }

          in  assert : render template replacements ≡ "bar"
      , t4 =
          let template =
                ''
                <key>WorkingDirectory</key>
                <string><!--$WORKING_DIRECTORY--></string>
                <!-- … --->
                <key>EnvironmentVariables</key>
                <dict>
                  <key>PATH</key>
                  <string><!--$PATH_HEAD-->/usr/local/bin:/usr/bin<!--$PATH_TAIL--></string>
                  <!--$ENV_KEYPAIRS_XML-->
                </dict>
                <!-- … --->
                ''

          let replacements =
                toMap
                  { WORKING_DIRECTORY = "/home/foobar"
                  , PATH_HEAD = "beep:"
                  , PATH_TAIL = ":boop"
                  , ENV_KEYPAIRS_XML =
                      "<key>EXAMPLE</key><string>This is an example</string>"
                  }

          in    assert
              :   render template replacements
                ≡ ''
                  <key>WorkingDirectory</key>
                  <string>/home/foobar</string>
                  <!-- … --->
                  <key>EnvironmentVariables</key>
                  <dict>
                    <key>PATH</key>
                    <string>beep:/usr/local/bin:/usr/bin:boop</string>
                    <key>EXAMPLE</key><string>This is an example</string>
                  </dict>
                  <!-- … --->
                  ''
      }

in  render
