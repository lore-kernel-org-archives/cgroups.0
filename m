From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Tue, 29 Sep 2020 17:04:44 +0200
Message-ID: <20200929150444.GG2277@dhcp22.suse.cz>
References: <20200909215752.1725525-1-shakeelb@google.com>
 <20200928210216.GA378894@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601391886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BK7zsoCScu7iUZFoKsqeYor8HokJPerHJKMNvd3iTAo=;
        b=X0bhDucboFOYukcc7cM6CgWPOH3Rf+ilMyYdAXP8JWtTcN2ymeRID9j68NiB2ZJGCZYx3Q
        JzA7ZzQI15e65/pR4F3BG/EaXJnQz2cgQn2cgbRgLLJcuu/PZMGU0b4exblOFvu+6XVT/Z
        4Xx9ee/8vd1rTiRrhHjAP7obubmgpL4=
Content-Disposition: inline
In-Reply-To: <20200928210216.GA378894-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 28-09-20 17:02:16, Johannes Weiner wrote:
[...]
> My take is that a proactive reclaim feature, whose goal is never to
> thrash or punish but to keep the LRUs warm and the workingset trimmed,
> would ideally have:
> 
> - a pressure or size target specified by userspace but with
>   enforcement driven inside the kernel from the allocation path
> 
> - the enforcement work NOT be done synchronously by the workload
>   (something I'd argue we want for *all* memory limits)
> 
> - the enforcement work ACCOUNTED to the cgroup, though, since it's the
>   cgroup's memory allocations causing the work (again something I'd
>   argue we want in general)
> 
> - a delegatable knob that is independent of setting the maximum size
>   of a container, as that expresses a different type of policy
> 
> - if size target, self-limiting (ha) enforcement on a pressure
>   threshold or stop enforcement when the userspace component dies
> 
> Thoughts?

Agreed with above points. What do you think about
http://lkml.kernel.org/r/20200922190859.GH12990-2MMpYkNvuYA6bu5BqYkRsg@public.gmane.org I assume
that you do not want to override memory.high to implement this because
that tends to be tricky from the configuration POV as you mentioned
above. But a new limit (memory.middle for a lack of a better name) to
define the background reclaim sounds like a good fit with above points.

-- 
Michal Hocko
SUSE Labs
