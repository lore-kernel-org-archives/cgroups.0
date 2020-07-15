From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mm, memcg: provide a stat to describe reclaimable
 memory
Date: Wed, 15 Jul 2020 11:02:17 -0700 (PDT)
Message-ID: <alpine.DEB.2.23.453.2007151046320.2788464@chino.kir.corp.google.com>
References: <alpine.DEB.2.23.453.2007142018150.2667860@chino.kir.corp.google.com> <20200715131048.GA176092@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=efkhNeEkLOjfJ9I4e0oRt4e4kTv057I//aIthLXwk+4=;
        b=gfYBzPAL5ljuHa5xHEF//P+SpxTqUqYICl87X3M+8snDxzuNN9aNHL2JwlDa8QPeCK
         Ogydr3EugZ+CCERspKV6dYgfysjjwX9w72PQ8VYS2U/Dol+KxYhX1qymB7AcnHDVD8xD
         43eITafEnVz7eN/Ej2/L8OQ74EAAy9X/rfVVJxx/w1iM+l8giQoXC5I4Eg2rS1p+N5Il
         obK4wMmLdQKGMsQuFCbNxh2sdoe1wKBGkJEZbwCZeJ4irgU9ho8kKjOBkMUgnL5mJsvP
         ASilybwNDWe9LASB+l0P6EGaR+7VGo/BslBAs5gMd3mqwlAl2Qm6/55pf8Z/kPUV581L
         TJaw==
In-Reply-To: <20200715131048.GA176092-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, 15 Jul 2020, Chris Down wrote:

> Hi David,
> 
> I'm somewhat against adding more metrics which try to approximate availability
> of memory when we already know it not to generally manifest very well in
> practice, especially since this *is* calculable by userspace (albeit with some
> knowledge of mm internals). Users and applications often vastly overestimate
> the reliability of these metrics, especially since they heavily depend on
> transient page states and whatever reclaim efficacy happens to be achieved at
> the time there is demand.
> 

Hi Chris,

With the proposed anon_reclaimable, do you have any reliability concerns?  
This would be the amount of lazy freeable memory and memory that can be 
uncharged if compound pages from the deferred split queue are split under 
memory pressure.  It seems to be a very precise value (as slab_reclaimable 
already in memory.stat is), so I'm not sure why there is a reliability 
concern.  Maybe you can elaborate?

Today, this information is indeed possible to calculate from userspace.  
The idea is to present this information that will be backwards compatible, 
however, as the kernel implementation changes.  When lazy freeable memory 
was added, for instance, userspace likely would not have preemptively been 
doing an "active_file + inactive_file - file" calculation to factor that 
in as reclaimable anon :)

> What do you intend to do with these metrics and how do you envisage other
> users should use them? Is it not possible to rework the strategy to use
> pressure information and/or workingset pressurisation instead?
> 

Previously, users would interpret their anon usage as non reclaimable if 
swap is disabled and now that value can include a *lot* of easily 
reclaimable memory.  Our users would also carefully monitor their current 
memcg usage and/or anon usage to detect abnormalities without concern for 
what is reclaimable, especially for things like deferred split queues that 
was purely a kernel implementation change.  Memcg usage and anon usag then 
becomes wildly different between kernel versions and our users alert on 
that abnormality.

The example I gave earlier in the thread showed how dramatically different 
memory.current is before and after the introduction of deferred split 
queues.  Userspace sees ballooning memcg usage and alerts on it (suspects 
a memory leak, for example) when in reality this is purely reclaimable 
memory under pressure and is the result of a kernel implementation detail.

We plan on factoring this information in when determining what the actual 
amount of memory that can and cannot be reclaimed from a memcg hierarchy 
at any given time.
