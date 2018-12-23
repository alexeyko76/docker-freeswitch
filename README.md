# haveged as a Docker container

It is using [haveged](http://www.issihosts.com/haveged/) to provide entropy on Linux headless servers.

## Articles

- [How to Setup Additional Entropy for Cloud Servers Using Haveged](https://www.digitalocean.com/community/tutorials/how-to-setup-additional-entropy-for-cloud-servers-using-haveged)
- [Challenges With Randomness In Multi-tenant Linux Container Platforms](https://blog.pivotal.io/pivotal-cloud-foundry/features/challenges-with-randomness-in-multi-tenant-linux-container-platforms)
- [Myths about /dev/urandom](http://www.2uo.de/myths-about-urandom/)

## How to use

Run a container like this

```
docker run --name haveged --privileged -d alexeyko/haveged
```

