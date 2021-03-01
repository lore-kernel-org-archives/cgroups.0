From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 4/5] mm: memcontrol: move remote memcg charging APIs to CONFIG_MEMCG_KMEM
Date: Mon,  1 Mar 2021 14:22:26 +0800
Message-ID: <20210301062227.59292-5-songmuchun@bytedance.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cilHKXrKoJZLqevMF5os7tc8I3h7Pgl0p1o36mO7uUg=;
        b=zssOM8W3NPBUtqhS102B5C1SbgE+Bno0K/TPpFBgYelvNPEhaNlsO+yd+VVxFNtaaK
         o5pFwnjOR4aO86xW3/lnvTINF6Iirdi/psRZIigw8T0h2n1QNlYJg/wxUwnXY9zMqEBZ
         lTh3rQTJtcd+uUKvKFBk0sJK13wJGcNmvDqCYFIp9VywEzeCUUALceII5oYAR8aoC7Zv
         3k30ytpmiItqUAZdHqYleUAlLuU0TbWtMh/DZXVKi8EfGvffWzK9kToWwTUlfXgLampg
         9OsLywpEh8Y34TOjPoOpb45nqB2oCuFssRLKkeoB9Bq7xuMXkTnpdadyJ4sufQmmEyUt
         GqCQ==
In-Reply-To: <20210301062227.59292-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, posk-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, daniel.vetter@ffw
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

The remote memcg charing APIs is a mechanism to charge kernel memory
to a given memcg. So we can move the infrastructure to the scope of
the CONFIG_MEMCG_KMEM.

As a bonus, on !CONFIG_MEMCG_KMEM build some functions and variables
can be compiled out.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/sched.h    | 2 ++
 include/linux/sched/mm.h | 2 +-
 kernel/fork.c            | 2 +-
 mm/memcontrol.c          | 4 ++++
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee46f5cab95b..c2d488eddf85 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1314,7 +1314,9 @@ struct task_struct {
 
 	/* Number of pages to reclaim on returning to userland: */
 	unsigned int			memcg_nr_pages_over_high;
+#endif
 
+#ifdef CONFIG_MEMCG_KMEM
 	/* Used by memcontrol for targeted memcg charge: */
 	struct mem_cgroup		*active_memcg;
 #endif
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 1ae08b8462a4..64a72975270e 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -294,7 +294,7 @@ static inline void memalloc_nocma_restore(unsigned int flags)
 }
 #endif
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_KMEM
 DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
 /**
  * set_active_memcg - Starts the remote memcg charging scope.
diff --git a/kernel/fork.c b/kernel/fork.c
index d66cd1014211..d66718bc82d5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -942,7 +942,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->use_memdelay = 0;
 #endif
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_KMEM
 	tsk->active_memcg = NULL;
 #endif
 	return tsk;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 39cb8c5bf8b2..092dc4588b43 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -76,8 +76,10 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 
 struct mem_cgroup *root_mem_cgroup __read_mostly;
 
+#ifdef CONFIG_MEMCG_KMEM
 /* Active memory cgroup to use from an interrupt context */
 DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
+#endif
 
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket;
@@ -1054,6 +1056,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
+#ifdef CONFIG_MEMCG_KMEM
 static __always_inline struct mem_cgroup *active_memcg(void)
 {
 	if (in_interrupt())
@@ -1074,6 +1077,7 @@ static __always_inline bool memcg_kmem_bypass(void)
 
 	return false;
 }
+#endif
 
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
-- 
2.11.0

