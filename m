From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] memcg: expose root cgroup's memory.stat
Date: Sat, 16 May 2020 02:42:47 +0100
Message-ID: <20200516014247.GA8578@chrisdown.name>
References: <20200508170630.94406-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kS8OYMG072jDcI6wkY/z+PD46Du/tMZhKnhnXKRsoeo=;
        b=AH0puOca79INHP4Gyjk8o8AyxnmdUlm/s7CIZkXpa4xvSasJLmdH8L2vWT0y+OPoA2
         I0dBbUpqu90pgUFRkEbf4DKo2KVJwQ7QIFWnpt9s6w4TNSbgkI5skacNqeGVjFYdGK2v
         XfuM/QsPsOjBfWclFvjZVsVcN2YdvdcuqqfPA=
Content-Disposition: inline
In-Reply-To: <20200508170630.94406-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey Shakeel,

Shakeel Butt writes:
>One way to measure the efficiency of memory reclaim is to look at the
>ratio (pgscan+pfrefill)/pgsteal. However at the moment these stats are
>not updated consistently at the system level and the ratio of these are
>not very meaningful. The pgsteal and pgscan are updated for only global
>reclaim while pgrefill gets updated for global as well as cgroup
>reclaim.
>
>Please note that this difference is only for system level vmstats. The
>cgroup stats returned by memory.stat are actually consistent. The
>cgroup's pgsteal contains number of reclaimed pages for global as well
>as cgroup reclaim. So, one way to get the system level stats is to get
>these stats from root's memory.stat, so, expose memory.stat for the root
>cgroup.
>
>	from Johannes Weiner:
>	There are subtle differences between /proc/vmstat and
>	memory.stat, and cgroup-aware code that wants to watch the full
>	hierarchy currently has to know about these intricacies and
>	translate semantics back and forth.
>
>	Generally having the fully recursive memory.stat at the root
>	level could help a broader range of usecases.
>
>Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

The patch looks great, thanks. To that extent you can add my ack:

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

One concern about the API now exposed, though: to a new cgroup v2 user this 
looks fairly dodgy as a sole stat file (except for cgroup.stat) at the root. If 
I used cgroup v2 for the first time and only saw memory.stat and cgroup.stat 
there, but for some reason io.stat and cpu.stat are not available at the root 
but are available everywhere else, I think my first thought would be that the 
cgroup v2 developers must have been on some strong stuff when they came up with 
this ;-)

Even if they're only really duplicating information available elsewhere right 
now, have you considered exposing the rest of the stat files as well so that 
the API maintains a bit more consistency? As a bonus, that also means userspace 
applications can parse in the same way from the root down.
