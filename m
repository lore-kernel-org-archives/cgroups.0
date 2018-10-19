From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v14 12/12] cpuset: Show descriptive text when reading
 cpuset.sched.partition
Date: Fri, 19 Oct 2018 14:56:13 -0400
Message-ID: <b797288a-6088-f7b0-c881-81633c071754@redhat.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
 <1539635377-22335-13-git-send-email-longman@redhat.com>
 <20181017150836.GS270328@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------275CDF22CC2523499699C9E0"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017150836.GS270328@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>

This is a multi-part message in MIME format.
--------------275CDF22CC2523499699C9E0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 10/17/2018 11:08 AM, Tejun Heo wrote:
> On Mon, Oct 15, 2018 at 04:29:37PM -0400, Waiman Long wrote:
>> Currently, cpuset.sched.partition returns the values, 0, 1 or -1 on
>> read. A person who is not familiar with the partition code may not
>> understand what they mean.
>>
>> In order to make cpuset.sched.partition more user-friendly, it will
>> now display the following descriptive text on read:
>>
>>   "normal" - A normal cpuset, not a partition root
>>   "partition" - A partition root
>>   "partition invalid" - An invalid partition root
>>
>> Suggested-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Waiman Long <longman@redhat.com>
> Can you also make this consistent when writing to the file?
>
> Thanks.
>
How about the attached patch instead?

Cheers,
Longman


--------------275CDF22CC2523499699C9E0
Content-Type: text/x-patch;
 name="v14-0012-cpuset-Use-descriptive-text-when-reading-writing.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="v14-0012-cpuset-Use-descriptive-text-when-reading-writing.pa";
 filename*1="tch"

From ab96b5d735102b0167a5e92f0aee92caa18a18ae Mon Sep 17 00:00:00 2001
From: Waiman Long <longman@redhat.com>
Date: Fri, 19 Oct 2018 11:46:41 -0400
Subject: [PATCH v14 12/12] cpuset: Use descriptive text when reading/writing
 cpuset.sched.partition

Currently, cpuset.sched.partition returns the values, 0, 1 or -1 on
read. A person who is not familiar with the partition code may not
understand what they mean.

In order to make cpuset.sched.partition more user-friendly, it will
now display the following descriptive text on read:

  "normal" - A normal cpuset, not a partition root
  "partition" - A partition root
  "partition invalid" - An invalid partition root

The cpuset.sched.partition file will now also accept "normal" and
"partition" besides 1 and 0 as valid input values. The "partition
invalid" value is internal only and cannot be written to the file.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 50 +++++++++++++++-------------
 kernel/cgroup/cpuset.c                  | 58 +++++++++++++++++++++++++++++----
 2 files changed, 79 insertions(+), 29 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 178cda4..072f09d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1688,18 +1688,23 @@ Cpuset Interface Files
 
   cpuset.sched.partition
 	A read-write single value file which exists on non-root
-	cpuset-enabled cgroups.  It accepts either "0" (off) or "1"
-	(on) when written to.  This flag is set and owned by the
+	cpuset-enabled cgroups.  This file is set and owned by the
 	parent cgroup.
 
-	If set, it indicates that the current cgroup is the root of a
-	new partition or scheduling domain that comprises itself and
+        It accepts only the following input values when written to.
+
+        "normal" or "0" - normal cpuset, not a partition root
+        "partition" or "1" - partition root
+
+	When set to a partition root, the current cgroup is the root of
+	a new partition or scheduling domain that comprises itself and
 	all its descendants except those that are separate partition
 	roots themselves and their descendants.  The root cgroup is
 	always a partition root.
 
-	There are constraints on where this flag can be set.  It can
-	only be set in a cgroup if all the following conditions are true.
+	There are constraints on where a partition root can be set.
+	It can only be set in a cgroup if all the following conditions
+	are true.
 
 	1) The "cpuset.cpus" is not empty and the list of CPUs are
 	   exclusive, i.e. they are not shared by any of its siblings.
@@ -1710,9 +1715,10 @@ Cpuset Interface Files
 	   eliminating corner cases that have to be handled if such a
 	   condition is allowed.
 
-	Setting this flag will take the CPUs away from the effective
-	CPUs of the parent cgroup.  Once it is set, this flag cannot
-	be cleared if there are any child cgroups with cpuset enabled.
+	Setting it to partition root will take the CPUs away from the
+	effective CPUs of the parent cgroup.  Once it is set, this
+	file cannot be reverted back to "normal" if there are any child
+	cgroups with cpuset enabled.
 
 	A parent partition cannot distribute all its CPUs to its
 	child partitions.  There must be at least one cpu left in the
@@ -1729,28 +1735,28 @@ Cpuset Interface Files
 	root to change.  On read, the "cpuset.sched.partition" file
 	can show the following values.
 
-	"0"  Not a partition root
-	"1"  Partition root
-	"-1" Erroneous partition root
+	"normal" - Normal cpuset, not a partition root
+	"partition" - Partition root
+	"partition invalid" - Invalid partition root
 
 	It is a partition root if the first 2 partition root conditions
 	above are true and at least one CPU from "cpuset.cpus" is
 	granted by the parent cgroup.
 
-	A partition root can become an erroneous partition root if none
-	of CPUs requested in "cpuset.cpus" can be granted by the parent
-	cgroup or the parent cgroup is no longer a partition root.
-	In this case, it is not a real partition even though the
+	A partition root can become an invalid partition root if none
+	of the CPUs requested in "cpuset.cpus" can be granted by the
+	parent cgroup or the parent cgroup is no longer a partition
+	root.  In this case, it is not a real partition even though the
 	restriction of the first partition root condition above will
 	still apply.  All the tasks in the cgroup will be migrated to
 	the nearest ancestor partition.
 
-	An erroneous partition root can be transitioned back to a real
-	partition root if at least one of the requested CPUs can now be
-	granted by its parent.	In this case, the tasks will be migrated
-	back to the newly created partition.  Clearing the partition
-	flag of an erroneous partition root is always allowed even if
-	child cpusets are present.
+	An invalid partition root can be transitioned back to a real
+	partition root if at least one of the requested CPUs can now
+	be granted by its parent.  In this case, the tasks will be
+	migrated back to the newly created partition.  Converting an
+	invalid partition root back to "normal" is always allowed even
+	if child cpusets are present.
 
 
 Device controller
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 34d47e4..d356205 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2274,9 +2274,6 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
 		retval = update_relax_domain_level(cs, val);
 		break;
-	case FILE_PARTITION_ROOT:
-		retval = update_prstate(cs, val);
-		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -2430,8 +2427,6 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	switch (type) {
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
 		return cs->relax_domain_level;
-	case FILE_PARTITION_ROOT:
-		return cs->partition_root_state;
 	default:
 		BUG();
 	}
@@ -2440,6 +2435,55 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	return 0;
 }
 
+static int sched_partition_show(struct seq_file *seq, void *v)
+{
+	struct cpuset *cs = css_cs(seq_css(seq));
+
+	switch (cs->partition_root_state) {
+	case PRS_ENABLED:
+		seq_puts(seq, "partition\n");
+		break;
+	case PRS_DISABLED:
+		seq_puts(seq, "normal\n");
+		break;
+	case PRS_ERROR:
+		seq_puts(seq, "partition invalid\n");
+		break;
+	}
+	return 0;
+}
+
+static ssize_t sched_partition_write(struct kernfs_open_file *of, char *buf,
+				     size_t nbytes, loff_t off)
+{
+	struct cpuset *cs = css_cs(of_css(of));
+	int val;
+	int retval = -ENODEV;
+
+	buf = strstrip(buf);
+
+	/*
+	 * Convert "partition"/"1" to 1, and convert "normal"/"0" to 0.
+	 */
+	if (!strcmp(buf, "partition") || !strcmp(buf, "1"))
+		val = PRS_ENABLED;
+	else if (!strcmp(buf, "normal") || !strcmp(buf, "0"))
+		val = PRS_DISABLED;
+	else
+		return -EINVAL;
+
+	css_get(&cs->css);
+	mutex_lock(&cpuset_mutex);
+	if (!is_cpuset_online(cs))
+		goto out_unlock;
+
+	retval = update_prstate(cs, val);
+out_unlock:
+	mutex_unlock(&cpuset_mutex);
+	css_put(&cs->css);
+	return retval ?: nbytes;
+}
+
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -2583,8 +2627,8 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 
 	{
 		.name = "sched.partition",
-		.read_s64 = cpuset_read_s64,
-		.write_s64 = cpuset_write_s64,
+		.seq_show = sched_partition_show,
+		.write = sched_partition_write,
 		.private = FILE_PARTITION_ROOT,
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
-- 
1.8.3.1


--------------275CDF22CC2523499699C9E0--
