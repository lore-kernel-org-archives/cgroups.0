From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-cgroup v6 5/6] cgroup/cpuset: Documentation update for partition
Date: Tue, 15 Aug 2023 11:30:26 -0400
Message-ID: <20230815153027.633355-6-longman@redhat.com>
References: <20230815153027.633355-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692113454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cuqVxLpsIYLElZVQ73xju8tiYA7l9NmX4sCWRz6Oz8A=;
        b=KByLVunSBSn3etQdHM2xd7j9Kso2X2hH9ptj641uDJz+ZyNngC+ysw1D40DYmi0hnUiXSx
        YdqpAEebRAOf/l1MZwWx4NAbZW3wxlvHAFMaymfL4Xf1B0XFLADzYOQ5JSv0n/W+vOQm+s
        FHCyfmFYkaB1l9+K3ERcYiBKeKAyfyY=
In-Reply-To: <20230815153027.633355-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patch updates the cgroup-v2.rst file to include information about
the new "cpuset.cpus.exclusive" and "cpuset.cpus.excluisve.effective"
control files as well as the new remote partition type.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 123 ++++++++++++++++++------
 1 file changed, 91 insertions(+), 32 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b26b5274eaaf..e40b8560e002 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2226,6 +2226,49 @@ Cpuset Interface Files
 
 	Its value will be affected by memory nodes hotplug events.
 
+  cpuset.cpus.exclusive
+	A read-write multiple values file which exists on non-root
+	cpuset-enabled cgroups.
+
+	It lists all the exclusive CPUs that are allowed to be used
+	to create a new cpuset partition.  Its value is not used
+	unless the cgroup becomes a valid partition root.  See the
+	"cpuset.cpus.partition" section below for a description of what
+	a cpuset partition is.
+
+	When the cgroup becomes a partition root, the actual exclusive
+	CPUs that are allocated to that partition are listed in
+	"cpuset.cpus.exclusive.effective" which may be different
+	from "cpuset.cpus.exclusive".  If "cpuset.cpus.exclusive"
+	has previously been set, "cpuset.cpus.exclusive.effective"
+	is always a subset of it.
+
+	Users can manually set it to a value that is different from
+	"cpuset.cpus".	The only constraint in setting it is that the
+	list of CPUs must be exclusive with respect to its sibling.
+
+	For a parent cgroup, any one of its exclusive CPUs can only
+	be distributed to at most one of its child cgroups.  Having an
+	exclusive CPU appearing in two or more of its child cgroups is
+	not allowed (the exclusivity rule).  A value that violates the
+	exclusivity rule will be rejected with a write error.
+
+	The root cgroup is a partition root and all its available CPUs
+	are in its exclusive CPU set.
+
+  cpuset.cpus.exclusive.effective
+	A read-only multiple values file which exists on all non-root
+	cpuset-enabled cgroups.
+
+	This file shows the effective set of exclusive CPUs that
+	can be used to create a partition root.  The content of this
+	file will always be a subset of "cpuset.cpus" and its parent's
+	"cpuset.cpus.exclusive.effective" if its parent is not the root
+	cgroup.  It will also be a subset of "cpuset.cpus.exclusive"
+	if it is set.  If "cpuset.cpus.exclusive" is not set, it is
+	treated to have an implicit value of "cpuset.cpus" in the
+	formation of local partition.
+
   cpuset.cpus.partition
 	A read-write single value file which exists on non-root
 	cpuset-enabled cgroups.  This flag is owned by the parent cgroup
@@ -2239,26 +2282,41 @@ Cpuset Interface Files
 	  "isolated"	Partition root without load balancing
 	  ==========	=====================================
 
-	The root cgroup is always a partition root and its state
-	cannot be changed.  All other non-root cgroups start out as
-	"member".
+	A cpuset partition is a collection of cpuset-enabled cgroups with
+	a partition root at the top of the hierarchy and its descendants
+	except those that are separate partition roots themselves and
+	their descendants.  A partition has exclusive access to the
+	set of exclusive CPUs allocated to it.	Other cgroups outside
+	of that partition cannot use any CPUs in that set.
+
+	There are two types of partitions - local and remote.  A local
+	partition is one whose parent cgroup is also a valid partition
+	root.  A remote partition is one whose parent cgroup is not a
+	valid partition root itself.  Writing to "cpuset.cpus.exclusive"
+	is optional for the creation of a local partition as its
+	"cpuset.cpus.exclusive" file will assume an implicit value that
+	is the same as "cpuset.cpus" if it is not set.	Writing the
+	proper "cpuset.cpus.exclusive" values down the cgroup hierarchy
+	before the target partition root is mandatory for the creation
+	of a remote partition.
+
+	Currently, a remote partition cannot be created under a local
+	partition.  All the ancestors of a remote partition root except
+	the root cgroup cannot be a partition root.
+
+	The root cgroup is always a partition root and its state cannot
+	be changed.  All other non-root cgroups start out as "member".
 
 	When set to "root", the current cgroup is the root of a new
-	partition or scheduling domain that comprises itself and all
-	its descendants except those that are separate partition roots
-	themselves and their descendants.
+	partition or scheduling domain.  The set of exclusive CPUs is
+	determined by the value of its "cpuset.cpus.exclusive.effective".
 
-	When set to "isolated", the CPUs in that partition root will
+	When set to "isolated", the CPUs in that partition will
 	be in an isolated state without any load balancing from the
 	scheduler.  Tasks placed in such a partition with multiple
 	CPUs should be carefully distributed and bound to each of the
 	individual CPUs for optimal performance.
 
-	The value shown in "cpuset.cpus.effective" of a partition root
-	is the CPUs that the partition root can dedicate to a potential
-	new child partition root. The new child subtracts available
-	CPUs from its parent "cpuset.cpus.effective".
-
 	A partition root ("root" or "isolated") can be in one of the
 	two possible states - valid or invalid.  An invalid partition
 	root is in a degraded state where some state information may
@@ -2281,37 +2339,33 @@ Cpuset Interface Files
 	In the case of an invalid partition root, a descriptive string on
 	why the partition is invalid is included within parentheses.
 
-	For a partition root to become valid, the following conditions
+	For a local partition root to be valid, the following conditions
 	must be met.
 
-	1) The "cpuset.cpus" is exclusive with its siblings , i.e. they
-	   are not shared by any of its siblings (exclusivity rule).
-	2) The parent cgroup is a valid partition root.
-	3) The "cpuset.cpus" is not empty and must contain at least
-	   one of the CPUs from parent's "cpuset.cpus", i.e. they overlap.
-	4) The "cpuset.cpus.effective" cannot be empty unless there is
+	1) The parent cgroup is a valid partition root.
+	2) The "cpuset.cpus.exclusive.effective" file cannot be empty,
+	   though it may contain offline CPUs.
+	3) The "cpuset.cpus.effective" cannot be empty unless there is
 	   no task associated with this partition.
 
-	External events like hotplug or changes to "cpuset.cpus" can
-	cause a valid partition root to become invalid and vice versa.
-	Note that a task cannot be moved to a cgroup with empty
-	"cpuset.cpus.effective".
+	For a remote partition root to be valid, all the above conditions
+	except the first one must be met.
 
-	For a valid partition root with the sibling cpu exclusivity
-	rule enabled, changes made to "cpuset.cpus" that violate the
-	exclusivity rule will invalidate the partition as well as its
-	sibling partitions with conflicting cpuset.cpus values. So
-	care must be taking in changing "cpuset.cpus".
+	External events like hotplug or changes to "cpuset.cpus" or
+	"cpuset.cpus.exclusive" can cause a valid partition root to
+	become invalid and vice versa.	Note that a task cannot be
+	moved to a cgroup with empty "cpuset.cpus.effective".
 
 	A valid non-root parent partition may distribute out all its CPUs
-	to its child partitions when there is no task associated with it.
+	to its child local partitions when there is no task associated
+	with it.
 
-	Care must be taken to change a valid partition root to
-	"member" as all its child partitions, if present, will become
+	Care must be taken to change a valid partition root to "member"
+	as all its child local partitions, if present, will become
 	invalid causing disruption to tasks running in those child
 	partitions. These inactivated partitions could be recovered if
 	their parent is switched back to a partition root with a proper
-	set of "cpuset.cpus".
+	value in "cpuset.cpus" or "cpuset.cpus.exclusive".
 
 	Poll and inotify events are triggered whenever the state of
 	"cpuset.cpus.partition" changes.  That includes changes caused
@@ -2321,6 +2375,11 @@ Cpuset Interface Files
 	to "cpuset.cpus.partition" without the need to do continuous
 	polling.
 
+	A user can pre-configure certain CPUs to an isolated state
+	with load balancing disabled at boot time with the "isolcpus"
+	kernel boot command line option.  If those CPUs are to be put
+	into a partition, they have to be used in an isolated partition.
+
 
 Device controller
 -----------------
-- 
2.31.1

