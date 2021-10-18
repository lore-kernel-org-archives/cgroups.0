From: Waiman Long <longman@redhat.com>
Subject: [PATCH v8 5/6] cgroup/cpuset: Update description of cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 18 Oct 2021 10:36:18 -0400
Message-ID: <20211018143619.205065-6-longman@redhat.com>
References: <20211018143619.205065-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634567973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fgzu0/Idcc1GRywORkD/Fdq2hd78xuyZG5CB+CLyV8c=;
        b=RCFgydivd+lQuvC4aOx8izcKaa2zNJ7y916uB578+2y7s1DvhH6L+tzoWbMPFy1ycp4yLp
        aYVfAXJXIJLh12RcUNnsbD6YgaBtwWyBBjRnhcNoUMi0+axcwDjIAGhZM+xd4XJOD6swlB
        8F1Rz9Qm+2g8LvGhRnlXVYIzNxTOWXw=
In-Reply-To: <20211018143619.205065-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>

Update Documentation/admin-guide/cgroup-v2.rst on the newly introduced
"isolated" cpuset partition type as well as other changes made in other
cpuset patches.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 153 ++++++++++++++----------
 1 file changed, 93 insertions(+), 60 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 4d8c27eca96b..40d39562a8dd 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2091,8 +2091,9 @@ Cpuset Interface Files
 	It accepts only the following input values when written to.
 
 	  ========	================================
-	  "root"	a partition root
-	  "member"	a non-root member of a partition
+	  "member"	Non-root member of a partition
+	  "root"	Partition root
+	  "isolated"	Partition root without load balancing
 	  ========	================================
 
 	When set to be a partition root, the current cgroup is the
@@ -2101,64 +2102,96 @@ Cpuset Interface Files
 	partition roots themselves and their descendants.  The root
 	cgroup is always a partition root.
 
-	There are constraints on where a partition root can be set.
-	It can only be set in a cgroup if all the following conditions
-	are true.
-
-	1) The "cpuset.cpus" is not empty and the list of CPUs are
-	   exclusive, i.e. they are not shared by any of its siblings.
-	2) The parent cgroup is a partition root.
-	3) The "cpuset.cpus" is also a proper subset of the parent's
-	   "cpuset.cpus.effective".
-	4) There is no child cgroups with cpuset enabled.  This is for
-	   eliminating corner cases that have to be handled if such a
-	   condition is allowed.
-
-	Setting it to partition root will take the CPUs away from the
-	effective CPUs of the parent cgroup.  Once it is set, this
-	file cannot be reverted back to "member" if there are any child
-	cgroups with cpuset enabled.
-
-	A parent partition cannot distribute all its CPUs to its
-	child partitions.  There must be at least one cpu left in the
-	parent partition.
-
-	Once becoming a partition root, changes to "cpuset.cpus" is
-	generally allowed as long as the first condition above is true,
-	the change will not take away all the CPUs from the parent
-	partition and the new "cpuset.cpus" value is a superset of its
-	children's "cpuset.cpus" values.
-
-	Sometimes, external factors like changes to ancestors'
-	"cpuset.cpus" or cpu hotplug can cause the state of the partition
-	root to change.  On read, the "cpuset.sched.partition" file
-	can show the following values.
-
-	  ==============	==============================
-	  "member"		Non-root member of a partition
-	  "root"		Partition root
-	  "root invalid"	Invalid partition root
-	  ==============	==============================
-
-	It is a partition root if the first 2 partition root conditions
-	above are true and at least one CPU from "cpuset.cpus" is
-	granted by the parent cgroup.
-
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
+	When set to "isolated", the CPUs in that partition root will
+	be in an isolated state without any load balancing from the
+	scheduler.  Tasks in such a partition must be explicitly bound
+	to each individual CPU.
+
+	"cpuset.cpus" must always be set up first before enabling
+	partition.  Unlike "member" whose "cpuset.cpus.effective" can
+	contain CPUs not in "cpuset.cpus", this can never happen with a
+	valid partition root.  In other words, "cpuset.cpus.effective"
+	is always a subset of "cpuset.cpus" for a valid partition root.
+
+	When a parent partition root cannot exclusively grant any of
+	the CPUs specified in "cpuset.cpus", "cpuset.cpus.effective"
+	becomes empty. If there are tasks in the partition root, the
+	partition root becomes invalid and "cpuset.cpus.effective"
+	is reset to that of the nearest non-empty ancestor.
+
+        Note that a task cannot be moved to a cgroup with empty
+        "cpuset.cpus.effective".
+
+	There are additional constraints on where a partition root can
+	be enabled ("root" or "isolated").  It can only be enabled in
+	a cgroup if all the following conditions are met.
+
+	1) The "cpuset.cpus" is non-empty and exclusive, i.e. they are
+	   not shared by any of its siblings.
+	2) The parent cgroup is a valid partition root.
+	3) The "cpuset.cpus" is a subset of parent's "cpuset.cpus".
+	4) There is no child cgroups with cpuset enabled.  This avoids
+	   cpu migrations of multiple cgroups simultaneously which can
+	   be problematic.
+
+	On read, the "cpuset.cpus.partition" file can show the following
+	values.
+
+	  ======================	==============================
+	  "member"			Non-root member of a partition
+	  "root"			Partition root
+	  "isolated"			Partition root without load balancing
+	  "root invalid (<reason>)"	Invalid partition root
+	  ======================	==============================
+
+        In the case of an invalid partition root, a descriptive string on
+        why the partition is invalid is included within parentheses.
+
+	Once becoming a partition root, changes to "cpuset.cpus"
+	is generally allowed as long as the cpu list is exclusive,
+	non-empty and is a superset of children's cpu lists.
+
+        The constraints of a valid partition root are as follows:
+
+        1) The parent cgroup is a valid partition root.
+        2) "cpuset.cpus.effective" is a subset of "cpuset.cpus"
+        3) "cpuset.cpus.effective" is non-empty when there are tasks
+           in the partition.
+
+	Changes to "cpuset.cpus" or cpu hotplug may cause the state
+	of a valid partition root to become invalid when one or more
+	constraints of a valid partition root are violated.  Therefore,
+	user space agents that manage partition roots should avoid
+	unnecessary changes to "cpuset.cpus" and always check the state
+	of "cpuset.cpus.partition" after making changes to make sure
+	that the partitions are functioning properly as expected.
+
+        Changing a partition root to "member" is always allowed.
+        If there are child partition roots underneath it, however,
+        they will be forced to be switched back to "member" too and
+        lose their partitions. So care must be taken to double check
+        for this condition before disabling a partition root.
+
+	Setting a cgroup to a valid partition root will take the CPUs
+	away from the effective CPUs of the parent partition.
+
+	A valid parent partition may distribute out all its CPUs to
+	its child partitions as long as it is not the root cgroup as
+	we need some house-keeping CPUs in the root cgroup.
+
+	An invalid partition is not a real partition even though some
+	internal states may still be kept.
+
+	An invalid partition root can be reverted back to a real
+	partition root if none of the constraints of a valid partition
+        root are violated.
+
+	Poll and inotify events are triggered whenever the state of
+	"cpuset.cpus.partition" changes.  That includes changes caused by
+	write to "cpuset.cpus.partition", cpu hotplug and other changes
+	that make the partition invalid.  This will allow user space
+	agents to monitor unexpected changes to "cpuset.cpus.partition"
+	without the need to do continuous polling.
 
 
 Device controller
-- 
2.27.0

