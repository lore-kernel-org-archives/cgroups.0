From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] mm/memcg: Pass both memcg and lruvec to
 mod_memcg_lruvec_state()
Date: Mon, 12 Apr 2021 15:24:34 -0400
Message-ID: <8a188990-325e-bf89-37ae-f0b29481b738@redhat.com>
References: <20210409231842.8840-1-longman@redhat.com>
 <20210409231842.8840-2-longman@redhat.com>
 <YHSLp8bTQGovNLTu@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618255479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sanhxa5ocEIGPBDgrv4bLnJCXX7YJObbafoCV8epdlU=;
        b=fPa9YtVv4Jvi1eQfzPlwx9/jc/Y5hZd7Iy/6YgQWr6PevBeVd0o5HgkSjYogSqRkZa6GgF
        YAmfvVXM8kenvQfTU4HaW6lamxyyJsGGJPmHO2xcqTLqBVeaa6TBecrfK52zJOVqqW+JsF
        CDLQzlU8UmKSRzuxNg+ZIanfwdXYd9w=
In-Reply-To: <YHSLp8bTQGovNLTu-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 4/12/21 2:04 PM, Roman Gushchin wrote:
> On Fri, Apr 09, 2021 at 07:18:38PM -0400, Waiman Long wrote:
>> The caller of mod_memcg_lruvec_state() has both memcg and lruvec readily
>> available. So both of them are now passed to mod_memcg_lruvec_state()
>> and __mod_memcg_lruvec_state(). The __mod_memcg_lruvec_state() is
>> updated to allow either of the two parameters to be set to null. This
>> makes mod_memcg_lruvec_state() equivalent to mod_memcg_state() if lruvec
>> is null.
> This patch seems to be correct, but it's a bit hard to understand why
> it's required without looking into the rest of the series. Can you, please,
> add a couple of words about it? E.g. we need it to handle stats which do not
> exist on the lruvec level...
>
> Otherwise,
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Good point. Will update the commit log to indicate the change is needed 
for the subsequent patch.

Cheers,
Longman


