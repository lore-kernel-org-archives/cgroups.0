From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 5/6] cgroup/cpuset: Documentation update for partition
Date: Wed, 31 May 2023 12:34:04 -0400
Message-ID: <20230531163405.2200292-6-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685550856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vEOF8HrDImAV/WYXa7xNLQNUFj3sGLIQNJ3rM8mtWVY=;
        b=a6PQ4Nrtv7w/JHx0omlEB7NAx5IXd764ChH0XmDB634yifA/eP068r/b5eK31vclt10rm6
        XIiRoTVIZtgObCIpsRqzjkse4VwfZK6xy81c430x1WWJbuVGtjnlZcXfBz1pTlTc8kJt2I
        +5UI5kT7c8yC2YgdtRSvEn1PmQ+hwkg=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mrunal Patel <mpatel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Phillips <rphillips-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brent Rowsell <browsell-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Hunt <pehunt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patch updates the cgroup-v2.rst file to include information about
the new "cpuset.cpus.reserve" control file as well as the new remote
partition.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 92 +++++++++++++++++++++----
 1 file changed, 79 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index f67c0829350b..3e9351c2cd27 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2215,6 +2215,38 @@ Cpuset Interface Files
 
 	Its value will be affected by memory nodes hotplug events.
 
+  cpuset.cpus.reserve
+	A read-write multiple values file which exists only on root
+	cgroup.
+
+	It lists all the CPUs that are reserved for adjacent and remote
+	partitions created in the system.  See the next section for
+	more information on what an adjacent or remote partitions is.
+
+	Creation of adjacent partition does not require touching this
+	control file as CPU reservation will be done automatically.
+	In order to create a remote partition, the CPUs needed by the
+	remote partition has to be written to this file first.
+
+	Due to the fact that "cpuset.cpus.reserve" holds reserve CPUs
+	that can be used by multiple partitions and automatic reservation
+	may also race with manual reservation, an extension prefixes of
+	"+" and "-" are allowed for this file to reduce race.
+
+	A "+" prefix can be used to indicate a list of additional
+	CPUs that are to be added without disturbing the CPUs that are
+	originally there.  For example, if its current value is "3-4",
+	echoing ""+5" to it will change it to "3-5".
+
+	Once a remote partition is destroyed, its CPUs have to be
+	removed from this file or no other process can use them.  A "-"
+	prefix can be used to remove a list of CPUs from it.  However,
+	removing CPUs that are currently used in existing partitions
+	may cause those partitions to become invalid.  A single "-"
+	character without any number can be used to indicate removal
+	of all the free CPUs not yet allocated to any partitions to
+	avoid accidental partition invalidation.
+
   cpuset.cpus.partition
 	A read-write single value file which exists on non-root
 	cpuset-enabled cgroups.  This flag is owned by the parent cgroup
@@ -2228,25 +2260,49 @@ Cpuset Interface Files
 	  "isolated"	Partition root without load balancing
 	  ==========	=====================================
 
-	The root cgroup is always a partition root and its state
-	cannot be changed.  All other non-root cgroups start out as
-	"member".
+	A cpuset partition is a collection of cgroups with a partition
+	root at the top of the hierarchy and its descendants except
+	those that are separate partition roots themselves and their
+	descendants.  A partition has exclusive access to the set of
+	CPUs allocated to it.  Other cgroups outside of that partition
+	cannot use any CPUs in that set.
+
+	There are two types of partitions - adjacent and remote.  The
+	parent of an adjacent partition must be a valid partition root.
+	Partition roots of adjacent partitions are all clustered around
+	the root cgroup.  Creation of adjacent partition is done by
+	writing the desired partition type into "cpuset.cpus.partition".
+
+	A remote partition does not require a partition root parent.
+	So a remote partition can be formed far from the root cgroup.
+	However, its creation is a 2-step process.  The CPUs needed
+	by a remote partition ("cpuset.cpus" of the partition root)
+	has to be written into "cpuset.cpus.reserve" of the root
+	cgroup first.  After that, "isolated" can be written into
+	"cpuset.cpus.partition" of the partition root to form a remote
+	isolated partition which is the only supported remote partition
+	type for now.
+
+	All remote partitions are terminal as adjacent partition cannot
+	be created underneath it.  With the way remote partition is
+	formed, it is not possible to create another valid remote
+	partition underneath it.
+
+	The root cgroup is always a partition root and its state cannot
+	be changed.  All other non-root cgroups start out as "member".
 
 	When set to "root", the current cgroup is the root of a new
-	partition or scheduling domain that comprises itself and all
-	its descendants except those that are separate partition roots
-	themselves and their descendants.
+	partition or scheduling domain.
 
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
+	The value shown in "cpuset.cpus.effective" of a partition root is
+	the CPUs that are dedicated to that partition and not available
+	to cgroups outside of that partittion.
 
 	A partition root ("root" or "isolated") can be in one of the
 	two possible states - valid or invalid.  An invalid partition
@@ -2270,8 +2326,8 @@ Cpuset Interface Files
 	In the case of an invalid partition root, a descriptive string on
 	why the partition is invalid is included within parentheses.
 
-	For a partition root to become valid, the following conditions
-	must be met.
+	For an adjacent partition root to be valid, the following
+	conditions must be met.
 
 	1) The "cpuset.cpus" is exclusive with its siblings , i.e. they
 	   are not shared by any of its siblings (exclusivity rule).
@@ -2281,6 +2337,16 @@ Cpuset Interface Files
 	4) The "cpuset.cpus.effective" cannot be empty unless there is
 	   no task associated with this partition.
 
+	For a remote partition root to be valid, the following conditions
+	must be met.
+
+	1) The same exclusivity rule as adjacent partition root.
+	2) The "cpuset.cpus" is not empty and all the CPUs must be
+	   present in "cpuset.cpus.reserve" of the root cgroup and none
+	   of them are allocated to another partition.
+	3) The "cpuset.cpus" value must be present in all its ancestors
+	   to ensure proper hierarchical cpu distribution.
+
 	External events like hotplug or changes to "cpuset.cpus" can
 	cause a valid partition root to become invalid and vice versa.
 	Note that a task cannot be moved to a cgroup with empty
-- 
2.31.1

