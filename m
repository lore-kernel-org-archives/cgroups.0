From: Waiman Long <longman@redhat.com>
Subject: [PATCH v15 11/12] cpuset: Add documentation about the new "cpuset.sched.partition" flag
Date: Thu,  8 Nov 2018 10:08:45 -0500
Message-ID: <1541689726-20088-12-git-send-email-longman@redhat.com>
References: <1541689726-20088-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541689726-20088-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>, Waiman Long <longman@redhat.com>

The cgroup-v2.rst file is updated to document the purpose of the new
"cpuset.sched.partition" flag and how its usage.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 73 +++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 595b075..f83a523 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1708,6 +1708,79 @@ Cpuset Interface Files
 
 	Its value will be affected by memory nodes hotplug events.
 
+  cpuset.sched.partition
+	A read-write single value file which exists on non-root
+	cpuset-enabled cgroups.  This flag is owned by the parent cgroup
+	and is not delegatable.
+
+        It accepts only the following input values when written to.
+
+        "root" or "1"   - a paritition root
+        "member" or "0" - a non-root member of a partition
+
+	When set to be a partition root, the current cgroup is the
+	root of a new partition or scheduling domain that comprises
+	itself and all its descendants except those that are separate
+	partition roots themselves and their descendants.  The root
+	cgroup is always a partition root.
+
+	There are constraints on where a partition root can be set.
+	It can only be set in a cgroup if all the following conditions
+	are true.
+
+	1) The "cpuset.cpus" is not empty and the list of CPUs are
+	   exclusive, i.e. they are not shared by any of its siblings.
+	2) The parent cgroup is a partition root.
+	3) The "cpuset.cpus" is also a proper subset of the parent's
+	   "cpuset.cpus.effective".
+	4) There is no child cgroups with cpuset enabled.  This is for
+	   eliminating corner cases that have to be handled if such a
+	   condition is allowed.
+
+	Setting it to partition root will take the CPUs away from the
+	effective CPUs of the parent cgroup.  Once it is set, this
+	file cannot be reverted back to "member" if there are any child
+	cgroups with cpuset enabled.
+
+	A parent partition cannot distribute all its CPUs to its
+	child partitions.  There must be at least one cpu left in the
+	parent partition.
+
+	Once becoming a partition root, changes to "cpuset.cpus" is
+	generally allowed as long as the first condition above is true,
+	the change will not take away all the CPUs from the parent
+	partition and the new "cpuset.cpus" value is a superset of its
+	children's "cpuset.cpus" values.
+
+	Sometimes, external factors like changes to ancestors'
+	"cpuset.cpus" or cpu hotplug can cause the state of the partition
+	root to change.  On read, the "cpuset.sched.partition" file
+	can show the following values.
+
+	"member"       Non-root member of a partition
+	"root"         Partition root
+	"root invalid" Invalid partition root
+
+	It is a partition root if the first 2 partition root conditions
+	above are true and at least one CPU from "cpuset.cpus" is
+	granted by the parent cgroup.
+
+	A partition root can become invalid if none of CPUs requested
+	in "cpuset.cpus" can be granted by the parent cgroup or the
+	parent cgroup is no longer a partition root itself.  In this
+	case, it is not a real partition even though the restriction
+	of the first partition root condition above will still apply.
+	The cpu affinity of all the tasks in the cgroup will then be
+	associated with CPUs in the nearest ancestor partition.
+
+	An invalid partition root can be transitioned back to a
+	real partition root if at least one of the requested CPUs
+	can now be granted by its parent.  In this case, the cpu
+	affinity of all the tasks in the formerly invalid partition
+	will be associated to the CPUs of the newly formed partition.
+	Changing the partition state of an invalid partition root to
+	"member" is always allowed even if child cpusets are present.
+
 
 Device controller
 -----------------
-- 
1.8.3.1

