From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv7 3/3] rdmacg: Added documentation for rdmacg
Date: Sun, 28 Feb 2016 19:43:41 +0530
Message-ID: <1456668821-25799-4-git-send-email-pandit.parav@gmail.com>
References: <1456668821-25799-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9wRP/4/RoA2AREABZB2yyZt76rTVqAB18qvcD+/gLA=;
        b=vj5zpSm3nsgewWks8k5Yv0tXRk7vDWJV7bLCFzkVWsitIOL/bod75RJ1ok1ntm1+33
         Nus800ucs+GryZHAMVqp48EvlykLcSEWmFVBzA1BNrik38tqu21E9Mo+Zu1zl0P/gXE8
         02zz0HKoWgtCFyslCVnWspfFnvC4txbkBCrb4o96oJKTsPV2oKe8e+H3smAo7RkrzoOJ
         lk+tcv8pvaBpigiPxBzs34Efc0BXTZcleOsOJZgR9SY82B9l4AeGdQsNkUilA50evEEC
         7tGK3CdqHGn369vxMmrjA/MXZk8TEbxmT35sZkHRemnAmCh5eyr4xsDOojikuzbFzVKq
         fZCg==
In-Reply-To: <1456668821-25799-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Added documentation for v1 and v2 version describing high
level design and usage examples on using rdma controller.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/cgroup-v1/rdma.txt | 111 +++++++++++++++++++++++++++++++=
++++++++
 Documentation/cgroup-v2.txt      |  33 ++++++++++++
 2 files changed, 144 insertions(+)
 create mode 100644 Documentation/cgroup-v1/rdma.txt

diff --git a/Documentation/cgroup-v1/rdma.txt b/Documentation/cgroup-v1=
/rdma.txt
new file mode 100644
index 0000000..1973502
--- /dev/null
+++ b/Documentation/cgroup-v1/rdma.txt
@@ -0,0 +1,111 @@
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
+This provides great flexibility to allow IB stack to define new resour=
ces,
+without any changes to rdma cgroup.
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
+mlx4_0 mr=3D100 qp=3D10 ah=3D2 pd=3Dmax
+ocrdma1 mr=3D120 qp=3D20 cq=3D10 pd=3Dmax ah=3Dmax
+
+(c) Query current usage:
+cat /sys/fs/cgroup/rdma/2/rdma.current
+#Output:
+mlx4_0 mr=3D95 qp=3D8 ah=3D2
+ocrdma1 mr=3D0 qp=3D20 cq=3D10
+
+(d) Delete resource limit:
+echo mlx4_0 mr=3Dmax qp=3Dmax ah=3Dmax > /sys/fs/cgroup/rdma/1/rdma.ma=
x
diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index ff49cf9..0ec4605 100644
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
@@ -1088,6 +1090,37 @@ writeback as follows.
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
+	An example for mlx4 and ocrdma device follows.
+
+	  mlx4_0 ah=3D2 mr=3D1000 qp=3D104
+	  ocrdma1 cq=3D10 mr=3D900 qp=3D89
+	  mlx4_1 uctx=3Dmax ah=3Dmax pd=3Dmax cq=3Dmax qp=3Dmax
+
+  rdma.current
+	A read-only file that describes current resource usage.
+	It exists for all the cgroup except root.
+
+	An example for mlx4 and ocrdma device follows.
+
+	  mlx4_0 mr=3D1000 qp=3D102 ah=3D2 flow=3D10 srq=3D0
+	  ocrdma1 mr=3D900 qp=3D79 cq=3D10 flow=3D0 srq=3D0
+	  mlx4_1 uctx=3Dmax ah=3Dmax pd=3Dmax cq=3Dmax qp=3Dmax
=20
 P. Information on Kernel Programming
=20
--=20
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
