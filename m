From: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Subject: Re: [PATCH memcg v3 2/3] mm, oom: do not trigger out_of_memory from
 the #PF
Date: Tue, 26 Oct 2021 22:56:44 +0900
Message-ID: <62a326bc-37d2-b8c9-ddbf-7adaeaadf341@i-love.sakura.ne.jp>
References: <YXJ/63kIpTq8AOlD@dhcp22.suse.cz>
 <cover.1634994605.git.vvs@virtuozzo.com>
 <f5fd8dd8-0ad4-c524-5f65-920b01972a42@virtuozzo.com>
 <e2a847a2-a414-2535-e3d1-b100a023b9d1@i-love.sakura.ne.jp>
 <YXZk9Lr217e+saSM@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <YXZk9Lr217e+saSM-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 2021/10/25 17:04, Michal Hocko wrote:
> I do not think there is any guarantee. This code has meant to be a
> safeguard but it turns out to be adding more harm than a safety. There
> are several scenarios mentioned in this thread where this would be
> counter productive or outright wrong thing to do.

Setting PR_IO_FLUSHER via prctl(PR_SET_IO_FLUSHER) + hitting legacy kmem
charge limit might be an unexpected combination?

> 
> On the other hand it is hard to imagine any legitimate situation where
> this would be a right thing to do. Maybe you have something more
> specific in mind? What would be the legit code to rely on OOM handling
> out of the line (where the details about the allocation scope is lost)?

I don't have specific scenario, but I feel that it might be a chance to
retry killable vmalloc(). Commit b8c8a338f75e ("Revert "vmalloc: back off
when the current task is killed"") was 4.5 years ago, and fuzz testing found
many bugs triggered by memory allocation fault injection. Thus, I think that
the direction is going towards "we can fail memory allocation upon SIGKILL
(rather than worrying about depleting memory reserves and/or escalating to
global OOM killer invocations)". Most memory allocation requests which
allocate memory for userspace process are willing to give up upon SIGKILL.

Like you are trying to add NOFS, NOIO, NOFAIL support to vmalloc(), you could
consider KILLABLE support as well. Of course, direct reclaim makes it difficult
to immediately give up upon SIGKILL, but killable allocation sounds still nice
even if best-effort basis.

