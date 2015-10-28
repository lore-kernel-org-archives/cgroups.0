From: Parav Pandit <pandit.parav@gmail.com>
Subject: RFC rdma cgroup
Date: Wed, 28 Oct 2015 13:59:15 +0530
Message-ID: <CAG53R5Vd=tLbKPeKy8ZKP2DoHG-rnzW85COiE1Hk4GLv6SAZyA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=xGd/VfT6HRTWBQYjz7GgpZ7iPDnTnvdoDVbixyxiamo=;
        b=MDNn/dgtZuIhS+Vkc/TECi3kh3XRkFG+cO8WUy5NdFc9Jr/+M1BQl4fmESt50+HvrD
         mm9J8c4KXv0fN4No4Icd/aHmWatbLvxvXcDn2V6Z3up9sQkcPvlh1POt5voEpD26NurW
         Uy5r74Bd7EiL+E9k527gcP89SrSE5cgNfvifILulFW1EZeCKjsu7gZMhwM4UH870q4jw
         Zp2mODIUXFf7eCFEAUi5s4R5He1Uqvj+mN+8no4U7Zag8+LUxQB6bDGjDLOkn8aGx+SQ
         iMrvTZTMC1Fhap2kDOcTMfQB6GfFwSuNm98VS39Ux1ZXjXR+31A3JAHLagZPzyEn88MJ
         WRFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Liran Liss <liranl@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "james.l.morris@oracle.com" <james.l.morris@oracle.com>, "serge@hallyn.com" <serge@hallyn.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, "raindel@mellanox.com" <raindel@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Parav Pandit <pandit.parav@gmail.com>, Haggai

Hi All,

Based on the review comments, feedback, discussion from/with Tejun,
Haggai, Doug, Jason, Liran, Sean, ORNL team, I have updated the design
as below.

This is fairly strong and simple design, addresses most of the points
raised to cover current RDMA use cases.
Feel free to skip design guidelines section and jump to design section
below if you find it too verbose. I had to describe it to set the
context and address comments from our past discussion.

Design guidelines:
-----------------------
1. There will be new rdma cgroup for accounting rdma resources
(instead of extending device cgroup).
Rationale: RDMA tracks different type of resources and it functions
differently than device cgroup. Though device cgroup could have been
extended for more generic nature, community feels that its better to
create RDMA cgroup, which might have more features than just resource
limit enforcement in future.

2. RDMA cgroup will allow resource accounting, limit enforcement on
per cgroup, per rdma device basis (instead of resource limiting across
all devices).
Rationale: this give granular control when multiple devices exist in the system.

3. Resources are not defined by the RDMA cgroup. Resources are defined
by RDMA/IB subsystem and optionally by HCA vendor device drivers.
Rationale: This allows rdma cgroup to remain constant while RDMA/IB
subsystem can evolve without the need of rdma cgroup update. A new
resource can be easily added by the RDMA/IB subsystem without touching
rdma cgroup.

4. RDMA uverbs layer will enforce limits on well defined RDMA verb
resources without any HCA vendor device driver involvement.
Rationale:
(a) RDMA verbs are very well defined set of resource abstraction in
Linux kernel stack for many years now and in use by many applications
directly working with RDMA resources in varied manner. Instead of
replicating code in every vendor driver, RDMA uverbs layer will
enforce such resource limits (with help of rdma cgroup).
(b) IB verbs resource is also a vendor agnostic representation of RDMA
resource; therefore its done at RDMA uverbs level.

6. RDMA uverbs layer will not do accounting of hw vendor specific resources.
Rationale: RDMA uverbs layer is not aware of which hw resource maps to
which verb resource and by how much amount. Therefore hw resource
accounting, charging, uncharging has to happen by the vendor driver.
This is optional and left to the HCA vendor device driver to
implement. HCA driver best knows on how to keep the mapping, therefore
its left to HCA vendor driver to do the accounting.

7. RDMA cgroup will provide unified APIs through which both RDMA
subsystem and vendor defined RDMA resource can be charged, uncharged
by verb layer and HCA driver respectively.

8. RDMA cgroup initial version will support only hard limits without
any kind of reservation of resources or ranges. In future it might be
extended for more dynamic nature.
Rationale: Typically RDMA resources are stateful resource unlike cpu
and RDMA resources don't follow work conserving nature.

9. Resource limit enforcement is hierarchical.

10. Process migration from one to other cgroup with active RDMA
resource is highly discouraged.

11. When process is migrated with active RDMA resources, rdma cgroup
continues to charge original cgroup.
Rationale:
Unlike other POSIX calls, RDMA resources are not defined as POSIX
level. These resources sit behind a file descriptor.
Multiple processes forked, belonging to different thread group, can
possibly placed in different cgroup sharing same rdma resources.
It could be well done where its allocated by one thread group and
release by other thread group from different cgroup.
Resource usage hierarchy can bet easily get complex even though that
is not primary use case.
Typically all processes which want to use RDMA resources will be part
of one leaf cgroup throughout their life cycle.
Therefore its not worth to complicate design around process migration.

Design:
---------
1. New RDMA cgroup defines resource pool object, that connects cgroup
subsystem to RDMA subsystem.
2. Resource pool object is per cgroup, per device entity that is
managed, controlled, configured by the administrator via cgroup
interface.
3. There can be at maximum of 64 resources per resource pool (such as
MR, QP, AH, PD etc and other hardware resources). To manage resources
beyond 64, it will require RDMA cgroup subsystem update. This will be
done in future if at all its needed.

4. RDMA cgroup defines two class of resources.
(a) verb resources - tracks RDMA verb layer resources
(b) hw resources - tracks HCA HW specific resources
5. verbs resource template is defined by RDMA uverbs layer.
6. hw resource template is defined by HCA vendor driver. This is
optional and should be done by those driver which doesn't have one to
one mapping with verb resource and hw resource.

7. Processes in a cgroup without any configured limit (or in other
words without resource pools) has max limits of the resources. If one
of the resource limit is configured, that particular resource will be
enforced, rest will enjoy upto their maximum limit.

8. Typically each RDMA cgroup will have 0 to 4 RDMA devices. Therefore
each cgroup will have 0 to 4 verbs resource pool and optionally 0 to 4
hw resource pool per such device.
(Nothing stops to have more devices and pools, but design is around
this use case).

9. Resource pool object is created in following situations.
(a) administrative operation is done to set the limit and no previous
resource pool exist for the device of interest for the cgroup.
(b) no resource limits were configured, but IB/RDMA subsystem tries to
charge the resource. so that when applications are running without
limits and later on when limits are enforced, during uncharging, it
correctly uncharges them, otherwise usage count will drop to negative.
This is done using default resource pool.
Instead of implementing any sort of time markers, default pool
simplifies the design.
(c) When process migrate from one to other cgroup, resource is
continue to be owned by the creator cgroup (rather css).
After process migration, whenever new resource is created in new
cgroup, it will be owned by new cgroup.

10. Resource pool is destroyed if it was of default type (not created
by administrative operation) and its the last resource getting
deallocated. Resource pool created as administrative operation is not
deleted, as its expected to be used in near future.

13. if administrative command tries to delete all the resource limit
with active resources per device, RDMA cgroup just marks the pool as
default pool with maximum limits.
----------------------------------------------------------------

Examples:
#configure resource limit:
echo mlx4_0 mr=100 qp=10 ah=2 cq=10 >
/sys/fs/cgroup/rdma/1/rdma.resource.verb.limit
echo ocrdma1 mr=120 qp=20 ah=2 cq=10 >
/sys/fs/cgroup/rdma/2/rdma.resource.verb.limit

#query resource limit:
cat /sys/fs/cgroup/rdma/2/rdma.resource.verb.limit
#output:
mlx4_0 mr=100 qp=10 ah=2 cq=10
ocrdma1 mr=120 qp=20 cq=10

#delete resource limit:
echo mlx4_0 del > /sys/fs/cgroup/rdma/1/rdma.resource.verb.limit

#query resource list:
cat /sys/fs/cgroup/rdma/1/rdma.resource.verb.list
mlx4_0 mr qp ah pd cq

cat /sys/fs/cgroup/rdma/1/rdma.hw.verb.list
vendor1 hw_qp hw_cq hw_timer

#configure hw specific resource limit
echo vendor1 hw_qp=56 > /sys/fs/cgroup/rdma/2/rdma.resource.hw.limit

-------------------------------------------------------------------------

I have completed initial development of above design. I am currently
testing this design.
I will post the patch soon once I am done validating it.

Let me know if there are any design comments.

Regards,
Parav Pandit
