From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 5/6] cgroup/cpuset: Update description of cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 21 Jun 2021 14:49:23 -0400
Message-ID: <20210621184924.27493-6-longman@redhat.com>
References: <20210621184924.27493-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624301396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=swO++E6Xe5gmahVfon/2vkT+NXylz10k5vVf6UUkIHE=;
        b=KBZ8iSgFoiv5EsYTpCoREpjBSWc/xhOrTPvWg6W/49u5B0a8ZwnykG/PhHcDHX0M7cYB+V
        2yvBN5i1/MTzAk8AM2jndSdBY6ADaJcgiZz2T1n1V4mcszawO2FGpYAKssufo5sYwujhDp
        Of2NMmMrlyUSavQXL81RFdpQowORdLQ=
In-Reply-To: <20210621184924.27493-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Update Documentation/admin-guide/cgroup-v2.rst on the newly introduced
"isolated" cpuset partition type as well as the ability to create
non-top cpuset partition with no cpu allocated to it.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 65 +++++++++++++++++--------
 1 file changed, 44 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b1e81aa8598a..cf40a7f499c0 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2010,8 +2010,9 @@ Cpuset Interface Files
 	It accepts only the following input values when written to.
 
 	  ========	================================
-	  "root"	a partition root
-	  "member"	a non-root member of a partition
+	  "member"	Non-root member of a partition
+	  "root"	Partition root
+	  "isolated"	Partition root without load balancing
 	  ========	================================
 
 	When set to be a partition root, the current cgroup is the
@@ -2020,6 +2021,11 @@ Cpuset Interface Files
 	partition roots themselves and their descendants.  The root
 	cgroup is always a partition root.
 
+	With "isolated", the CPUs in that partition root will be in an
+	isolated state without any load balancing from the scheduler.
+	Tasks in such a partition must be explicitly bind to each
+	individual CPU.
+
 	There are constraints on where a partition root can be set.
 	It can only be set in a cgroup if all the following conditions
 	are true.
@@ -2038,12 +2044,25 @@ Cpuset Interface Files
 	file cannot be reverted back to "member" if there are any child
 	cgroups with cpuset enabled.
 
-	A parent partition cannot distribute all its CPUs to its
-	child partitions.  There must be at least one cpu left in the
-	parent partition.
+	A parent partition may distribute all its CPUs to its child
+	partitions as long as it is not the root cgroup and there is no
+	task directly associated with that parent partition.  Otherwise,
+	there must be at least one cpu left in the parent partition.
+	A new task cannot be moved to a partition root with no effective
+	cpu.
 
 	Once becoming a partition root, changes to "cpuset.cpus" is
-	generally allowed as long as the first condition above is true,
+	generally allowed as long as the first condition above is true.
+	Other constraints for this operation are as follows.
+
+	1) Any newly added CPUs must be a subset of the parent's
+	   "cpuset.cpus.effective".
+	2) Taking away all the CPUs from the parent's "cpuset.cpus.effective"
+	   is only allowed if there is no task associated with the
+	   parent partition.
+	3) Deletion of CPUs that have been distributed to child partition
+	   roots are not allowed.
+
 	the change will not take away all the CPUs from the parent
 	partition and the new "cpuset.cpus" value is a superset of its
 	children's "cpuset.cpus" values.
@@ -2056,6 +2075,7 @@ Cpuset Interface Files
 	  ==============	==============================
 	  "member"		Non-root member of a partition
 	  "root"		Partition root
+	  "isolated"		Partition root without load balancing
 	  "root invalid"	Invalid partition root
 	  ==============	==============================
 
@@ -2063,21 +2083,24 @@ Cpuset Interface Files
 	above are true and at least one CPU from "cpuset.cpus" is
 	granted by the parent cgroup.
 
-	A partition root can become invalid if none of CPUs requested
-	in "cpuset.cpus" can be granted by the parent cgroup or the
-	parent cgroup is no longer a partition root itself.  In this
-	case, it is not a real partition even though the restriction
-	of the first partition root condition above will still apply.
-	The cpu affinity of all the tasks in the cgroup will then be
-	associated with CPUs in the nearest ancestor partition.
-
-	An invalid partition root can be transitioned back to a
-	real partition root if at least one of the requested CPUs
-	can now be granted by its parent.  In this case, the cpu
-	affinity of all the tasks in the formerly invalid partition
-	will be associated to the CPUs of the newly formed partition.
-	Changing the partition state of an invalid partition root to
-	"member" is always allowed even if child cpusets are present.
+	A partition root becomes invalid if all the CPUs requested in
+	"cpuset.cpus" become unavailable.  This can happen if all the
+	CPUs have been offlined, or the state of an ancestor partition
+	root become invalid.  In this case, it is not a real partition
+	even though the restriction of the first partition root condition
+	above will still apply.  The cpu affinity of all the tasks in
+	the cgroup will then be associated with CPUs in the nearest
+	ancestor partition.  In the special case of a parent partition
+	competing with a child partition for the only CPU left, the
+	parent partition wins and the child partition becomes invalid.
+
+	An invalid partition root can be transitioned back to a real
+	partition root if at least one of the requested CPUs become
+	available again. In this case, the cpu affinity of all the
+	tasks in the formerly invalid partition will be associated to
+	the CPUs of the newly formed partition.  Changing the partition
+	state of an invalid partition root to "member" is always allowed
+	even if child cpusets are present.
 
 
 Device controller
-- 
2.18.1

