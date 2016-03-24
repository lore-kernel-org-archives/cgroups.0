From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv10 3/3] rdmacg: Added documentation for rdmacg
Date: Fri, 25 Mar 2016 01:52:42 +0530
Message-ID: <1458850962-16057-4-git-send-email-pandit.parav@gmail.com>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bfQGrT6n9ygwkXoZOzcpG4GwZpFwg0Znp2xl5OkPOC0=;
        b=qh2ZaE0y3it71LwvuL11BTgBBTMaC+oYK8khezZTt4Kso4r0+z7f4hbPHf+GJvroeS
         +R41IUnO7o9HREqFQ3GodXluGpdZZv5bjLcHW4gVK2THjDr2LBMq4yAA5heIl39/BeCk
         hoKOP6qLHgfYR1XlcFOq7iQgt8pxdWSDXVngTvhiTp9b42JVxm2V3X066g2kAi3J10mA
         KVAJKaAEniBaVKNPUshfiOY2dxNax0xr2cKcnCXFB0N7iIpuH++oNtaNJbnjoQOjvKLC
         mNdlEQ204A6BSHYTSlgmJz98GS284uHETujtjEoBAkgSXVQMefjx+MJM028Fw8X3e1OK
         rVmw==
In-Reply-To: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

Added documentation for v1 and v2 version describing high
level design and usage examples on using rdma controller.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 Documentation/cgroup-v1/rdma.txt | 123 +++++++++++++++++++++++++++++++=
++++++++
 Documentation/cgroup-v2.txt      |  43 ++++++++++++++
 2 files changed, 166 insertions(+)
 create mode 100644 Documentation/cgroup-v1/rdma.txt

diff --git a/Documentation/cgroup-v1/rdma.txt b/Documentation/cgroup-v1=
/rdma.txt
new file mode 100644
index 0000000..f5e0a54
--- /dev/null
+++ b/Documentation/cgroup-v1/rdma.txt
@@ -0,0 +1,123 @@
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
+RDMA controller allows user to limit RDMA/IB specific resources
+that a given set of processes can use. These processes are grouped usi=
ng
+RDMA controller.
+
+RDMA controller allows operating on resources defined by the IB stack
+which are mainly IB verb resources and in future hardware specific
+well defined resources.
+
+1-2. Why RDMA controller needed?
+--------------------------------
+
+Currently user space applications can easily take away all the rdma de=
vice
+specific resources such as AH, CQ, QP, MR etc. Due to which other appl=
ications
+in other cgroup or kernel space ULPs may not even get chance to alloca=
te any
+rdma resources. This leads to service unavailability.
+
+Therefore RDMA controller is needed through which resource consumption
+of processes can be limited. Through this controller various different=
 rdma
+resources described by IB stack can be accounted.
+
+1-3. How is RDMA controller implemented?
+----------------------------------------
+
+RDMA cgroup allows limit configuration of resources. These resources a=
re not
+defined by the rdma controller. Instead they are defined by the IB sta=
ck.
+This provides great flexibility to allow IB stack to define additional
+resources without any changes to rdma cgroup.
+Rdma cgroup maintains resource accounting per cgroup, per device using
+resource pool structure. Each such resource pool is limited up to
+64 resources in given resource pool by rdma cgroup, which can be exten=
ded
+later if required.
+
+This resource pool object is linked to the cgroup css. Typically there
+are 0 to 4 resource pool instances per cgroup, per device in most use =
cases.
+But nothing limits to have it more. At present hundreds of RDMA device=
s per
+single cgroup may not be handled optimally, however there is no
+known use case for such configuration either.
+
+Since RDMA resources can be allocated from any process and can be free=
d by any
+of the child processes which shares the address space, rdma resources =
are
+always owned by the creator cgroup css. This allows process migration =
from one
+to other cgroup without major complexity of transferring resource owne=
rship;
+because such ownership is not really present due to shared nature of
+rdma resources. Linking resources around css also ensures that cgroups=
 can be
+deleted after processes migrated. This allow progress migration as wel=
l with
+active resources, even though that=E2=80=99s not the primary use case.
+
+Whenever RDMA resource charing occurs, owner rdma cgroup is returned t=
o
+the caller. Same rdma cgroup should be passed while uncharging the res=
ource.
+This also allows process migrated with active RDMA resource to charge
+to new owner cgroup for new resource. It also allows to uncharge resou=
rce of
+a process from previously charged cgroup which is migrated to new cgro=
up,
+even though that is not a primary use case.
+
+Resource pool object is created in following situations.
+(a) User sets the limit and no previous resource pool exist for the de=
vice
+of interest for the cgroup.
+(b) No resource limits were configured, but IB/RDMA stack tries to
+charge the resource. So that it correctly uncharge them when applicati=
ons are
+running without limits and later on when limits are enforced during un=
charging,
+otherwise usage count will drop to negative.
+
+Resource pool is destroyed if it all the resource limits are set to ma=
x
+and it is the last resource getting deallocated.
+
+User should set all the limit to max value if it intents to remove/unc=
onfigure
+the resource pool for a particular device.
+
+IB stack honors limits enforced by the rdma controller. When applicati=
on
+query about maximum resource limits of IB device, it returns minimum o=
f
+what is configured by user for a given cgroup and what is supported by
+IB device.
+
+Following resources can be accounted.
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
+echo mlx4_0 mr=3D100 qp=3D10 ah=3D2 > /sys/fs/cgroup/rdma/1/rdma.max
+echo ocrdma1 mr=3D120 qp=3D20 cq=3D10 > /sys/fs/cgroup/rdma/2/rdma.max
+
+(b) Query resource limit:
+cat /sys/fs/cgroup/rdma/2/rdma.max
+#Output:
+mlx4_0 uctx=3Dmax pd=3Dmax ah=3D2 mr=3D100 mw=3Dmax cq=3Dmax srq=3Dmax=
 qp=3D10 flow=3Dmax
+ocrdma1 uctx=3D1 pd=3D5 ah=3D1 mr=3D10 cq=3D10 srq=3Dmax qp=3D20 flow=3D=
max flow=3Dmax
+
+(c) Query current usage:
+cat /sys/fs/cgroup/rdma/2/rdma.current
+#Output:
+mlx4_0 uctx=3D1 pd=3D2 ah=3D2 mr=3D95 mw=3D0 cq=3D2 srq=3D0 qp=3D8 flo=
w=3D0
+ocrdma1 uctx=3D1 pd=3D6 ah=3D9 mr=3D20 mw=3D0 cq=3D1 srq=3D0 qp=3D2 fl=
ow=3D0
+
+(d) Delete resource limit:
+echo mlx4_0 mr=3Dmax qp=3Dmax ah=3Dmax > /sys/fs/cgroup/rdma/1/rdma.ma=
x
diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index ff49cf9..b3e0712 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -47,6 +47,8 @@ CONTENTS
   5-3. IO
     5-3-1. IO Interface Files
     5-3-2. Writeback
+  5-4. RDMA
+    5-4-1. RDMA Interface Files
 P. Information on Kernel Programming
   P-1. Filesystem Support for Writeback
 D. Deprecated v1 Core Features
@@ -1088,6 +1090,47 @@ writeback as follows.
 	total available memory and applied the same way as
 	vm.dirty[_background]_ratio.
=20
+5-4. RDMA
+
+The "rdma" controller regulates the distribution of RDMA resources.
+This controller implements resource accounting of resources defined
+by IB stack.
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
+	  mlx4_0 uctx=3Dmax pd=3D4 ah=3D2 mr=3D10 mw=3Dmax cq=3D1 srq=3D1 qp=3D=
10 flow=3D10
+	  ocrdma1 uctx=3D2 pd=3D2 ah=3D2 mr=3D20 mw=3Dmax cq=3D1 srq=3D1 qp=3D=
10 flow=3D10
+
+  rdma.current
+	A read-only file that describes current resource usage.
+	It exists for all the cgroup except root.
+
+	An example for mlx4 and ocrdma device follows.
+
+	  mlx4_1 uctx=3D1 ah=3D0 pd=3D1 cq=3D4 qp=3D4 mr=3D100 srq=3D0 flow=3D=
10
+	  ocrdma1 uctx=3D2 pd=3D2 ah=3D2 mr=3D20 mw=3Dmax cq=3D1 srq=3D1 qp=3D=
10 flow=3D10
=20
 P. Information on Kernel Programming
=20
--=20
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
