From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 6/6] zswap: memcg accounting
Date: Wed, 11 May 2022 19:32:18 +0200
Message-ID: <20220511173218.GB31592@blackbody.suse.cz>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652290339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iRo/JDHV83EB1h5pdBZIrd5z5XjhjDpQVXb7V6F3I4c=;
        b=FLBQObsLAEcY1qpKL38af29Yq0wE5hD1t6hpXBKrsjw/zDf/yEb/cDp9ZNEOMN8w4SPm60
        AgtXFg88C6KZG4n9p82BaD1+UyjiAcfUKlsB311c6+IxZVDjcBajaOIy4ZipojjeWOK08I
        MY8p2vDpruhAjP8jbUES1EHuqm4bnw8=
Content-Disposition: inline
In-Reply-To: <20220510152847.230957-7-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello.

On Tue, May 10, 2022 at 11:28:47AM -0400, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> +void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> +
> +	/* PF_MEMALLOC context, charging must succeed */
> +	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> +		VM_WARN_ON_ONCE(1);

IIUC, the objcg is derived from the compressed page, i.e. same memcg
(reparenting neglected for now). This memcg's memory.current is then
charged with the compressed object size.

Do I get it right that memory.zswap.current is a subset of memory.current?

(And that zswap is limited both by memory.max and memory.zswap.max?)

Thanks,
Michal
