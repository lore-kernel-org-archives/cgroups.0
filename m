From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv12 3/3] rdmacg: Added documentation for rdmacg
Date: Wed, 31 Aug 2016 14:07:27 +0530
Message-ID: <1472632647-1525-4-git-send-email-pandit.parav@gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A2bLPqG7hdUgF9m7Crx61pbm1q3X+WotQDKEtxUB8LY=;
        b=CBCtMjXuG9USPob/kxbAfhVtvV9C9Ey6PaKOPUbVwI9+ulULMCnRxUQKk7ha3dML0y
         /3LTOnLqiM7bQrS2mn9TcZxWb1KXPmrOA1nPoHMWoYh9UG74fuAopMaG9nSV9o2aZnfh
         CM0nNsN3LajultmeaYrk6l6Ves2pq86yJsza5K4OeLRSq3rzD3lWdit7lQQgiwZ8LYU1
         CHJkz8mpEX4NHeV/uJOzcTOe55MDwpsqc4XK3U8sH2Bk6q7aCq36yi7ib6mextHNa+PL
         pJoeQxIyKD8UH4ldxrXH641X9LbKcE+8xS6G4o0tnLS0f8jl2tpMACSzfAvFiSYef9ya
         Xg+A==
In-Reply-To: <1472632647-1525-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Added documentation for v1 and v2 version describing high
level design and usage examples on using rdma controller.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/cgroup-v1/rdma.txt | 117 +++++++++++++++++++++++++++++++++++++++
 Documentation/cgroup-v2.txt      |  45 +++++++++++++++
 2 files changed, 162 insertions(+)
 create mode 100644 Documentation/cgroup-v1/rdma.txt

diff --git a/Documentation/cgroup-v1/rdma.txt b/Documentation/cgroup-v1/rdma.txt
new file mode 100644
index 0000000..28cb59e
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
+Whenever RDMA resource charging occurs, owner rdma cgroup is returned to
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
+ocrdma1 uctx=max pd=max ah=max mr=120 mw=max cq=10 srq=max qp=20 flow=max
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
index 4cc07ce..ca63a31 100644
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
@@ -1119,6 +1121,49 @@ writeback as follows.
 	vm.dirty[_background]_ratio.
 
 
+5-4. RDMA
+
+The "rdma" controller regulates the distribution and accounting of
+of RDMA resources.
+
+5-4-1. RDMA Interface Files
+
+  rdma.max
+	A readwrite nested-keyed file that exists for all the cgroups
+	except root that describes current configured resource limit
+	for a RDMA/IB device.
+
+	Lines are keyed by device name and are not ordered.
+	Each line contains space separated resource name and its configured
+	limit that can be distributed.
+
+	The following nested keys are defined.
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
