From: Roman Gushchin <guro@fb.com>
Subject: [v4 3/4] mm, oom: introduce oom_priority for memory cgroups
Date: Wed, 26 Jul 2017 14:27:17 +0100
Message-ID: <20170726132718.14806-4-guro@fb.com>
References: <20170726132718.14806-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Nt6xYXUYqok7PsubsI5EJFM1B47N+goNsHcTYs3ty0o=;
 b=a3+3vC3o0ObCHMhhq3lrkqtjwAw0B8pqjmXQeEDwlRC2MeKDgwc4qifSc8vpQ8TLzmi5
 aljsIXO0UG6wuY1eHy/t+IM18upAeU18xeE30+Skv1qjmpmn0ZFdolTiu5ostFpQMWod
 aD/1fv71a/DPoSapum2RpZ7UZRt799COG6A= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Nt6xYXUYqok7PsubsI5EJFM1B47N+goNsHcTYs3ty0o=;
 b=TsP0PTjHZfldNFETwTMoBBKNPrxnT740slkXl6JsYpYY66jOaffcZoLZNA1fdvzQwIUgcgKWcAnJI3xM/a9LFjNdk+y76/+QJf83eyFlRDHgb2Qat8QqVk0Bqg54wt7A/AMZAW8mGAQVpy0H+09JQFOhXFMxGANJUMvCODyQ3sQ=
In-Reply-To: <20170726132718.14806-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Introduce a per-memory-cgroup oom_priority setting: an integer number
within the [-10000, 10000] range, which defines the order in which
the OOM killer selects victim memory cgroups.

OOM killer prefers memory cgroups with larger priority if they are
populated with elegible tasks.

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
 mm/memcontrol.c            | 55 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b21bbb0edc72..d31ac58e08ad 100644
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
index ba72d1cf73d0..2c1566995077 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2710,12 +2710,21 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
 	for (;;) {
 		struct cgroup_subsys_state *css;
 		struct mem_cgroup *memcg = NULL;
+		short prio = SHRT_MIN;
 		long score = LONG_MIN;
 
 		css_for_each_child(css, &root->css) {
 			struct mem_cgroup *iter = mem_cgroup_from_css(css);
 
-			if (iter->oom_score > score) {
+			if (iter->oom_score == 0)
+				continue;
+
+			if (iter->oom_priority > prio) {
+				memcg = iter;
+				prio = iter->oom_priority;
+				score = iter->oom_score;
+			} else if (iter->oom_priority == prio &&
+				   iter->oom_score > score) {
 				memcg = iter;
 				score = iter->oom_score;
 			}
@@ -2782,7 +2791,15 @@ bool mem_cgroup_select_oom_victim(struct oom_control *oc)
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
 
 		if (oc->chosen && oc->chosen_memcg) {
@@ -5373,6 +5390,34 @@ static ssize_t memory_oom_kill_all_tasks_write(struct kernfs_open_file *of,
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
@@ -5499,6 +5544,12 @@ static struct cftype memory_files[] = {
 		.write = memory_oom_kill_all_tasks_write,
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
2.13.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
