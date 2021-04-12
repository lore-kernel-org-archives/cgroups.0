From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/5] mm/memcg: Cache vmstat data in percpu memcg_stock_pcp
Date: Mon, 12 Apr 2021 16:03:17 -0700
Message-ID: <CALvZod7hBvbnF3G_Hxbu3Xmfzdip_BGAh0Nr86vvN2d9xBTaSg@mail.gmail.com>
References: <20210412225503.15119-1-longman@redhat.com> <20210412225503.15119-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rzJqdflF0WnnM2sRHImKq0cVYdyTkByzLc0YHSLjXyw=;
        b=l2UdhHrElVUDwH0hdCZbLmqJp9H1jOKWmea9EvpaCTnJg5biZnZtb90GZq56pXCyuL
         qlITzfF7jqj7p3Lwo2BljksTyDdQntYdb2F6iYN5MWSe2I78ThxWhzTPYt12pd8zQkZa
         EsBPugLlm71CgY1zGZO46yoGkv140ySoB1/dNn2mPuYmBbgjUZjiqnjW7qyaohgtvdR2
         kr+fqLblcbKMouw1xITBfF2HuH64dkNcLLgG42WRVITR+ju2d1jxzzyHn+t6WSrO9u4W
         wtr8cSWu9xge+Hw9P0frVBFEToUDcRKjbOKQNbzfpoNK6N7K/sIMT7uakUFRPOaQuiIR
         Qx7Q==
In-Reply-To: <20210412225503.15119-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing@linu>

On Mon, Apr 12, 2021 at 3:55 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Before the new slab memory controller with per object byte charging,
> charging and vmstat data update happen only when new slab pages are
> allocated or freed. Now they are done with every kmem_cache_alloc()
> and kmem_cache_free(). This causes additional overhead for workloads
> that generate a lot of alloc and free calls.
>
> The memcg_stock_pcp is used to cache byte charge for a specific
> obj_cgroup to reduce that overhead. To further reducing it, this patch
> makes the vmstat data cached in the memcg_stock_pcp structure as well
> until it accumulates a page size worth of update or when other cached
> data change.
>
> On a 2-socket Cascade Lake server with instrumentation enabled and this
> patch applied, it was found that about 17% (946796 out of 5515184) of the
> time when __mod_obj_stock_state() is called leads to an actual call to
> mod_objcg_state() after initial boot. When doing parallel kernel build,
> the figure was about 16% (21894614 out of 139780628). So caching the
> vmstat data reduces the number of calls to mod_objcg_state() by more
> than 80%.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
