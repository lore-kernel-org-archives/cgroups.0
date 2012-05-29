From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
Date: Tue, 29 May 2012 09:36:55 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205290932530.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338302219; bh=YIGLCJO1/I7+nSztJv9U5HsoxmHKHFklV+9c4GHhaSY=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=ZxXjlxZeYWxbzQuyEXo1tEjkWVSYYC2fST+fJJsE/hwAvxm2tPpkkZoM/FrQJK/BnwhkBdkGTN8kFjQaxoy3YzowpfvYVpZMSLJb14Srv5Zo0CZ9S90YAsA/YgFZdpV/DUQvULTrl91GOOym+eOLdLq9ODPu8JqFgKkO52X6LSE=
In-Reply-To: <1337951028-3427-14-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Fri, 25 May 2012, Glauber Costa wrote:

> index dacd1fb..4689034 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -467,6 +467,23 @@ struct cg_proto *tcp_proto_cgroup(struct mem_cgroup *memcg)
>  EXPORT_SYMBOL(tcp_proto_cgroup);
>  #endif /* CONFIG_INET */
>
> +char *mem_cgroup_cache_name(struct mem_cgroup *memcg, struct kmem_cache *cachep)
> +{
> +	char *name;
> +	struct dentry *dentry;
> +
> +	rcu_read_lock();
> +	dentry = rcu_dereference(memcg->css.cgroup->dentry);
> +	rcu_read_unlock();
> +
> +	BUG_ON(dentry == NULL);
> +
> +	name = kasprintf(GFP_KERNEL, "%s(%d:%s)",
> +	    cachep->name, css_id(&memcg->css), dentry->d_name.name);
> +
> +	return name;
> +}

Function allocates a string that is supposed to be disposed of by the
caller. That needs to be documented and maybe even the name needs to
reflect that.

> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4002,6 +4002,38 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>  }
>  EXPORT_SYMBOL(kmem_cache_create);
>
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
> +				  struct kmem_cache *s)
> +{
> +	char *name;
> +	struct kmem_cache *new;
> +
> +	name = mem_cgroup_cache_name(memcg, s);
> +	if (!name)
> +		return NULL;
> +
> +	new = kmem_cache_create_memcg(memcg, name, s->objsize, s->align,
> +				      (s->allocflags & ~SLAB_PANIC), s->ctor);

Hmmm... A full duplicate of the slab cache? We may have many sparsely
used portions of the per node and per cpu structure as a result.

> +	 * prevent it from being deleted. If kmem_cache_destroy() is
> +	 * called for the root cache before we call it for a child cache,
> +	 * it will be queued for destruction when we finally drop the
> +	 * reference on the child cache.
> +	 */
> +	if (new) {
> +		down_write(&slub_lock);
> +		s->refcount++;
> +		up_write(&slub_lock);
> +	}

Why do you need to increase the refcount? You made a full copy right?
