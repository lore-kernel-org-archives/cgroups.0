From: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/5] mm/memcg: Reduce kmemcache memory accounting
 overhead
Date: Thu, 15 Apr 2021 11:47:36 -0400
Message-ID: <20210415154736.snzrxq625p5l4lz2@gabell>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210415032642.gfaevezaxoj4od3d@gabell>
 <12cba05a-e268-3a5d-69d7-feb00e36ef40@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AoDRJbLhMyQN2f8H9fWTQ1c7bXpVm9d9RpwiX2eJiww=;
        b=jFxMl4vLIYgEpSsFOV8F7i3rw0jACscm7gLRIKbiEuAbWE6cjlPjmSkDy3RSDhymgc
         Mf3aIPkQgNSQkNsoUBiSu60LBVb+j8HeD5EGEylP2G1Mj88RGelW/CajdtkuRAPEfkdh
         b1PMRpJy8OvtXd56NpLVQQSYxbvehwATyTdFLpAIPJMEgsI3agh1t6pQznu3Bfkpd0rW
         3mjDu7+0mVhQcpyLAJQpDIaRLrfBcmY99jrBLcAS0qew2TyXueJLZdwgZvS1XBXP1E/+
         NmqNrPgAuyE/qyeC9gJeoO27v8xUHMBxkE8nuKxSPEOYd/5WNHTdc23ERpAI5PgLVONm
         GElw==
Content-Disposition: inline
In-Reply-To: <12cba05a-e268-3a5d-69d7-feb00e36ef40-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Thu, Apr 15, 2021 at 09:17:37AM -0400, Waiman Long wrote:
> I was focusing on your kernel module benchmark in testing my patch. I will
> try out your pgbench benchmark to see if there can be other tuning that can
> be done.

Thanks a lot!

> BTW, how many numa nodes does your test machine? I did my testing with a
> 2-socket system. The vmstat caching part may be less effective on systems
> with more numa nodes. I will try to find a larger 4-socket systems for
> testing.

The test machine has one node.

- Masa
