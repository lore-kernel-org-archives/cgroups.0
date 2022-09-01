From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 09/10] cgroup/cpuset: Update description of cpuset.cpus.partition in cgroup-v2.rst
Date: Thu,  1 Sep 2022 16:57:44 -0400
Message-ID: <20220901205745.323326-10-longman@redhat.com>
References: <20220901205745.323326-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662065905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/+BOFxKtfEYIp1xfbpo0BmE2Lq5ufdARuesMCqu4C0=;
        b=NfkvKBmF4n0i4X92lNANzSRKSfvEW61PoYjsJOLW1XKxAIv6ZkBY6JWZzDw25d2QrQ+Vuc
        uuT/rgVo2j1vaMC9RowINzTNcvetAsoyEQwAZoCq55yhAcyBcmP4chf1b+H3OdWVTCEG7L
        lFMDczu71nqb39H7BTRLOBqPa6lgCO0=
In-Reply-To: <20220901205745.323326-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Update Documentation/admin-guide/cgroup-v2.rst on the newly introduced
"isolated" cpuset partition type as well as other changes made in other
cpuset patches.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 150 +++++++++++++-----------
 1 file changed, 84 insertions(+), 66 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index be4a77baf784..76b3ea9fd5c5 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2186,74 +2186,92 @@ Cpuset Interface Files
 	It accepts only the following input values when written to.
 
 	  ========	================================
-	  "root"	a partition root
-	  "member"	a non-root member of a partition
+	  "member"	Non-root member of a partition
+	  "root"	Partition root
+	  "isolated"	Partition root without load balancing
 	  ========	================================
 
-	When set to be a partition root, the current cgroup is the
-	root of a new partition or scheduling domain that comprises
-	itself and all its descendants except those that are separate
-	partition roots themselves and their descendants.  The root
-	cgroup is always a partition root.
-
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
+	The root cgroup is always a partition root and its state
+	cannot be changed.  All other non-root cgroups start out as
+	"member".
+
+	When set to "root", the current cgroup is the root of a new
+	partition or scheduling domain that comprises itself and all
+	its descendants except those that are separate partition roots
+	themselves and their descendants.
+
+	When set to "isolated", the CPUs in that partition root will
+	be in an isolated state without any load balancing from the
+	scheduler.  Tasks placed in such a partition with multiple
+	CPUs should be carefully distributed and bound to each of the
+	individual CPUs for optimal performance.
+
+	The value shown in "cpuset.cpus.effective" of a partition root
+	is the CPUs that the partition root can dedicate to a potential
+	new child partition root. The new child subtracts available
+	CPUs from its parent "cpuset.cpus.effective".
+
+	A partition root ("root" or "isolated") can be in one of the
+	two possible states - valid or invalid.  An invalid partition
+	root is in a degraded state where some state information may
+	be retained, but behaves more like a "member".
+
+	All possible state transitions among "member", "root" and
+	"isolated" are allowed.
+
+	On read, the "cpuset.cpus.partition" file can show the following
+	values.
+
+	  ======================	==============================
+	  "member"			Non-root member of a partition
+	  "root"			Partition root
+	  "isolated"			Partition root without load balancing
+	  "root invalid (<reason>)"	Invalid partition root
+	  "isolated invalid (<reason>)"	Invalid isolated partition root
+	  ======================	==============================
+
+	In the case of an invalid partition root, a descriptive string on
+	why the partition is invalid is included within parentheses.
+
+	For a partition root to become valid, the following conditions
+	must be met.
+
+	1) The "cpuset.cpus" is exclusive with its siblings , i.e. they
+	   are not shared by any of its siblings (exclusivity rule).
+	2) The parent cgroup is a valid partition root.
+	3) The "cpuset.cpus" is not empty and must contain at least
+	   one of the CPUs from parent's "cpuset.cpus", i.e. they overlap.
+	4) The "cpuset.cpus.effective" cannot be empty unless there is
+	   no task associated with this partition.
+
+	External events like hotplug or changes to "cpuset.cpus" can
+	cause a valid partition root to become invalid and vice versa.
+	Note that a task cannot be moved to a cgroup with empty
+	"cpuset.cpus.effective".
+
+	For a valid partition root with the sibling cpu exclusivity
+	rule enabled, changes made to "cpuset.cpus" that violate the
+	exclusivity rule will invalidate the partition as well as its
+	sibiling partitions with conflicting cpuset.cpus values. So
+	care must be taking in changing "cpuset.cpus".
+
+	A valid non-root parent partition may distribute out all its CPUs
+	to its child partitions when there is no task associated with it.
+
+	Care must be taken to change a valid partition root to
+	"member" as all its child partitions, if present, will become
+	invalid causing disruption to tasks running in those child
+	partitions. These inactivated partitions could be recovered if
+	their parent is switched back to a partition root with a proper
+	set of "cpuset.cpus".
+
+	Poll and inotify events are triggered whenever the state of
+	"cpuset.cpus.partition" changes.  That includes changes caused
+	by write to "cpuset.cpus.partition", cpu hotplug or other
+	changes that modify the validity status of the partition.
+	This will allow user space agents to monitor unexpected changes
+	to "cpuset.cpus.partition" without the need to do continuous
+	polling.
 
 
 Device controller
-- 
2.31.1

