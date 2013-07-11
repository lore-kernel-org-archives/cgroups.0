From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: workqueue usage in vmpressure
Date: Thu, 11 Jul 2013 11:25:42 +0200
Message-ID: <20130711092542.GD21667@dhcp22.suse.cz>
References: <20130710184254.GA16979@mtj.dyndns.org>
 <20130711083110.GC21667@dhcp22.suse.cz>
 <51DE701C.6010800@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51DE701C.6010800-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 11-07-13 16:43:08, Li Zefan wrote:
[...]
> > @@ -248,6 +256,9 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
> >  
> >  	if (scanned < vmpressure_win || work_pending(&vmpr->work))
> >  		return;
> > +
> > +	/* Reference will be released in vmpressure_work_fn */
> > +	vmpressure_pin_memcg(vmpr);
> >  	schedule_work(&vmpr->work);
> 
> Looks like a work can be queued right after the above work_pending()
> returns 0, then we should do this:
> 
>     if (schedule_work(&vmpr->work))
> 	vmpressure_pin_memcg(vmpr);

But isn't this racy and the following would be safer?
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0f2c909..8329262 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6204,15 +6204,15 @@ struct mem_cgroup *vmpressure_to_mem_cgroup(struct vmpressure *vmpr)
 void vmpressure_pin_memcg(struct vmpressure *vmpr)
 {
 	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
-	if (memcg != root_mem_cgroup)
-		css_get(&memcg->css);
+
+	css_get(&memcg->css);
 }
 
 void vmpressure_unpin_memcg(struct vmpressure *vmpr)
 {
 	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
-	if (memcg != root_mem_cgroup)
-		css_put(&memcg->css);
+
+	css_put(&memcg->css);
 }
 
 static void __init mem_cgroup_soft_limit_tree_init(void)
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 89865e5..3a955412 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -259,7 +259,8 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 
 	/* Reference will be released in vmpressure_work_fn */
 	vmpressure_pin_memcg(vmpr);
-	schedule_work(&vmpr->work);
+	if (!schedule_work(&vmpr->work))
+		vmpressure_unpin_memcg(vmpr);
 }
 
 /**
-- 
Michal Hocko
SUSE Labs
