From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/9] memcg: use css_get/put when charging/uncharging kmem
Date: Fri, 17 May 2013 11:08:22 -0700
Message-ID: <20130517180822.GC12632@mtj.dyndns.org>
References: <5195D5F8.7000609@huawei.com>
 <5195D666.6030408@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=GVuPDFNR0ALJuSST698bPnLZyt/s2V9YBrDZWiOfqHo=;
        b=DwsqXhVbbdepfCvcvHSEmmdNEfc15UWbKh6FvIuMhsYkgBk5cppdQ66sH7lLOLw9Il
         RWXdAMNPXpRD1yW8RPmN0M6GySEV5eg/kYlnQx6wGCQ8+cISzEKgMjhZDJlxZjVjCKfp
         Ek4CPV1PlK8Cly8vj/6kKpAjSWKXDHERa7xA+MZVEFlFdvtV54EaCFNUHSve3lKVzyI2
         qwsaYIU3TBDHMQakBeR4H0qQvK4bIDbyedn+SkTwSfHIEZlRMkRZQjWSVHpJpvWJGHfi
         C3SMfKpIocdc+l6qD6j3zPhxZtn9TZ0vEprT0uloiVgaYE7l7BF3ivQn8pqrCFfOz15t
         FRpA==
Content-Disposition: inline
In-Reply-To: <5195D666.6030408-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hey,

On Fri, May 17, 2013 at 03:04:06PM +0800, Li Zefan wrote:
> +	/*
> +	 * Releases a reference taken in kmem_cgroup_css_offline in case
> +	 * this last uncharge is racing with the offlining code or it is
> +	 * outliving the memcg existence.
> +	 *
> +	 * The memory barrier imposed by test&clear is paired with the
> +	 * explicit one in kmem_cgroup_css_offline.

Paired with the wmb to achieve what?

> +	 */
>  	if (memcg_kmem_test_and_clear_dead(memcg))
> -		mem_cgroup_put(memcg);
> +		css_put(&memcg->css);

The other side is wmb, so there gotta be something which wants to read
which were written before wmb here but the only thing after the
barrier is css_put() which doesn't need such thing, so I'm lost on
what the barrier pair is achieving here.

In general, please be *very* explicit about what's going on whenever
something is depending on barrier pairs.  It'll make it easier for
both the author and reviewers to actually understand what's going on
and why it's necessary.

...
> @@ -5858,23 +5856,39 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
>  	return mem_cgroup_sockets_init(memcg, ss);
>  }
>  
> -static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
> +static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
>  {
> -	mem_cgroup_sockets_destroy(memcg);
> +	if (!memcg_kmem_is_active(memcg))
> +		return;
>  
> +	/*
> +	 * kmem charges can outlive the cgroup. In the case of slab
> +	 * pages, for instance, a page contain objects from various
> +	 * processes. As we prevent from taking a reference for every
> +	 * such allocation we have to be careful when doing uncharge
> +	 * (see memcg_uncharge_kmem) and here during offlining.
> +	 *
> +	 * The idea is that that only the _last_ uncharge which sees
> +	 * the dead memcg will drop the last reference. An additional
> +	 * reference is taken here before the group is marked dead
> +	 * which is then paired with css_put during uncharge resp. here.
> +	 *
> +	 * Although this might sound strange as this path is called when
> +	 * the reference has already dropped down to 0 and shouldn't be
> +	 * incremented anymore (css_tryget would fail) we do not have

Hmmm?  offline is called on cgroup destruction regardless of css
refcnt.  The above comment seems a bit misleading.

> +	 * other options because of the kmem allocations lifetime.
> +	 */
> +	css_get(&memcg->css);
> +
> +	/* see comment in memcg_uncharge_kmem() */
> +	wmb();
>  	memcg_kmem_mark_dead(memcg);

Is the wmb() trying to prevent reordering between css_get() and
memcg_kmem_mark_dead()?  If so, it isn't necessary - the compiler
isn't allowed to reorder two atomic ops (they're all asm volatiles)
and the visibility order is guaranteed by the nature of the two
operations going on here - both perform modify-and-test on one end of
the operations.

It could be argued that having memory barriers is better for
completeness of mark/test interface but then those barriers should
really moved into memcg_kmem_mark_dead() and its clearing counterpart.

While it's all clever and dandy, my recommendation would be just using
a lock for synchronization.  It isn't a hot path.  Why be clever?

Thanks.

-- 
tejun
