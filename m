From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH bpf-next v3 11/13] mm, memcg: Add new helper task_under_memcg_hierarchy
Date: Fri,  2 Sep 2022 02:30:01 +0000
Message-ID: <20220902023003.47124-12-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=eAg0PZWl4zJUTIoBr/3Gv3urgLIcQ4VDCzv1IFZNeuY=;
        b=Gy+cv6XxxiYO3hr3Muw+hBZMy0efagnoQa+lkQO0z4mGYIW5CA1XBEpuraxfeAkfxK
         G8jIecWEoNFtvzfvGj7MUoaQaJt6vAiOKaeeaE0MPYK18/zDhN7V4FvEnghuG12f7i8k
         Wygblna21VTeaQ1/2AbJRacHSL9o97+r1sF9tnGeMEcckZfF2mRzApylow2eQjSffdB/
         hmzgT9VOAVh2e1R9frgjc8IuTH7PdBnGqPgwVc5a7Y0hMwIth/hwYmEVonEu1nG6Pnij
         zqNPwiEXu0QWL90ZfnVnEaOkufmAIS5nPaMLhxm/P9a6FaAONxHMU+n2OSgyMVpdr9Sa
         6ayQ==
In-Reply-To: <20220902023003.47124-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Introduce a new helper to check if a task belongs to a specific memcg.
It is similar to mm_match_cgroup() except that the new helper is checked
against a task rather than a mm struct. So with this new helper we can
check a task directly.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/memcontrol.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7a7f252..3b8a8dd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -887,6 +887,20 @@ static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
 	return cgroup_is_descendant(memcg->css.cgroup, root->css.cgroup);
 }
 
+static inline bool task_under_memcg_hierarchy(struct task_struct *p,
+					      struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *task_memcg;
+	bool match = false;
+
+	rcu_read_lock();
+	task_memcg = mem_cgroup_from_task(p);
+	if (task_memcg)
+		match = mem_cgroup_is_descendant(task_memcg, memcg);
+	rcu_read_unlock();
+	return match;
+}
+
 static inline bool mm_match_cgroup(struct mm_struct *mm,
 				   struct mem_cgroup *memcg)
 {
-- 
1.8.3.1

