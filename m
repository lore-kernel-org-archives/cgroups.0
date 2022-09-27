From: Jeffrey Hugo <quic_jhugo-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: GPU device resource reservations with cgroups?
Date: Tue, 27 Sep 2022 09:13:49 -0600
Message-ID: <26b36812-cbe6-744d-6fb7-e7aec0bf5496@quicinc.com>
References: <7e047ee0-0243-d9d4-f0bc-7ed19ed33c19@quicinc.com>
 <CABdmKX2sGw-TwRYnHWuyaWYrxX7wgcK4gFSb5hGAwk0ztZxbcA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=suQc2ohV2UHcHZRjb/BQRqa5yc0AJwLQ4xnejAiqQpg=;
 b=QpmGLE7kck1/+nLQalritFgu1NYnCTtUGOsushncg7TS5A2SAwfRXELganJ7p/QUlVzX
 MTgdS8WnjcznQVKqMHsD25j9vTCdCv5b7CfTbafK48U0exNlL9SdsBVsY8kdCt9RsJhq
 QFZpt132e8VcEt+GpjCgPyIZxCEPCJqIRDvSljn3DzmfKqZxDtdFSD1umjIiUv4pg/cD
 ugixaApt9PurGuNar87Fu9C4R+1rBKfB5Maf8m74XTdbyw14g1RN+QJa2Lc8s5KlZwig
 nmyYcysZj2bqNSPdChZt2TYkNZR9FRG4Z/ZeeIRF6XAnrGF6iTOuqU2P/L3h/BXK9t6A wA== 
Content-Language: en-US
In-Reply-To: <CABdmKX2sGw-TwRYnHWuyaWYrxX7wgcK4gFSb5hGAwk0ztZxbcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carl Vanderlip <quic_carlv-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, quic_ajitpals-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, quic_pkanojiy-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org

On 9/8/2022 10:44 AM, T.J. Mercier wrote:
> On Tue, Aug 16, 2022 at 1:39 PM Jeffrey Hugo <quic_jhugo-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org> wrote:
>>
>> Hello cgroup experts,
>>
>> I have a GPU device [1] that supports organizing its resources for the
>> purposes of supporting containers.  I am attempting to determine how to
>> represent this in the upstream kernel, and I wonder if it fits in cgroups.
>>
>> The device itself has a number of resource types – compute cores,
>> memory, bus replicators, semaphores, and dma channels.  Any particular
>> workload may consume some set of these resources.  For example, a
>> workload may consume two compute cores, 1GB of memory, one dma channel,
>> but no semaphores and no bus replicators.
>>
>> By default all of the resources are in a global pool.  This global pool
>> is managed by the device firmware.  Linux makes a request to the
>> firmware to load a workload.  The firmware reads the resource
>> requirements from the workload itself, and then checks the global pool.
>> If the global pool contains sufficient resources to satisfy the needs of
>> the workload, the firmware assigns the required resources from the
>> global pool to the workload.  If there are insufficient resources, the
>> workload request from Linux is rejected.
>>
>> Some users may want to share the device between multiple containers, but
>> provide device level isolation between those containers.  For example, a
>> user may have 4 workloads to run, one per container, and each workload
>> takes 1/4th of the set of compute cores.  The user would like to reserve
>> sets of compute cores for each container so that container X always has
>> the expected set of resources available, and if container Y
>> malfunctions, it cannot “steal” resources from container X.
>>
>> To support this, the firmware supports a concept of partitioning.  A
>> partition is a pool of resources which are removed from the global pool,
>> and pre-assigned to the partition’s pool.  A workload can then be run
>> from within a partition, and it consumes resources from that partition’s
>> pool instead of from the global pool.  The firmware manages creating
>> partitions and assigning resources to them.
>>
>> Partitions do not nest.
>>
> Do partitions have any significance in hardware, or are they just a
> logical concept? Does it matter which compute core / bus replicator /
> dma channel a user gets, or are they interchangeable between uses?

Logical concept.  Resources are interchangeable.

In the future, I think it is possible that NUMA comes into the picture. 
  Just like now a CPU may be closer to a particular bank of memory (DDR) 
and thus keeping a task that uses that bank of memory scheduled on the 
associated CPU is an ideal situation from the perspective of the Linux 
scheduler, a particular compute core may have specific locality to other 
resources.

I'm guessing if we were to consider such a scenario, the partition would 
be flagged to request resources which are "close" to each-other.

>> In the above user example, the user can create 4 partitions, and divide
>> up the compute cores among them.  Then the user can assign each
>> individual container their own individual partition.  Each container
>> would be limited to the resources within it’s assigned partition, but
>> also that container would have exclusive access to those resources.
>> This essentially provides isolation, and some Quality of Service (QoS).
>>
>> How this is currently implemented (in downstream), is perhaps not ideal.
>>    A privileged daemon process reads a configuration file which defines
>> the number of partitions, and the set of resources assigned to each.
>> That daemon makes requests to the firmware to create the partitions, and
>> gets a unique ID for each.  Then the daemon makes a request to the
>> driver to create a “shadow device”, which is a child dev node.  The
>> driver verifies with the firmware that the partition ID is valid, and
>> then creates the dev node.  Internally the driver associates this shadow
>> device with the partition ID so that each request to the firmware is
>> tagged with the partition ID by the driver.  This tagging allows the
>> firmware to determine that a request is targeted for a specific
>> partition.  Finally, the shadow device is passed into the container,
>> instead of the normal dev node.  The userspace within the container
>> operates the shadow device normally.
>>
>> One concern with the current implementation is that it is possible to
>> create a large number of partitions.  Since each partition is
>> represented by a shadow device dev node, this can create a large number
>> of dev nodes and exhaust the minor number space.
>>
>> I wonder if this functionality is better represented by a cgroup.
>> Instead of creating a dev node for the partition, we can just run the
>> container process within the cgroup.  However it doesn’t look like
>> cgroups have a concept of resource reservation.  It is just a limit.  If
>> that impression is accurate, then I struggle to see how to provide the
>> desired isolation as some entity not under the cgroup could consume all
>> of the device resources, leaving the containers unable to perform their
>> tasks.
> 
> Given the top-down resource distribution policy for cgroups, I think
> you'd have to have a cgroup subtree where limits for these resources
> are exclusively passed to, and maintain the placement of processes in
> the appropriate cgroup under this subtree (one per partition +
> global). The limit for these resources in all other subtrees under the
> root would need to be 0. The only trick would be to maintain the
> limit(s) on the global pool based on the sum of the limits for the
> partitions to ensure that the global pool cannot exhaust resources
> "reserved" for the partitions. If partitions don't come and go at
> runtime then that seems pretty straightforward, otherwise I could see
> the maintenance/adjustment of those limits as a source of frustration.
> 
> 
> 
>>
>> So, cgroup experts, does this sound like something that should be
>> represented by a cgroup, or is cgroup the wrong mechanism for this usecase?
>>
>> [1] -
>> https://lore.kernel.org/all/1660588956-24027-1-git-send-email-quic_jhugo-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org/

