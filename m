From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered
 memory
Date: Tue, 6 Apr 2021 11:08:42 +0200
Message-ID: <YGwlGrHtDJPQF7UG@dhcp22.suse.cz>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617700123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+xOwykMT0eamXfCJ+cRJDX97KIiXiqqoybhZz05k4kE=;
        b=DtMYcBTnjx9dUFxs4dTtpXmx9nd/IwUaDXm0RMNwa/2CTUnx1EHnOMHwhshsRa+WrtKYf9
        zl9eTafKeg9ZNn8OTE71ArZg20dckZXIftKR09DLkU1YtMmhZ8fg8QE3XeW2sfX3Y/yPG/
        j/k4GeKheiATA6gmPjKWrmV6LCjiNQ4=
Content-Disposition: inline
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 05-04-21 10:08:24, Tim Chen wrote:
[...]
> To make fine grain cgroup based management of the precious top tier
> DRAM memory possible, this patchset adds a few new features:
> 1. Provides memory monitors on the amount of top tier memory used per cgroup 
>    and by the system as a whole.
> 2. Applies soft limits on the top tier memory each cgroup uses 
> 3. Enables kswapd to demote top tier pages from cgroup with excess top
>    tier memory usages.

Could you be more specific on how this interface is supposed to be used?

> This allows us to provision different amount of top tier memory to each
> cgroup according to the cgroup's latency need.
> 
> The patchset is based on cgroup v1 interface. One shortcoming of the v1
> interface is the limit on the cgroup is a soft limit, so a cgroup can
> exceed the limit quite a bit before reclaim before page demotion reins
> it in. 

I have to say that I dislike abusing soft limit reclaim for this. In the
past we have learned that the existing implementation is unfixable and
changing the existing semantic impossible due to backward compatibility.
So I would really prefer the soft limit just find its rest rather than
see new potential usecases.

I haven't really looked into details of this patchset but from a cursory
look it seems like you are actually introducing a NUMA aware limits into
memcg that would control consumption from some nodes differently than
other nodes. This would be rather alien concept to the existing memcg
infrastructure IMO. It looks like it is fusing borders between memcg and
cputset controllers.

You also seem to be basing the interface on the very specific usecase.
Can we expect that there will be many different tiers requiring their
own balancing?

-- 
Michal Hocko
SUSE Labs
