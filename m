From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 2/5] mm/memcg: Introduce
 obj_cgroup_uncharge_mod_state()
Date: Thu, 15 Apr 2021 12:30:53 -0400
Message-ID: <YHhqPYcajI9JgXk/@cmpxchg.org>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wLlUIJ56vn2FytCBhcVr6jOxxhXwMhN3GRBRjO1H938=;
        b=fJ+aTApDvICnAaOoe1KfP5BBtl0Rh1YFuKCLL5fGye5h6BA0p3BoOr8tTI9XEesNsV
         Fp/CKLarivIoqyF5ZKVGf5AMSoeIOp66zzfcxUNrTzVNyrnUoSr9VH4mZpxedYlhvA1o
         SquyxUpSwHzg2Em16wV4jROqCqmxsoDLVVWWoepjSmIPOmXFHqjO70eGS6cNXVP0JtWO
         MFs47w22p+QY7XIGIz617jBPaokG4aLVhDxox4ykRQYSCt58SfNDJS+PEpYO1zmYnY36
         mf1OqSf/833V1NxqpSMwUK8l82gxWSAStXHi1qBk/jSGj3U4MNmM5xnMJzjm1/XGyyKr
         OQEg==
Content-Disposition: inline
In-Reply-To: <20210414012027.5352-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Tue, Apr 13, 2021 at 09:20:24PM -0400, Waiman Long wrote:
> In memcg_slab_free_hook()/pcpu_memcg_free_hook(), obj_cgroup_uncharge()
> is followed by mod_objcg_state()/mod_memcg_state(). Each of these
> function call goes through a separate irq_save/irq_restore cycle. That
> is inefficient.  Introduce a new function obj_cgroup_uncharge_mod_state()
> that combines them with a single irq_save/irq_restore cycle.
>
> @@ -3292,6 +3296,25 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
>  	refill_obj_stock(objcg, size);
>  }
>  
> +void obj_cgroup_uncharge_mod_state(struct obj_cgroup *objcg, size_t size,
> +				   struct pglist_data *pgdat, int idx)

The optimization makes sense.

But please don't combine independent operations like this into a
single function. It makes for an unclear parameter list, it's a pain
in the behind to change the constituent operations later on, and it
has a habit of attracting more random bools over time. E.g. what if
the caller already has irqs disabled? What if it KNOWS that irqs are
enabled and it could use local_irq_disable() instead of save?

Just provide an __obj_cgroup_uncharge() that assumes irqs are
disabled, combine with the existing __mod_memcg_lruvec_state(), and
bubble the irq handling up to those callsites which know better.
