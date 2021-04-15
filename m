From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/5] mm/memcg: Pass both memcg and lruvec to
 mod_memcg_lruvec_state()
Date: Thu, 15 Apr 2021 12:59:21 -0400
Message-ID: <59a85df9-3e77-1d43-8673-2ff50a741130@redhat.com>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-2-longman@redhat.com> <YHhsapGx3vTlyZvF@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618505979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=elHrGsyviNRX+T8DndgeK2yskuXfifgVcBuAA2Ta4Ok=;
        b=ewyXg4zk7G8LPtm97g8uMyScjtrJePy7OCx2SFjFsyU0Z85qgGi7wh+cEV9rB9wSh7TcPW
        c89zEp/NM3T70m2NioU9smDZgnTGxrZxG6DyNYlbgDMFVdJbz0+APdu34658zc6Fu2kea5
        /D3XGef37+yY+RPxaTRzDF0PuIHttas=
In-Reply-To: <YHhsapGx3vTlyZvF-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 4/15/21 12:40 PM, Johannes Weiner wrote:
> On Tue, Apr 13, 2021 at 09:20:23PM -0400, Waiman Long wrote:
>> The caller of mod_memcg_lruvec_state() has both memcg and lruvec readily
>> available. So both of them are now passed to mod_memcg_lruvec_state()
>> and __mod_memcg_lruvec_state(). The __mod_memcg_lruvec_state() is
>> updated to allow either of the two parameters to be set to null. This
>> makes mod_memcg_lruvec_state() equivalent to mod_memcg_state() if lruvec
>> is null.
>>
>> The new __mod_memcg_lruvec_state() function will be used in the next
>> patch as a replacement of mod_memcg_state() in mm/percpu.c for the
>> consolidation of the memory uncharge and vmstat update functions in
>> the kmem_cache_free() path.
> This requires users who want both to pass a pgdat that can be derived
> from the lruvec. This is error prone, and we just acked a patch that
> removes this very thing from mem_cgroup_page_lruvec().
>
> With the suggestion for patch 2, this shouldn't be necessary anymore,
> though. And sort of underlines my point around that combined function
> creating akwward code above and below it.
>
The reason of passing in the pgdat is because of the caching of vmstat 
data. lruvec may be gone if the corresponding memory cgroup is removed, 
but pgdat should stay put. That is why I put pgdat in the obj_stock for 
caching. I could also put the node id instead of pgdat.

Cheers,
Longman

