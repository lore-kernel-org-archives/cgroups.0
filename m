From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: [RFC PATCH v2 5/7] mm, oom: introduce oom_score_adj for memory cgroups
Date: Thu, 1 Jun 2017 19:35:13 +0100
Message-ID: <1496342115-3974-6-git-send-email-guro@fb.com>
References: <1496342115-3974-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=P2R7TbEXwc/klqFxE8fmwUmJVSSyu8gJn9ehf8qCmCA=;
 b=ltMjT7EszeHrL+oGS+JVTzNVD+zfMMQA1qmlDakKyjyAOYnT1XGEkPCJT8+B1VWuA1oM
 rf0aVGoAqanMI527DT1QzFhFJGS1OdVHFF+spPShcDwXYr6wY15OBd2VI5SyOSLfdWKF
 CJwqVDjcgQuVMDNgBDcscu80L7AylFjgZiU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=P2R7TbEXwc/klqFxE8fmwUmJVSSyu8gJn9ehf8qCmCA=;
 b=dhvykvaCQ4dxUkW2ZjmXJ8vTAnG34B/0rh8jFk4ux2BuSv/Pl+aPkk9u9pjzR8+Mo7q4cuGa0/PVpmBHVfrtNvwVlXnjsT0b9spZOXLhpWA4R26hwDP/7TphPy5j2qutea77iI8APGvxFmPi4BUqp2qtdpRPEP7oEz3aj1NWR/U=
In-Reply-To: <1496342115-3974-1-git-send-email-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Introduce a per-memory-cgroup oom_score_adj setting.
A read-write single value file which exits on non-root
cgroups. The default is "0".

It will have a similar meaning to a per-process value,
available via /proc/<pid>/oom_score_adj.
Should be in a range [-1000, 1000].

Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: kernel-team-b10kYP2dOMg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 include/linux/memcontrol.h |  3 +++
 mm/memcontrol.c            | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8a308c9..818a42e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -198,6 +198,9 @@ struct mem_cgroup {
 	/* kill all tasks below in case of OOM */
 	bool oom_kill_all_tasks;
 
+	/* OOM kill score adjustment */
+	short oom_score_adj;
+
 	/* handle for "memory.events" */
 	struct cgroup_file events_file;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d4ffa79..f979ac7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5183,6 +5183,36 @@ static ssize_t memory_oom_kill_all_tasks_write(struct kernfs_open_file *of,
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
@@ -5298,6 +5328,12 @@ static struct cftype memory_files[] = {
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
