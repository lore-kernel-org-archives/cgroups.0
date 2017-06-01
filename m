From: Roman Gushchin <guro@fb.com>
Subject: [RFC PATCH v2 4/7] mm, oom: introduce oom_kill_all_tasks option for memory cgroups
Date: Thu, 1 Jun 2017 19:35:12 +0100
Message-ID: <1496342115-3974-5-git-send-email-guro@fb.com>
References: <1496342115-3974-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=08JcrNYaiC/U2G2kJuC1DIMkSCuSN0QHX7lk81R64jg=;
 b=X5Ed/KSM4xgwn39dlMdHmxL8TQp4LBcJhWf7J/1DtnfKM1tiAEIfiaBsD8zcSReYhrUK
 SgXZz7x2UAggr++y5W+OvKliGmO87aB6EGcxuGLRD/lQipZUANU4QjIKs+7HIRsZQSAj
 q7Jz/Dkzithekj6gD7M+pDJVy3rHPPfk118= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=08JcrNYaiC/U2G2kJuC1DIMkSCuSN0QHX7lk81R64jg=;
 b=MteoTEmzZH0nEx1QuxRs4JTMjgi7VG/Aul1i1JXTdtpRZfJOWvF4qSMf8DwVCtzJyfc3CwHoCGFn2p0TC0f3r+CvVKVlEhKwE5FoF6X0YuUw9F6dKRzvgr6AFwG473T7ASp1iD99HbSEbY9PqJxiCDOxCDm7luU+LqYkYZLqLz8=
In-Reply-To: <1496342115-3974-1-git-send-email-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

This option defines whether a cgroup should be treated
as a single entity by the OOM killer.

If set, the OOM killer will compare the whole cgroup with other
memory consumers (other cgroups and tasks in the root cgroup),
and in case of an OOM will kill all belonging tasks.

Disabled by default.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/memcontrol.h |  3 +++
 mm/memcontrol.c            | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 899949b..8a308c9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -195,6 +195,9 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
+	/* kill all tasks below in case of OOM */
+	bool oom_kill_all_tasks;
+
 	/* handle for "memory.events" */
 	struct cgroup_file events_file;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c131f7e..d4ffa79 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5156,6 +5156,33 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static int memory_oom_kill_all_tasks_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	bool oom_kill_all_tasks = memcg->oom_kill_all_tasks;
+
+	seq_printf(m, "%d\n", oom_kill_all_tasks);
+
+	return 0;
+}
+
+static ssize_t memory_oom_kill_all_tasks_write(struct kernfs_open_file *of,
+					       char *buf, size_t nbytes,
+					       loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int oom_kill_all_tasks;
+	int err;
+
+	err = kstrtoint(strstrip(buf), 0, &oom_kill_all_tasks);
+	if (err)
+		return err;
+
+	memcg->oom_kill_all_tasks = !!oom_kill_all_tasks;
+
+	return nbytes;
+}
+
 static int memory_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
@@ -5265,6 +5292,12 @@ static struct cftype memory_files[] = {
 		.write = memory_max_write,
 	},
 	{
+		.name = "oom_kill_all_tasks",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_oom_kill_all_tasks_show,
+		.write = memory_oom_kill_all_tasks_write,
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
