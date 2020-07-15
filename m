From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Re: [patch] mm, memcg: provide a stat to describe reclaimable
 memory
Date: Wed, 15 Jul 2020 10:33:52 -0700 (PDT)
Message-ID: <alpine.DEB.2.23.453.2007151031020.2788464@chino.kir.corp.google.com>
References: <20200715071522.19663-1-sjpark@amazon.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=PVtPnpDCnFAQV5fwXJEr/RSTBynO8Xc9u6VPuoN4lxA=;
        b=m+o1DG5c/kUGkAGKg+4+dMc3sD7jL5tBy8wqLGklDhgrqf3vjFdT77jGABzg9RUPAt
         XyP7bfZfakKBiM8EpPa4na/ojGxr4Sq2ANVLuQUQWAElOYsfwEYqDO0u8N/t16ayK4XT
         iVJTOLDCrLvwqcTkmdpqjCf8WQNDQsyvNb7We/6fpOL95rNZmN+2RLvMwv2yS1IG51Je
         wRFx7kcVbYKamIHIJvvS8YnodYPyqw2Q0alj0x7sIHHl5ZFp3LdlGzNM4RhlSulYx0HI
         v80pbORRaUrVa+WfDL3e5fR/kQHzO9TqunphHMMcwxDcN2RgoQ6mmy/gMRE4EFHuLYMv
         pvVA==
In-Reply-To: <20200715071522.19663-1-sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: SeongJae Park <sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, 15 Jul 2020, SeongJae Park wrote:

> > An alternative to this would also be to change from an "available" metric 
> > to an "anon_reclaimable" metric since both the deferred split queues and 
> > lazy freeable memory would pertain to anon.  This would no longer attempt 
> > to mimic MemAvailable and leave any such calculation to userspace
> > (anon_reclaimable + (file + slab_reclaimable) / 2).
> > 
> > With this route, care would need to be taken to clearly indicate that 
> > anon_reclaimable is not necessarily a subset of the "anon" metric since 
> > reclaimable memory from compound pages on deferred split queues is not 
> > mapped, so it doesn't show up in NR_ANON_MAPPED.
> > 
> > I'm indifferent to either approach and would be happy to switch to 
> > anon_reclaimable if others agree and doesn't foresee any extensibility 
> > issues.
> 
> Agreed, I was also once confused about the 'MemAvailable'.  The 'reclaimable'
> might be better to understand.
> 

Hi SeongJae,

I'm leaning in that direction now too, actually, because I reasoned that 
determining the precise amount of anon that can be reclaimed would require 
subtracting (file + slab_reclaimable) / 2, which is awkward :)

So I'll send a follow-up patch to add only an anon_reclaimable field which 
is good enough for our purposes unless others would like to have more 
discussion.

Thanks!
