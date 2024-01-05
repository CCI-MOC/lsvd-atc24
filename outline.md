# Outline and notes on the paper

Fundamental argument:

- Where do you put your storage?

- Location matters a lot in a practical implementation

Intro:

- Block devices are important

- Existing work demonstrated vialibilyto f log structrude things on a theoretical level

- We propose a concrete implementation, importantly that it's deployable in
current DC environments
  - It turns out that placement of the storage system is improtant in practice
  - Fundamental tradeoffs around:
    - Write durability under failure - if you put everything in RAM

- Benefits:

Motivation:

- Practical implementation of a theoretical system

- A key question is where should you put the storage system, handwaved in prior work

- Small note on user preference for never losing writes, maybe also in architecture

Novelty:

- Workable implementation

- Deployable in existing infrastructure
  - lifecycles have extended, so no new hardware
  - no client modification
  - much smaller surface area
  - backwards compatibility
  - iscsi?

- Shared cache
  - client and backend are both not great places to put caches
  - cache on client is bad, since DCs are pre-specced and if they're not
  there at the beginning, they're not there

- Possible approach: lessons in building a "real" system
  - Don't use kernel modules and require client side hardware
  - Primary backup shifts complexity to recovery instead of runtime

- Spectrum between:
- straight client -> backend (RBD and old LSVD)
-

Other notes:

- Architecture: what's our failure scenario
  - You can mirror wlog, then that defends against simultanous hardware failure

TODO:

- malloc remote write journal