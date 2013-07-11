From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: workqueue usage in vmpressure
Date: Thu, 11 Jul 2013 16:45:46 +0800
Message-ID: <51DE70BA.3020401@huawei.com>
References: <20130710184254.GA16979@mtj.dyndns.org> <20130711083110.GC21667@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130711083110.GC21667-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> +void vmpressure_pin_memcg(struct vmpressure *vmpr)
> +{
> +	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
> +	if (memcg != root_mem_cgroup)

this check is redundant. see the definition of css_get():

static inline void css_get(struct cgroup_subsys_state *css)
{
        /* We don't need to reference count the root state */
        if (!(css->flags & CSS_ROOT))
                __css_get(css, 1);
}

> +		css_get(&memcg->css);
> +}
> +
> +void vmpressure_unpin_memcg(struct vmpressure *vmpr)
> +{
> +	struct mem_cgroup *memcg = vmpressure_to_mem_cgroup(vmpr);
> +	if (memcg != root_mem_cgroup)

ditto

> +		css_put(&memcg->css);
> +}

