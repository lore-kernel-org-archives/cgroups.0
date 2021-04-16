From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 1/5] mm/memcg: Pass both memcg and lruvec to
 mod_memcg_lruvec_state()
Date: Fri, 16 Apr 2021 11:48:14 -0400
Message-ID: <YHmxvlkBBlUUYKPG@cmpxchg.org>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-2-longman@redhat.com>
 <YHhsapGx3vTlyZvF@cmpxchg.org>
 <59a85df9-3e77-1d43-8673-2ff50a741130@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jEiyTnsJBz+3LM/AEUTcCopsniGZUGJiJXoqEYpAchc=;
        b=GsMQU312d3+bjYcyvWaGgihp/toAeub1wsouXLWaXNwHYTQaB7LwP4IBLj9mu2lQLa
         8h8x0rgNlRDCog9rTth+hGVzB34zfq9Hn3qbM0yWNpIEM+M4VgKrqe3l4Muu07uoa450
         Pn4cQBsp2krJTlXaDZUKJfDdrEsDatYx/bikcvg3T99IY65JF9VI2D9rfDuL/hSo/kpH
         179UmXP0GzkfbtHB8zlDMj+pyZUnUxNL5Y3alLTVYdvXhGgYCirxlTJNb5x0VUwDDlKA
         7A4xLUEhJ4m5eLGA0Fe9TfGq4nMexHI/lTIoYQjFJctKJWRPCGh0kF0Kg7Yl5t5wxF40
         681g==
Content-Disposition: inline
In-Reply-To: <59a85df9-3e77-1d43-8673-2ff50a741130-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Thu, Apr 15, 2021 at 12:59:21PM -0400, Waiman Long wrote:
> On 4/15/21 12:40 PM, Johannes Weiner wrote:
> > On Tue, Apr 13, 2021 at 09:20:23PM -0400, Waiman Long wrote:
> > > The caller of mod_memcg_lruvec_state() has both memcg and lruvec readily
> > > available. So both of them are now passed to mod_memcg_lruvec_state()
> > > and __mod_memcg_lruvec_state(). The __mod_memcg_lruvec_state() is
> > > updated to allow either of the two parameters to be set to null. This
> > > makes mod_memcg_lruvec_state() equivalent to mod_memcg_state() if lruvec
> > > is null.
> > > 
> > > The new __mod_memcg_lruvec_state() function will be used in the next
> > > patch as a replacement of mod_memcg_state() in mm/percpu.c for the
> > > consolidation of the memory uncharge and vmstat update functions in
> > > the kmem_cache_free() path.
> > This requires users who want both to pass a pgdat that can be derived
> > from the lruvec. This is error prone, and we just acked a patch that
> > removes this very thing from mem_cgroup_page_lruvec().
> > 
> > With the suggestion for patch 2, this shouldn't be necessary anymore,
> > though. And sort of underlines my point around that combined function
> > creating akwward code above and below it.
> > 
> The reason of passing in the pgdat is because of the caching of vmstat data.
> lruvec may be gone if the corresponding memory cgroup is removed, but pgdat
> should stay put. That is why I put pgdat in the obj_stock for caching. I
> could also put the node id instead of pgdat.

Internally storing the pgdat is fine.

I was talking about the interface requiring the user to pass redundant
information (pgdat, can be derived from lruvec) because the parameter
is overloaded to modify the function's behavior, which is unintuitive.
