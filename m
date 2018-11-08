From: Waiman Long <longman@redhat.com>
Subject: [PATCH v15 10/12] cpuset: Use descriptive text when reading/writing cpuset.sched.partition
Date: Thu,  8 Nov 2018 10:08:44 -0500
Message-ID: <1541689726-20088-11-git-send-email-longman@redhat.com>
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

Currently, cpuset.sched.partition returns the values, 0, 1 or -1 on
read. A person who is not familiar with the partition code may not
understand what they mean.

In order to make cpuset.sched.partition more user-friendly, it will
now display the following descriptive text on read:

  "root" - A partition root (top cpuset of a partition)
  "member" - A non-root member of a partition
  "root invalid" - An invalid partition root

Note that there is at least one partition in the whole cgroup hierarchy.
The top cpuset is the root of that partition.  The rests are either a
root if it starts a new partition or a member of a partition.

The cpuset.sched.partition file will now also accept "root" and
"member" besides 1 and 0 as valid input values. The "root invalid"
value is internal only and cannot be written to the file.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 58 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index fc1a809..c739fda 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2278,9 +2278,6 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
 		retval = update_relax_domain_level(cs, val);
 		break;
-	case FILE_PARTITION_ROOT:
-		retval = update_prstate(cs, val);
-		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -2431,8 +2428,6 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	switch (type) {
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
 		return cs->relax_domain_level;
-	case FILE_PARTITION_ROOT:
-		return cs->partition_root_state;
 	default:
 		BUG();
 	}
@@ -2441,6 +2436,55 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	return 0;
 }
 
+static int sched_partition_show(struct seq_file *seq, void *v)
+{
+	struct cpuset *cs = css_cs(seq_css(seq));
+
+	switch (cs->partition_root_state) {
+	case PRS_ENABLED:
+		seq_puts(seq, "root\n");
+		break;
+	case PRS_DISABLED:
+		seq_puts(seq, "member\n");
+		break;
+	case PRS_ERROR:
+		seq_puts(seq, "root invalid\n");
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
+	 * Convert "root"/"1" to 1, and convert "member"/"0" to 0.
+	 */
+	if (!strcmp(buf, "root") || !strcmp(buf, "1"))
+		val = PRS_ENABLED;
+	else if (!strcmp(buf, "member") || !strcmp(buf, "0"))
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
@@ -2584,8 +2628,8 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 
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

