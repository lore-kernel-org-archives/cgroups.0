From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/5] mm/memcg: Reduce kmemcache memory accounting
 overhead
Date: Thu, 15 Apr 2021 09:17:37 -0400
Message-ID: <12cba05a-e268-3a5d-69d7-feb00e36ef40@redhat.com>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210415032642.gfaevezaxoj4od3d@gabell>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618492662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ekDAkkr77eB7AxytMHc6R8nrzotwIpYRJxiGpMYfIQ=;
        b=Uodcfmich+hUu73FW+LcOlBja1FCvDUuXc6PZIxoTKwKY8wz/0vxmVlSoTtLrbTs8tZbDQ
        /eC31E+HrGkb4Pg8T2uCUnLshzWrTZ23G95We/HPi8Lk3ab4qn7xKlA2pDGV9k0bnEzxVF
        FcyO60eD28Ig+kUaum1j6rwvKC5cHQU=
In-Reply-To: <20210415032642.gfaevezaxoj4od3d@gabell>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 4/14/21 11:26 PM, Masayoshi Mizuma wrote:
>
> Hi Longman,
>
> Thank you for your patches.
> I rerun the benchmark with your patches, it seems that the reduction
> is small... The total duration of sendto() and recvfrom() system call
> during the benchmark are as follows.
>
> - sendto
>    - v5.8 vanilla:                      2576.056 msec (100%)
>    - v5.12-rc7 vanilla:                 2988.911 msec (116%)
>    - v5.12-rc7 with your patches (1-5): 2984.307 msec (115%)
>
> - recvfrom
>    - v5.8 vanilla:                      2113.156 msec (100%)
>    - v5.12-rc7 vanilla:                 2305.810 msec (109%)
>    - v5.12-rc7 with your patches (1-5): 2287.351 msec (108%)
>
> kmem_cache_alloc()/kmem_cache_free() are called around 1,400,000 times during
> the benchmark. I ran a loop in a kernel module as following. The duration
> is reduced by your patches actually.
>
>    ---
>    dummy_cache = KMEM_CACHE(dummy, SLAB_ACCOUNT);
>    for (i = 0; i < 1400000; i++) {
> 	p = kmem_cache_alloc(dummy_cache, GFP_KERNEL);
> 	kmem_cache_free(dummy_cache, p);
>    }
>    ---
>
> - v5.12-rc7 vanilla:                 110 msec (100%)
> - v5.12-rc7 with your patches (1-5):  85 msec (77%)
>
> It seems that the reduction is small for the benchmark though...
> Anyway, I can see your patches reduce the overhead.
> Please feel free to add:
>
> 	Tested-by: Masayoshi Mizuma <m.mizuma-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>
> Thanks!
> Masa
>
Thanks for the testing.

I was focusing on your kernel module benchmark in testing my patch. I 
will try out your pgbench benchmark to see if there can be other tuning 
that can be done.

BTW, how many numa nodes does your test machine? I did my testing with a 
2-socket system. The vmstat caching part may be less effective on 
systems with more numa nodes. I will try to find a larger 4-socket 
systems for testing.

Cheers,
Longman

