From: Waiman Long <longman@redhat.com>
Subject: [PATCH v6 5/6] cgroup/cpuset: Update description of cpuset.cpus.partition in cgroup-v2.rst
Date: Sat, 14 Aug 2021 16:57:42 -0400
Message-ID: <20210814205743.3039-6-longman@redhat.com>
References: <20210814205743.3039-1-longman@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628974707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=QJPO2HU5uJUFHj6f1j+HuYMopx4Bs0G4yXuHOyLGq7k=;
        b=jIyLWwCn2jUxsI27U/WiqWyrllbtVwAWRGRhwh7ctUsyeXpMQHoXj7Wlh4enmHX3kVDlo4
        t8juaSdspmb65hFF8H5uZP5xcI6iFIvZUdK5AcoEkdqZZPc33KqMd7W7YppCthMN62dnN6
        pxb3DoazH4TOC/jGOGRkJ9Neazfuud0=
In-Reply-To: <20210814205743.3039-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>

Update Documentation/admin-guide/cgroup-v2.rst on the newly introduced
"isolated" cpuset partition type as well as the ability to create
non-top cpuset partition with no cpu allocated to it.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 116 +++++++++++++++---------
 1 file changed, 71 insertions(+), 45 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index babbe04c8d37..9ad52f74fb12 100644
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
@@ -2101,64 +2102,89 @@ Cpuset Interface Files
 	partition roots themselves and their descendants.  The root
 	cgroup is always a partition root.
 
-	There are constraints on where a partition root can be set.
-	It can only be set in a cgroup if all the following conditions
-	are true.
+	When set to "isolated", the CPUs in that partition root will
+	be in an isolated state without any load balancing from the
+	scheduler.  Tasks in such a partition must be explicitly bound
+	to each individual CPU.
+
+	There are constraints on where a partition root can be set
+	("root" or "isolated").  It can only be set in a cgroup if all
+	the following conditions are true.
 
 	1) The "cpuset.cpus" is not empty and the list of CPUs are
 	   exclusive, i.e. they are not shared by any of its siblings.
 	2) The parent cgroup is a partition root.
-	3) The "cpuset.cpus" is also a proper subset of the parent's
+	3) The "cpuset.cpus" is a subset of the parent's
 	   "cpuset.cpus.effective".
 	4) There is no child cgroups with cpuset enabled.  This is for
 	   eliminating corner cases that have to be handled if such a
 	   condition is allowed.
 
-	Setting it to partition root will take the CPUs away from the
-	effective CPUs of the parent cgroup.  Once it is set, this
+	Setting it to a partition root will take the CPUs away from
+	the effective CPUs of the parent cgroup.  Once it is set, this
 	file cannot be reverted back to "member" if there are any child
 	cgroups with cpuset enabled.
 
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
+	A parent partition may distribute all its CPUs to its child
+	partitions as long as it is not the root cgroup and there is no
+	task directly associated with that parent partition.  Otherwise,
+	there must be at least one cpu left in the parent partition.
+	A new task cannot be moved to a partition root with no effective
+	cpu.
+
+	Once becoming a partition root, changes to "cpuset.cpus"
+	is generally allowed as long as the first condition above
+	(cpu exclusivity rule) is true.
+
+	Sometimes, changes to "cpuset.cpus" or cpu hotplug may cause
+	the state of the partition root to become invalid when the
+	other constraints of partition root are violated.  Therefore,
+	it is recommended that users should always set "cpuset.cpus"
+	to the proper value first before enabling partition.  In case
+	"cpuset.cpus" has to be modified after partition is enabled,
+	users should check the state of "cpuset.cpus.partition" after
+	making change to it to make sure that the partition is still
+	valid.
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
+	A partition root becomes invalid if all the CPUs requested in
+	"cpuset.cpus" become unavailable.  This can happen if all the
+	CPUs have been offlined, or the state of an ancestor partition
+	root become invalid. "<reason>" is a string that describes why
+	the partition becomes invalid.
+
+	An invalid partition is not a real partition even though the
+	restriction of the cpu exclusivity rule will still apply.
 	The cpu affinity of all the tasks in the cgroup will then be
 	associated with CPUs in the nearest ancestor partition.
 
-	An invalid partition root can be transitioned back to a
-	real partition root if at least one of the requested CPUs
-	can now be granted by its parent.  In this case, the cpu
-	affinity of all the tasks in the formerly invalid partition
-	will be associated to the CPUs of the newly formed partition.
-	Changing the partition state of an invalid partition root to
-	"member" is always allowed even if child cpusets are present.
+	In the special case of a parent partition competing with a child
+	partition for the only CPU left, the parent partition wins and
+	the child partition becomes invalid.
+
+	An invalid partition root can be transitioned back to a real
+	partition root if at least one of the requested CPUs become
+	available again. In this case, the cpu affinity of all the tasks
+	in the formerly invalid partition will be associated to the CPUs
+	of the newly formed partition.	Changing the partition state of
+	an invalid partition root to "member" is always allowed even if
+	child cpusets are present. However changing a partition root back
+	to member will not be allowed if child partitions are present.
+
+	Poll and inotify events are triggered whenever the state
+	of "cpuset.cpus.partition" changes.  That includes changes
+	caused by write to "cpuset.cpus.partition" and cpu hotplug.
+	This will allow an user space agent to monitor changes caused
+	by hotplug events.
 
 
 Device controller
-- 
2.18.1

