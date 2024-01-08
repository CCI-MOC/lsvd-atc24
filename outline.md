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

## W2-1 meeting notes

- Don't call it a centralised gateway, it's more a gateway layer between client
  and backend
  - Lets us do sharing
  - New options for durability levels
  - Provisioning without hardware changes
  - Wear on device
  - Compatibility with existing systems
  - Elasticity -- we can even 
  - Clients are stateless -- they can migrate without headaches
  - Multiple clients attached to the same disk possible
    - Single point of synchronisation, ordering, etc
  - Choices on durability

- 2 dimensions of storage: performance and capacity
  - Separate out performance and capacity
  - Fixed cost of performance is very low
  - If you need more iops, add gateway compute/cache - it's elastic
  - Elasticity of performance and capacity both
  - Cpu is not particularly cheap, don't want to put it all on the backend
  - Less compute for a fixed amount of capacity on the backend
  - Don't need peak provisioning
  - If you put it on the backend, you provision it for peak and it's fixed
    - Cache and CPU has to be provisioned for peak performance
  - If you put it on the client, the client has to be provisioned for peak
    - You have to predict ratio of clients to iops/cache requirement
    - You can't put nvme drives on every client machine either
    - EVen an oracular scheduler can't add more cache
    - It's all pre-provisioned
    - Increased range of possible durability guarantees
  - Equipment outlives workloads (LLMs)
  - Put in the middle, it scales independently of both
  - All 3 are independent: capacity, # of clients, aggregate iops

- Originally demonstrated as a local disk
  - Practical deployment requires changes
  - Backwards compatible - nvmeof/iscsi and not require hardware changes
  - Replacing client machines is impractical

- Notes on elasticity
  - To delpoy a fixed capacity, you have fixed costs: metal, psu, cpu, etc
  - RBD places a high performance burden on the backend
  - Move compute away from backend onto dynamically allocate intermediate nodes
  - This separates out the cost of performance and capacity
  - You don't have to provision OSD servers for peak iops demand
  - Gateway nodes can be spun up dynamically

- Simplicity
  - In terms of network comms, and in concept
  - Strongly consistent map is required otherwise
  - We just have recovery, complexity shifted to recovery
  - We preserve the benefits of a non-distributed system while maintaing properties of being distributed
  - Reliability of distributed systems

- Move the paper more towards research instead of engineering
  - Mention RBD in the context as a classic baseline - compute in the backend
  - Bring up Microsoft blizzard, salus papers
  - Alibaba - 

- Intro:
  - Approaches: put all the state/compute in backend: RBD
  - Put all the state/compute in the client: LSVD
  - Here we try to put it somewhere in the middlea
  - A large amount of work on disaggregated storage
    - Distributed systems - Salus - are complicated
    - Client side: Blizzard
    - Azure blob storage - lots of overhead
    - Fully distributed systems - lots of complexity
    - Fully client-side implementations - LSVD, Alibaba (on a smart nic), Amber?
  - We propose an alternative approach
    - Intermediate layer
    - Retains simplicity of log-structured storage
    - Elasticity of compute and capacity
    - Shared caching
    - Backwards compatibility

- Abstract
  - There are systems that are on the client-side
    - Logs to convert client writes to backend writes
  - Some are on the backend
    - Directly compute ot the backend
  - We're proposing something in middle
    - Another layer of indirection
    - This disaggregates compute from capacity, makes it elastic
    - Multiplexing between clients
    - Elastic compute
    - Shared caching
  - What storage experts don't want you to know

- Newer work (LSVD, Blizzard) puts log-structured data on the client, reducing
  backend load
  - Still ties client cache capacity to client iops
