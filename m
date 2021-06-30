From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm/vmpressure: replace vmpressure_to_css() with
 vmpressure_to_memcg()
Date: Wed, 30 Jun 2021 13:32:52 +0100
Message-ID: <YNxkdGeFu4C5T6MZ@chrisdown.name>
References: <20210630112146.455103-1-suhui@zeku.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HUJtWNPJiBHCYwporvv4J+zIbXCE4pbnBbFi48C+38E=;
        b=jZMFEqHO9CNCmPa5FW5Q7xZIzLc/Zqmscfzxwqe5+MUEpfZYPNcp74CfU+fZHg5Bvp
         CjkLVdh9YEVGWaZViQCNJDQqFRuu0dFr0zFINCOtbwOwQYM7Ka6t/hH2mC7D+xc/IgOF
         6ErkqnvmDe6COuHc5HmXmmM9PgUQXqf7UcWyA=
Content-Disposition: inline
In-Reply-To: <20210630112146.455103-1-suhui-OtvJRZzVyoU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Hui Su <suhui-OtvJRZzVyoU@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Thanks! This looks like a reasonable cleanup.

Hui Su writes:
>We can get memcg directly form vmpr instead of vmpr->memcg->css->memcg,
>so add a new func helper vmpressure_to_memcg().
>And no code will use vmpressure_to_css(), so delete it.
>
>Signed-off-by: Hui Su <suhui-OtvJRZzVyoU@public.gmane.org>

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

>---
> include/linux/vmpressure.h | 2 +-
> mm/memcontrol.c            | 4 ++--
> mm/vmpressure.c            | 3 +--
> 3 files changed, 4 insertions(+), 5 deletions(-)
>
>diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
>index 6d28bc433c1c..6a2f51ebbfd3 100644
>--- a/include/linux/vmpressure.h
>+++ b/include/linux/vmpressure.h
>@@ -37,7 +37,7 @@ extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
> extern void vmpressure_init(struct vmpressure *vmpr);
> extern void vmpressure_cleanup(struct vmpressure *vmpr);
> extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
>-extern struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr);
>+extern struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr);
> extern int vmpressure_register_event(struct mem_cgroup *memcg,
> 				     struct eventfd_ctx *eventfd,
> 				     const char *args);
>diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>index 64ada9e650a5..62163a9cee63 100644
>--- a/mm/memcontrol.c
>+++ b/mm/memcontrol.c
>@@ -247,9 +247,9 @@ struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg)
> 	return &memcg->vmpressure;
> }
>
>-struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr)
>+struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr)
> {
>-	return &container_of(vmpr, struct mem_cgroup, vmpressure)->css;
>+	return container_of(vmpr, struct mem_cgroup, vmpressure);
> }
>
> #ifdef CONFIG_MEMCG_KMEM
>diff --git a/mm/vmpressure.c b/mm/vmpressure.c
>index d69019fc3789..04e81ac6d5d8 100644
>--- a/mm/vmpressure.c
>+++ b/mm/vmpressure.c
>@@ -74,8 +74,7 @@ static struct vmpressure *work_to_vmpressure(struct work_struct *work)
>
> static struct vmpressure *vmpressure_parent(struct vmpressure *vmpr)
> {
>-	struct cgroup_subsys_state *css = vmpressure_to_css(vmpr);
>-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>+	struct mem_cgroup *memcg = vmpressure_to_memcg(vmpr);
>
> 	memcg = parent_mem_cgroup(memcg);
> 	if (!memcg)
>-- 
>2.25.1
>
>
