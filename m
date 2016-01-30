From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv2 3/3] rdmacg: Added documentation for rdma controller
Date: Sat, 30 Jan 2016 17:11:27 +0530
Message-ID: <1454154087-27375-4-git-send-email-pandit.parav@gmail.com>
References: <1454154087-27375-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=vlW5DgSkWmFypYxRKC04ePhJ3Ad3aRGJhf1fcOGCoDQ=;
        b=Lkw904dCvm+JRsBL9vh89QT6OVHlo389JLAAZt+YmhKh3svU+H8HfGEaLSwnDNQHKc
         1DhTOwabXTbPS58QnPL6EzVeeck7turP9oujrqzGQ26dOqmZmxawb6xe3dXAxmyOwds0
         5juxsm44C61C1K1beoSUjZPhnQxO/yhBH+aS1l8XPss9b1yRT0eRasdWOb18PCnXdZ2Y
         CpISL96wBEOeSeZmqGCHYt2K8T2ZVKhPODgvWjd+eM+vjpIJkBt3IwZKjPrqsIN2SCfO
         RwYaTTMTVXTH9FtMTg8KYNM9JxjM0wVbH1Le9QoSoFe+oB6RDaQCqLp88D+kSu5z5mh0
         QaCQ==
In-Reply-To: <1454154087-27375-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

Added documentation for rdma controller to use in legacy mode and
using new unified hirerchy.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 Documentation/cgroup-v1/rdma.txt | 122 +++++++++++++++++++++++++++++++=
++++++++
 Documentation/cgroup-v2.txt      |  43 ++++++++++++++
 2 files changed, 165 insertions(+)
 create mode 100644 Documentation/cgroup-v1/rdma.txt

diff --git a/Documentation/cgroup-v1/rdma.txt b/Documentation/cgroup-v1=
/rdma.txt
new file mode 100644
index 0000000..240e34a
--- /dev/null
+++ b/Documentation/cgroup-v1/rdma.txt
@@ -0,0 +1,122 @@
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
+-------------------------------------
+
+RDMA controller allows user to limit RDMA/IB specific resources
+that a given set of processes can use. These processes are grouped usi=
ng
+RDMA controller.
+
+RDMA controller currently allows two different type of resource
+pools.
+(a) RDMA IB specification level verb resources defined by IB stack
+(b) HCA vendor device specific resources
+
+RDMA controller controller allows maximum of upto 64 resources in
+a resource pool which is the internal construct of rdma cgroup explain=
ed
+at later part of this document.
+
+1-2. Why RDMA controller needed?
+----------------------------------------
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
+resources described by IB uverbs layer and any HCA vendor driver can b=
e
+accounted.
+
+1-3. How is RDMA controller implemented?
+------------------------------------------------
+
+RDMA cgroup allows limit configuration of resources. These resources a=
re not
+defined by the rdma controller. Instead they are defined by the IB sta=
ck
+and HCA device drivers(optionally).
+This provides great flexibility to allow IB stack to define new resour=
ces,
+without any changes to rdma cgroup.
+Rdma cgroup maintains resource accounting per cgroup, per device, per =
resource
+type using resource pool structure. Each such resource pool is limited=
 up to
+64 resources in given resource pool by rdma cgroup, which can be exten=
ded
+later if required.
+
+This resource pool object is linked to the cgroup css. Typically there
+are 0 to 4 resource pool instances per cgroup, per device in most use =
cases.
+But nothing limits to have it more. At present hundreds of RDMA device=
s per
+single cgroup may not be handled optimally, however there is no known =
use case
+for such configuration either.
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
+otherwise usage count will drop to negative. This is done using defaul=
t
+resource pool. Instead of implementing any sort of time markers, defau=
lt pool
+simplifies the design.
+
+Resource pool is destroyed if it was of default type (not created
+by administrative operation) and it=E2=80=99s the last resource gettin=
g
+deallocated. Resource pool created as administrative operation is not
+deleted, as it=E2=80=99s expected to be used in near future.
+
+If user setting tries to delete all the resource limit
+with active resources per device, RDMA cgroup just marks the pool as
+default pool with maximum limits for each resource, otherwise it delet=
es the
+default resource pool.
+
+2. Usage Examples
+-----------------
+
+(a) Configure resource limit:
+echo mlx4_0 mr=3D100 qp=3D10 ah=3D2 > /sys/fs/cgroup/rdma/1/rdma.verb.=
max
+echo ocrdma1 mr=3D120 qp=3D20 cq=3D10 > /sys/fs/cgroup/rdma/2/rdma.ver=
b.max
+
+(b) Query resource limit:
+cat /sys/fs/cgroup/rdma/2/rdma.verb.max
+#Output:
+mlx4_0 mr=3D100 qp=3D10 ah=3D2
+ocrdma1 mr=3D120 qp=3D20 cq=3D10
+
+(c) Query current usage:
+cat /sys/fs/cgroup/rdma/2/rdma.verb.current
+#Output:
+mlx4_0 mr=3D95 qp=3D8 ah=3D2
+ocrdma1 mr=3D0 qp=3D20 cq=3D10
+
+(d) Delete resource limit:
+echo mlx4_0 remove > /sys/fs/cgroup/rdma/1/rdma.verb.max
+
+(e) Configure hw specific resource limit: (optional)
+echo vendor1 hw_qp=3D56 > /sys/fs/cgroup/rdma/2/rdma.hw.max
diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 31d1f7b..6741529 100644
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
@@ -1012,6 +1014,47 @@ writeback as follows.
 	total available memory and applied the same way as
 	vm.dirty[_background]_ratio.
=20
+5-4. RDMA
+
+The "rdma" controller regulates the distribution of RDMA resources.
+This controller implements both RDMA/IB verb level and RDMA HCA
+driver level resource distribution.
+
+5-4-1. RDMA Interface Files
+
+  rdma.verb.max
+	A readwrite file that exists for all the cgroups except root that
+	describes current configured verbs resource limit for a RDMA/IB devic=
e.
+
+	Lines are keyed by device name and are not ordered.
+	Each line contains space separated resource name and its configured
+	limit that can be distributed.
+
+	An example for mlx4 and ocrdma device follows.
+
+	  mlx4_0 mr=3D1000 qp=3D104 ah=3D2
+	  ocrdma1 mr=3D900 qp=3D89 cq=3D10
+
+  rdma.verb.current
+	A read-only file that describes current resource usage.
+	It exists for all the cgroup including root.
+
+	An example for mlx4 and ocrdma device follows.
+
+	  mlx4_0 mr=3D1000 qp=3D102 ah=3D2 flow=3D10 srq=3D0
+	  ocrdma1 mr=3D900 qp=3D79 cq=3D10 flow=3D0 srq=3D0
+
+  rdma.hw.max
+	A readwrite file that exists for all the cgroups except root that
+	describes current configured HCA hardware resource limit for a
+	RDMA/IB device.
+
+	Lines are keyed by device name and are not ordered.
+	Each line contains space separated resource name and its configured
+	limit that can be distributed.
+
+  rdma.hw.current
+	A read-only file that describes current resource usage.
=20
 P. Information on Kernel Programming
=20
--=20
1.8.3.1

