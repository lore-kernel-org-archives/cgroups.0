From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH-next v5 3/4] mm/memcg: Improve refill_obj_stock()
 performance
Date: Wed, 21 Apr 2021 16:55:34 -0700
Message-ID: <YIC7dh0+nQDFmU+T@carbon.dhcp.thefacebook.com>
References: <20210420192907.30880-1-longman@redhat.com>
 <20210420192907.30880-4-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KXymcwLV1RUhO127TJbcozKUy+8pPOtW5b5KBrtdntQ=;
 b=BRXxPZJgu3bmq6GKfll8Imb4Qsk7O6PD8vp09GdJs9tfG+UA5DhCtPN5IGjd+DWUTD0G
 nRdKTbtPJL9MJXg3LZa0rjJ1bRiFA73kEAmNyD1J2IKdFlcvXZugy6T3vEb8d/lPL90s
 fdqxhhfSU8pf8hyEdZ0C+Bjaj2ZhnDIsFpI= 
Content-Disposition: inline
In-Reply-To: <20210420192907.30880-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Tue, Apr 20, 2021 at 03:29:06PM -0400, Waiman Long wrote:
> There are two issues with the current refill_obj_stock() code. First of
> all, when nr_bytes reaches over PAGE_SIZE, it calls drain_obj_stock() to
> atomically flush out remaining bytes to obj_cgroup, clear cached_objcg
> and do a obj_cgroup_put(). It is likely that the same obj_cgroup will
> be used again which leads to another call to drain_obj_stock() and
> obj_cgroup_get() as well as atomically retrieve the available byte from
> obj_cgroup. That is costly. Instead, we should just uncharge the excess
> pages, reduce the stock bytes and be done with it. The drain_obj_stock()
> function should only be called when obj_cgroup changes.

I really like this idea! Thanks!

However, I wonder if it can implemented simpler by splitting drain_obj_stock()
into two functions:
     empty_obj_stock() will flush cached bytes, but not reset the objcg
     drain_obj_stock() will call empty_obj_stock() and then reset objcg

Then we simple can replace the second drain_obj_stock() in
refill_obj_stock() with empty_obj_stock(). What do you think?

> 
> Secondly, when charging an object of size not less than a page in
> obj_cgroup_charge(), it is possible that the remaining bytes to be
> refilled to the stock will overflow a page and cause refill_obj_stock()
> to uncharge 1 page. To avoid the additional uncharge in this case,
> a new overfill flag is added to refill_obj_stock() which will be set
> when called from obj_cgroup_charge().
> 
> A multithreaded kmalloc+kfree microbenchmark on a 2-socket 48-core
> 96-thread x86-64 system with 96 testing threads were run.  Before this
> patch, the total number of kilo kmalloc+kfree operations done for a 4k
> large object by all the testing threads per second were 4,304 kops/s
> (cgroup v1) and 8,478 kops/s (cgroup v2). After applying this patch, the
> number were 4,731 (cgroup v1) and 418,142 (cgroup v2) respectively. This
> represents a performance improvement of 1.10X (cgroup v1) and 49.3X
> (cgroup v2).

This part looks more controversial. Basically if there are N consequent
allocations of size (PAGE_SIZE + x), the stock will end up with (N * x)
cached bytes, right? It's not the end of the world, but do we really
need it given that uncharging a page is also cached?

Thanks!
