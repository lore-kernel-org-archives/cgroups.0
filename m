From: Roman Gushchin <guro@fb.com>
Subject: [v6 3/4] mm, oom: introduce oom_priority for memory cgroups
Date: Wed, 23 Aug 2017 17:52:00 +0100
Message-ID: <20170823165201.24086-4-guro@fb.com>
References: <20170823165201.24086-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=cnr8HqABw/2fHvE2vFpmjCK7zztG0OGE17uBZM9D4iE=;
 b=VzEbY0WikdMQOQwud/6c1U94g4kIIwd0f78Yz58CBE9fP3JxliFDdAE7u7B2sToGx6H7
 csvz9sE6d/6Ov9ywOGEM+qbVw+KrEzLB0Y5FiUj+G2xXCEIks4WweCrT6CSHTXXZE7W5
 5kpVHAFAtXiqu3sEfUp9UOV1zWuq8esB9D8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cnr8HqABw/2fHvE2vFpmjCK7zztG0OGE17uBZM9D4iE=;
 b=LElecAa6+ul86dPcw8QM/ONj6pBP3gz5g6h57ThVR4RNF50Gt9OJ/tllWCN2uWEzcfGOS6mNk/wiIPGAXIfR2nM3opiP3nf833Ee9ks9BaW+dpTknzD6BFIENnnMbZvUidIWOVqL9OJHfBroLE2iNhsW1ZNZVtdXB9g24RgTCGI=
In-Reply-To: <20170823165201.24086-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Introduce a per-memory-cgroup oom_priority setting: an integer number
within the [-10000, 10000] range, which defines the order in which
the OOM killer selects victim memory cgroups.

OOM killer prefers memory cgroups with larger priority if they are
populated with eligible tasks.

The oom_priority value is compared within sibling cgroups.

The root cgroup has the oom_priority 0, which cannot be changed.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/memcontrol.h |  3 +++
 mm/memcontrol.c            | 52 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c57ee47c35bb..915f0c19a2b5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -206,6 +206,9 @@ struct mem_cgroup {
 	/* cached OOM score */
 	long oom_score;
 
+	/* OOM killer priority */
+	short oom_priority;
+
 	/* handle for "memory.events" */
 	struct cgroup_file events_file;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a620aaae6201..a173e5b0d4d8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2749,6 +2749,7 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
 	for (;;) {
 		struct cgroup_subsys_state *css;
 		struct mem_cgroup *memcg = NULL;
+		short prio = SHRT_MIN;
 		long score = LONG_MIN;
 
 		css_for_each_child(css, &root->css) {
@@ -2760,7 +2761,12 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
 			if (iter->oom_score == 0)
 				continue;
 
-			if (iter->oom_score > score) {
+			if (iter->oom_priority > prio) {
+				memcg = iter;
+				prio = iter->oom_priority;
+				score = iter->oom_score;
+			} else if (iter->oom_priority == prio &&
+				   iter->oom_score > score) {
 				memcg = iter;
 				score = iter->oom_score;
 			}
@@ -2830,7 +2836,15 @@ bool mem_cgroup_select_oom_victim(struct oom_control *oc)
 	 * For system-wide OOMs we should consider tasks in the root cgroup
 	 * with oom_score larger than oc->chosen_points.
 	 */
-	if (!oc->memcg) {
+	if (!oc->memcg && !(oc->chosen_memcg &&
+			    oc->chosen_memcg->oom_priority > 0)) {
+		/*
+		 * Root memcg has priority 0, so if chosen memcg has lower
+		 * priority, any task in root cgroup is preferable.
+		 */
+		if (oc->chosen_memcg && oc->chosen_memcg->oom_priority < 0)
+			oc->chosen_points = 0;
+
 		select_victim_root_cgroup_task(oc);
 
 		if (oc->chosen_task && oc->chosen_memcg) {
@@ -5426,6 +5440,34 @@ static ssize_t memory_oom_kill_all_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static int memory_oom_priority_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+
+	seq_printf(m, "%d\n", memcg->oom_priority);
+
+	return 0;
+}
+
+static ssize_t memory_oom_priority_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int oom_priority;
+	int err;
+
+	err = kstrtoint(strstrip(buf), 0, &oom_priority);
+	if (err)
+		return err;
+
+	if (oom_priority < -10000 || oom_priority > 10000)
+		return -EINVAL;
+
+	memcg->oom_priority = (short)oom_priority;
+
+	return nbytes;
+}
+
 static int memory_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
@@ -5552,6 +5594,12 @@ static struct cftype memory_files[] = {
 		.write = memory_oom_kill_all_write,
 	},
 	{
+		.name = "oom_priority",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_oom_priority_show,
+		.write = memory_oom_priority_write,
+	},
+	{
 		.name = "events",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.file_offset = offsetof(struct mem_cgroup, events_file),
-- 
2.13.5

