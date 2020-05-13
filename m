From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] memcg: Fix memcg_kmem_bypass() for remote memcg charging
Date: Wed, 13 May 2020 19:47:49 +0800
Message-ID: <3a721f62-5a66-8bc5-247b-5c8b7c51c555@huawei.com>
References: <e6927a82-949c-bdfd-d717-0a14743c6759@huawei.com>
 <20200513090502.GV29153@dhcp22.suse.cz>
 <76f71776-d049-7407-8574-86b6e9d80704@huawei.com>
 <20200513112905.GX29153@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200513112905.GX29153-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

While trying to use remote memcg charging in an out-of-tree kernel module
I found it's not working, because the current thread is a workqueue thread.

As we will probably encounter this issue in the future as the users of
memalloc_use_memcg() grow, it's better we fix it now.

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

v2: add a comment as sugguested by Michal. and add changelog to explain why
upstream kernel needs this fix.

---

 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a3b97f1..43a12ed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2802,6 +2802,9 @@ static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
 
 static inline bool memcg_kmem_bypass(void)
 {
+	/* Allow remote memcg charging in kthread contexts. */
+	if (unlikely(current->active_memcg))
+		return false;
 	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
 		return true;
 	return false;
-- 
2.7.4

