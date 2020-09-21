From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Mon, 21 Sep 2020 18:30:55 +0200
Message-ID: <20200921163055.GQ12990@dhcp22.suse.cz>
References: <20200909215752.1725525-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600705856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eU/CicWZpDdvdLu+VtNr7opHyCa0NGxGdgD8aIFSXMo=;
        b=PRpdvcHC33L60xFXcwyptnBlBYfsLtFzPSGiGsPkOOg0QwjORmuBW1r+0xNQxQX+J7PxwN
        41gAQ7J1b9nYGpiItpdXHj0D4qTPMtpBR3oMwVjI7EnW5ZPEw6R1FEh8rAbWGyABLPoYdZ
        62uPgYcmPx2Djiz/xHMjr09Y+sYM5Qo=
Content-Disposition: inline
In-Reply-To: <20200909215752.1725525-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 09-09-20 14:57:52, Shakeel Butt wrote:
> Introduce an memcg interface to trigger memory reclaim on a memory cgroup.
> 
> Use cases:
> ----------
> 
> 1) Per-memcg uswapd:
> 
> Usually applications consists of combination of latency sensitive and
> latency tolerant tasks. For example, tasks serving user requests vs
> tasks doing data backup for a database application. At the moment the
> kernel does not differentiate between such tasks when the application
> hits the memcg limits. So, potentially a latency sensitive user facing
> task can get stuck in high reclaim and be throttled by the kernel.
> 
> Similarly there are cases of single process applications having two set
> of thread pools where threads from one pool have high scheduling
> priority and low latency requirement. One concrete example from our
> production is the VMM which have high priority low latency thread pool
> for the VCPUs while separate thread pool for stats reporting, I/O
> emulation, health checks and other managerial operations. The kernel
> memory reclaim does not differentiate between VCPU thread or a
> non-latency sensitive thread and a VCPU thread can get stuck in high
> reclaim.

As those are presumably in the same cgroup what does prevent them to get
stuck behind shared resources with taken during the reclaim performed by
somebody else? I mean, memory reclaim might drop memory used by the high
priority task. Or they might simply stumble over same locks.

I am also more interested in actual numbers here. The high limit reclaim
is normally swift and should be mostly unnoticeable. If the reclaim gets
more expensive then it can get really noticeable for sure. But for the
later the same can happen with the external pro-activee reclaimer as
well, right? So there is no real "guarantee". Do you have any numbers
from your workloads where you can demonstrate that the external reclaim
has saved you this amount of effective cpu time of the sensitive
workload? (Essentially measure how much time it has to consume in the
high limit reclaim)

To the feature itself, I am not yet convinced we want to have a feature
like that. It surely sounds easy to use and attractive for a better user
space control. It is also much well defined than drop_caches/force_empty
because it is not all or nothing. But it also sounds like something too
easy to use incorrectly (remember drop_caches). I am also a bit worried
about corner cases wich would be easier to hit - e.g. fill up the swap
limit and turn anonymous memory into unreclaimable and who knows what
else.
-- 
Michal Hocko
SUSE Labs
