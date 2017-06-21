From: Roman Gushchin <guro@fb.com>
Subject: [v3 4/6] mm, oom: introduce oom_score_adj for memory cgroups
Date: Wed, 21 Jun 2017 22:19:14 +0100
Message-ID: <1498079956-24467-5-git-send-email-guro@fb.com>
References: <1498079956-24467-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=5J1bpsiBdYXN71S2xN3ipo98sY3J7JhfkI+WGKtTAhI=;
 b=oPwy4a4Xqsn4Un+a04ImFR6PSqx+WKmXIZQYnYsETPf25djQ6SEvaHd8YJyPeel0wtJp
 OAjjD22aOc3AICwZgxnkyJvtWWiNw70+KuZWDumFXDou86LKoIrtLKy61cYOwkF3gcYD
 E5uU+eDZc5Rze+zS/IMby8E/HtXUtsyF1aw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5J1bpsiBdYXN71S2xN3ipo98sY3J7JhfkI+WGKtTAhI=;
 b=DWOwKH6v2yMkVA0iMbU+clqyV7BrDQLrSR806Fp+nhKlrPxGPHVVGJgFRvMztdq0yhToAKmS/Vg5AILUCw2R2zppSvWB/tQJD56OUJUHCJZYA+ElAs4jdSRmSUxUGBv0BFdPa8ci4sWaxAOAK8Fj5KnwzXOFupGq44K0yXLvs70=
In-Reply-To: <1498079956-24467-1-git-send-email-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Introduce a per-memory-cgroup oom_score_adj setting.
A read-write single value file which exits on non-root
cgroups. The default is "0".

It will have a similar meaning to a per-process value,
available via /proc/<pid>/oom_score_adj.
Should be in a range [-1000, 1000].

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/memcontrol.h |  3 +++
 mm/memcontrol.c            | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c59926c..b84a050 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -203,6 +203,9 @@ struct mem_cgroup {
 	/* kill all tasks in the subtree in case of OOM */
 	bool oom_kill_all_tasks;
 
+	/* OOM kill score adjustment */
+	short oom_score_adj;
+
 	/* handle for "memory.events" */
 	struct cgroup_file events_file;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4face20..e474eba 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5333,6 +5333,36 @@ static ssize_t memory_oom_kill_all_tasks_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static int memory_oom_score_adj_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	short oom_score_adj = memcg->oom_score_adj;
+
+	seq_printf(m, "%d\n", oom_score_adj);
+
+	return 0;
+}
+
+static ssize_t memory_oom_score_adj_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int oom_score_adj;
+	int err;
+
+	err = kstrtoint(strstrip(buf), 0, &oom_score_adj);
+	if (err)
+		return err;
+
+	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
+			oom_score_adj > OOM_SCORE_ADJ_MAX)
+		return -EINVAL;
+
+	memcg->oom_score_adj = (short)oom_score_adj;
+
+	return nbytes;
+}
+
 static int memory_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
@@ -5459,6 +5489,12 @@ static struct cftype memory_files[] = {
 		.write = memory_oom_kill_all_tasks_write,
 	},
 	{
+		.name = "oom_score_adj",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_oom_score_adj_show,
+		.write = memory_oom_score_adj_write,
+	},
+	{
 		.name = "events",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.file_offset = offsetof(struct mem_cgroup, events_file),
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
