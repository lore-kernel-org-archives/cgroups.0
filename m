From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: expose root cgroup's memory.stat
Date: Fri, 8 May 2020 17:44:05 -0400
Message-ID: <20200508214405.GA226164@cmpxchg.org>
References: <20200508170630.94406-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hfgFNTJ/A8Lg7nI9g+Xp3FmILdU0dHMohrFwQmfLQXo=;
        b=BO4e5bD/Q+sMJjS2zPBJ9fA0BfYUE6sPFxYwsNOwSV4A2F0R22Kk02cgB2O7t3YZjN
         WXq235+CpxzxCfyxC4UYLkH/H+vrK1wMRWc3F3A11zVLIM3R2j0B/m2cBQTChZS2n/IP
         ycONKTo/SlL6z7hvTvz8LF/MSBS+pQTo+GfyZVFUF2s22DI7IQqTmOIRk93B6ONU/3d+
         Pq1q9czvaqdabgSzhAER31wB8ODppfSiaxEfMXyIsYMZeQmm7jGvrzMFyqWdkB6tXXwH
         A2Lb4VY/NrvuvTG+OprSMVStvHwAZoJcabj5QflkXcTJuSH6Gb0UOWCFSguBlgr8iiZr
         7VuQ==
Content-Disposition: inline
In-Reply-To: <20200508170630.94406-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 08, 2020 at 10:06:30AM -0700, Shakeel Butt wrote:
> One way to measure the efficiency of memory reclaim is to look at the
> ratio (pgscan+pfrefill)/pgsteal. However at the moment these stats are
> not updated consistently at the system level and the ratio of these are
> not very meaningful. The pgsteal and pgscan are updated for only global
> reclaim while pgrefill gets updated for global as well as cgroup
> reclaim.
> 
> Please note that this difference is only for system level vmstats. The
> cgroup stats returned by memory.stat are actually consistent. The
> cgroup's pgsteal contains number of reclaimed pages for global as well
> as cgroup reclaim. So, one way to get the system level stats is to get
> these stats from root's memory.stat, so, expose memory.stat for the root
> cgroup.
> 
> 	from Johannes Weiner:
> 	There are subtle differences between /proc/vmstat and
> 	memory.stat, and cgroup-aware code that wants to watch the full
> 	hierarchy currently has to know about these intricacies and
> 	translate semantics back and forth.
> 
> 	Generally having the fully recursive memory.stat at the root
> 	level could help a broader range of usecases.

The changelog begs the question why we don't just "fix" the
system-level stats. It may be useful to include the conclusions from
that discussion, and why there is value in keeping the stats this way.

> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
