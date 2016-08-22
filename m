From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv11 3/3] rdmacg: Added documentation for rdmacg
Date: Mon, 22 Aug 2016 18:03:51 +0530
Message-ID: <1471869231-15576-4-git-send-email-pandit.parav@gmail.com>
References: <1471869231-15576-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kc13ONLH0+dkw/LRVFdDpWu37D4dgfNCskm1uwaQQjc=;
        b=OQJngxUxbP1gjlnyU5yfg0Q8X75NChLSTJ4ojdy6Zug5KaUGxK0ioet1GsYMNBoQv/
         2ylePCtwiVSeWtbBcdLzo3zWNvHMxEDfqdcXYcunMxbyk7l6vfTV+dSWvh4647VtBEOF
         b0aa6pZDQ5AA1H1xLITfKv86YUXjwR7jZSSgvE9v2o/KK9oX06J+RI/EvoN+lFXbzsgI
         kEOUyv65YfP8RQ3Y9/btShcRgonrkrGSsQ1obdoC7i0tP0rNFgdMNA12bG/lfj8FqVnG
         t4KbI6I0SSSencl202TozyZAYN32pMPEO2SQ+J3dlyk/bLE8sT2W3YdRiDIrAJokAKrU
         veqA==
In-Reply-To: <1471869231-15576-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

Added documentation for v1 and v2 version describing high
level design and usage examples on using rdma controller.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 Documentation/cgroup-v1/rdma.txt | 117 +++++++++++++++++++++++++++++++++++++++
 Documentation/cgroup-v2.txt      |  44 +++++++++++++++
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/cgroup-v1/rdma.txt

diff --git a/Documentation/cgroup-v1/rdma.txt b/Documentation/cgroup-v1/rdma.txt
new file mode 100644
index 0000000..7b78678
--- /dev/null
+++ b/Documentation/cgroup-v1/rdma.txt
@@ -0,0 +1,117 @@
+				RDMA Controller
+				----------------
+
+Contents
+--------
+
+1. Overview
+  1-1. What is RDMA controller?
+  1-2. Why RDMA controller needed?
+  1-3. How is RDMA controller implemented?
+2. Usage Examples
+
+1. Overview
+
+1-1. What is RDMA controller?
+-----------------------------
+
+RDMA controller allows user to limit RDMA/IB specific resources that a given
+set of processes can use. These processes are grouped using RDMA controller.
+
+RDMA controller defines well defined verb resources which can be limited for
+processes of a cgroup.
+
+1-2. Why RDMA controller needed?
+--------------------------------
+
+Currently user space applications can easily take away all the rdma device
+specific resources such as AH, CQ, QP, MR etc. Due to which other applications
+in other cgroup or kernel space ULPs may not even get chance to allocate any
+rdma resources. This can leads to service unavailability.
+
+Therefore RDMA controller is needed through which resource consumption
+of processes can be limited. Through this controller various different rdma
+resources can be accounted.
+
+1-3. How is RDMA controller implemented?
+----------------------------------------
+
+RDMA cgroup allows limit configuration of resources. Rdma cgroup maintains
+resource accounting per cgroup, per device using resource pool structure.
+Each such resource pool is limited up to 64 resources in given resource pool
+by rdma cgroup, which can be extended later if required.
+
+This resource pool object is linked to the cgroup css. Typically there
+are 0 to 4 resource pool instances per cgroup, per device in most use cases.
+But nothing limits to have it more. At present hundreds of RDMA devices per
+single cgroup may not be handled optimally, however there is no
+known use case or requirement for such configuration either.
+
+Since RDMA resources can be allocated from any process and can be freed by any
+of the child processes which shares the address space, rdma resources are
+always owned by the creator cgroup css. This allows process migration from one
+to other cgroup without major complexity of transferring resource ownership;
+because such ownership is not really present due to shared nature of
+rdma resources. Linking resources around css also ensures that cgroups can be
+deleted after processes migrated. This allow progress migration as well with
+active resources, even though that is not a primary use case.
+
+Whenever RDMA resource charing occurs, owner rdma cgroup is returned to
+the caller. Same rdma cgroup should be passed while uncharging the resource.
+This also allows process migrated with active RDMA resource to charge
+to new owner cgroup for new resource. It also allows to uncharge resource of
+a process from previously charged cgroup which is migrated to new cgroup,
+even though that is not a primary use case.
+
+Resource pool object is created in following situations.
+(a) User sets the limit and no previous resource pool exist for the device
+of interest for the cgroup.
+(b) No resource limits were configured, but IB/RDMA stack tries to
+charge the resource. So that it correctly uncharge them when applications are
+running without limits and later on when limits are enforced during uncharging,
+otherwise usage count will drop to negative.
+
+Resource pool is destroyed if all the resource limits are set to max and
+it is the last resource getting deallocated.
+
+User should set all the limit to max value if it intents to remove/unconfigure
+the resource pool for a particular device.
+
+IB stack honors limits enforced by the rdma controller. When application
+query about maximum resource limits of IB device, it returns minimum of
+what is configured by user for a given cgroup and what is supported by
+IB device.
+
+Following resources can be accounted by rdma controller.
+  uctx		Maximum number of User Contexts
+  pd		Maximum number of Protection domains
+  ah		Maximum number of Address handles
+  mr		Maximum number of Memory Regions
+  mw		Maximum number of Memory Windows
+  cq		Maximum number of Completion Queues
+  srq		Maximum number of Shared Receive Queues
+  qp		Maximum number of Queue Pairs
+  flow		Maximum number of Flows
+
+
+2. Usage Examples
+-----------------
+
+(a) Configure resource limit:
+echo mlx4_0 mr=100 qp=10 ah=2 > /sys/fs/cgroup/rdma/1/rdma.max
+echo ocrdma1 mr=120 qp=20 cq=10 > /sys/fs/cgroup/rdma/2/rdma.max
+
+(b) Query resource limit:
+cat /sys/fs/cgroup/rdma/2/rdma.max
+#Output:
+mlx4_0 uctx=max pd=max ah=2 mr=100 mw=max cq=max srq=max qp=10 flow=max
+ocrdma1 uctx=1 pd=5 ah=1 mr=10 cq=10 srq=max qp=20 flow=max flow=max
+
+(c) Query current usage:
+cat /sys/fs/cgroup/rdma/2/rdma.current
+#Output:
+mlx4_0 uctx=1 pd=2 ah=2 mr=95 mw=0 cq=2 srq=0 qp=8 flow=0
+ocrdma1 uctx=1 pd=6 ah=9 mr=20 mw=0 cq=1 srq=0 qp=2 flow=0
+
+(d) Delete resource limit:
+echo mlx4_0 mr=max qp=max ah=max > /sys/fs/cgroup/rdma/1/rdma.max
diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 4cc07ce..cf5a3d3 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -47,6 +47,8 @@ CONTENTS
   5-3. IO
     5-3-1. IO Interface Files
     5-3-2. Writeback
+  5-4. RDMA
+    5-4-1. RDMA Interface Files
 6. Namespace
   6-1. Basics
   6-2. The Root and Views
@@ -1119,6 +1121,48 @@ writeback as follows.
 	vm.dirty[_background]_ratio.
 
 
+5-4. RDMA
+
+The "rdma" controller regulates the distribution and accounting of
+of RDMA resources.
+
+5-4-1. RDMA Interface Files
+
+  rdma.max
+	A readwrite file that exists for all the cgroups except root that
+	describes current configured resource limit for a RDMA/IB device.
+
+	Lines are keyed by device name and are not ordered.
+	Each line contains space separated resource name and its configured
+	limit that can be distributed.
+
+	Following keys are defined.
+
+	  uctx		Maximum number of User Contexts
+	  pd		Maximum number of Protection domains
+	  ah		Maximum number of Address handles
+	  mr		Maximum number of Memory Regions
+	  mw		Maximum number of Memory Windows
+	  cq		Maximum number of Completion Queues
+	  srq		Maximum number of Shared Receive Queues
+	  qp		Maximum number of Queue Pairs
+	  flow		Maximum number of Flows
+
+	An example for mlx4 and ocrdma device follows.
+
+	  mlx4_0 uctx=max pd=4 ah=2 mr=10 mw=max cq=1 srq=1 qp=10 flow=10
+	  ocrdma1 uctx=2 pd=2 ah=2 mr=20 mw=max cq=1 srq=1 qp=10 flow=10
+
+  rdma.current
+	A read-only file that describes current resource usage.
+	It exists for all the cgroup except root.
+
+	An example for mlx4 and ocrdma device follows.
+
+	  mlx4_1 uctx=1 ah=0 pd=1 cq=4 qp=4 mr=100 srq=0 flow=10
+	  ocrdma1 uctx=2 pd=2 ah=2 mr=20 mw=max cq=1 srq=1 qp=10 flow=10
+
+
 6. Namespace
 
 6-1. Basics
-- 
1.8.3.1

