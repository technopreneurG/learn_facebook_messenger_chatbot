== README

A simple Ruby on Rails project hooking up with the Facebook Messenger Platform(Bots for Facebook Messenger)


Have created a very basic RoR project with:
```bash
$ rails new learn_facebook_messenger_chatbot
```

```bash
$ ruby -v
ruby 2.3.0p0 (2015-12-25 revision 53290) [i686-linux]
```


web-hooks to get the Facebook integration done:
```bash
$ bin/rake routes
                     Prefix Verb URI Pattern                            Controller#Action
webhooks_facebook_messenger GET  /webhooks/facebook_messenger(.:format) webhooks/facebook_messenger#verify
                            POST /webhooks/facebook_messenger(.:format) webhooks/facebook_messenger#chat
```

to run:
```bash
$ fb_verify_token='ABC' fb_access_token='XYZ' ./bin/rails server &
```

SEE ALSO:
https://developers.facebook.com/blog/post/2016/04/12/bots-for-messenger/
https://developers.facebook.com/docs/messenger-platform/quickstart
Facebook Messenger bot 15 minute tutorial  https://github.com/jw84/messenger-bot-tutorial
