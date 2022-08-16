From: Jeffrey Hugo <quic_jhugo-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: GPU device resource reservations with cgroups?
Date: Tue, 16 Aug 2022 14:39:52 -0600
Message-ID: <7e047ee0-0243-d9d4-f0bc-7ed19ed33c19@quicinc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : to : cc : from : subject : content-type :
 content-transfer-encoding; s=qcppdkim1;
 bh=fxPvanH4qeBVh2aZXacr3twnFRomdbTwosccx73kWus=;
 b=GAxzEeB9Je887taMm/C3Y6+mEPelnEBsZTdS5ir79sWaEeKsKifbbefniv/ZVwUSEqVm
 mbHAwhC/Yeueym6aKukGgOOiP1MBUDpM04UcnuLLYYgvXDE031CTL8YOmU4E4IW7o+x7
 hAYV1P6tAsVyLrHKim8W6rFQjx6L+dY3mjyRYYUlOBAUvjDKTHGsPEQi1As4LnjWdie5
 d4CslhXzh8ligvnZygwBwEOgaHHxm0K8M0DcWrCEPLVhuos8ciUPTJjjM3buY2giTdDs
 Eb1w0RTStllQ6+BfwnbGfx9v9y82+rlKk8aupKe1w+K45xkE+IIm4lsD2Tl/KVy8SNGH sg== 
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carl Vanderlip <quic_carlv-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, quic_ajitpals-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, quic_pkanojiy-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org

Hello cgroup experts,

I have a GPU device [1] that supports organizing its resources for the 
purposes of supporting containers.  I am attempting to determine how to 
represent this in the upstream kernel, and I wonder if it fits in cgroups.

The device itself has a number of resource types – compute cores, 
memory, bus replicators, semaphores, and dma channels.  Any particular 
workload may consume some set of these resources.  For example, a 
workload may consume two compute cores, 1GB of memory, one dma channel, 
but no semaphores and no bus replicators.

By default all of the resources are in a global pool.  This global pool 
is managed by the device firmware.  Linux makes a request to the 
firmware to load a workload.  The firmware reads the resource 
requirements from the workload itself, and then checks the global pool. 
If the global pool contains sufficient resources to satisfy the needs of 
the workload, the firmware assigns the required resources from the 
global pool to the workload.  If there are insufficient resources, the 
workload request from Linux is rejected.

Some users may want to share the device between multiple containers, but 
provide device level isolation between those containers.  For example, a 
user may have 4 workloads to run, one per container, and each workload 
takes 1/4th of the set of compute cores.  The user would like to reserve 
sets of compute cores for each container so that container X always has 
the expected set of resources available, and if container Y 
malfunctions, it cannot “steal” resources from container X.

To support this, the firmware supports a concept of partitioning.  A 
partition is a pool of resources which are removed from the global pool, 
and pre-assigned to the partition’s pool.  A workload can then be run 
from within a partition, and it consumes resources from that partition’s 
pool instead of from the global pool.  The firmware manages creating 
partitions and assigning resources to them.

Partitions do not nest.

In the above user example, the user can create 4 partitions, and divide 
up the compute cores among them.  Then the user can assign each 
individual container their own individual partition.  Each container 
would be limited to the resources within it’s assigned partition, but 
also that container would have exclusive access to those resources. 
This essentially provides isolation, and some Quality of Service (QoS).

How this is currently implemented (in downstream), is perhaps not ideal. 
  A privileged daemon process reads a configuration file which defines 
the number of partitions, and the set of resources assigned to each. 
That daemon makes requests to the firmware to create the partitions, and 
gets a unique ID for each.  Then the daemon makes a request to the 
driver to create a “shadow device”, which is a child dev node.  The 
driver verifies with the firmware that the partition ID is valid, and 
then creates the dev node.  Internally the driver associates this shadow 
device with the partition ID so that each request to the firmware is 
tagged with the partition ID by the driver.  This tagging allows the 
firmware to determine that a request is targeted for a specific 
partition.  Finally, the shadow device is passed into the container, 
instead of the normal dev node.  The userspace within the container 
operates the shadow device normally.

One concern with the current implementation is that it is possible to 
create a large number of partitions.  Since each partition is 
represented by a shadow device dev node, this can create a large number 
of dev nodes and exhaust the minor number space.

I wonder if this functionality is better represented by a cgroup. 
Instead of creating a dev node for the partition, we can just run the 
container process within the cgroup.  However it doesn’t look like 
cgroups have a concept of resource reservation.  It is just a limit.  If 
that impression is accurate, then I struggle to see how to provide the 
desired isolation as some entity not under the cgroup could consume all 
of the device resources, leaving the containers unable to perform their 
tasks.

So, cgroup experts, does this sound like something that should be 
represented by a cgroup, or is cgroup the wrong mechanism for this usecase?

[1] - 
https://lore.kernel.org/all/1660588956-24027-1-git-send-email-quic_jhugo-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org/
