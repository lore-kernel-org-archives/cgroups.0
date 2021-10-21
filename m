From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg 3/3] memcg: handle memcg oom failures
Date: Thu, 21 Oct 2021 18:05:28 +0300
Message-ID: <b618ac5c-e982-c4af-ecf3-564b8de52c8c@virtuozzo.com>
References: <YW/WoJDFM3ddHn7Y@dhcp22.suse.cz>
 <cover.1634730787.git.vvs@virtuozzo.com>
 <fb33f4bd-34cd-2187-eff4-7c1c11d5ae94@virtuozzo.com>
 <YXATW7KsUZzbbGHy@dhcp22.suse.cz>
 <d3b32c72-6375-f755-7599-ab804719e1f6@virtuozzo.com>
 <YXFPSvGFV539OcEk@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=AYjhXpu3d6kOZxLRp2DlsnHvgXfNmVMqUthXj2mtzdE=; b=SW7BgefMYeIgcg9wr
        tbO/vMTgWtXtJGnhebekO+7U9ELGuifOlYecO7GEMUO4C+EC71xqXSXzmfgl4CEXJ7bB4i9EiKsX5
        ymCQGp9TN7AN3ra6WwRwJRkjbXQ4RQtWOgAC7WEayaqg6QpuvFQ71toI3mt2NHcnRbAjJPIHzi8Po
        =;
In-Reply-To: <YXFPSvGFV539OcEk-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 21.10.2021 14:49, Michal Hocko wrote:
> I do understand that handling a very specific case sounds easier but it
> would be better to have a robust fix even if that requires some more
> head scratching. So far we have collected several reasons why the it is
> bad to trigger oom killer from the #PF path. There is no single argument
> to keep it so it sounds like a viable path to pursue. Maybe there are
> some very well hidden reasons but those should be documented and this is
> a great opportunity to do either of the step.
> 
> Moreover if it turns out that there is a regression then this can be
> easily reverted and a different, maybe memcg specific, solution can be
> implemented.

Now I'm agree,
however I still have a few open questions.

1) VM_FAULT_OOM may be triggered w/o execution of out_of_memory()
for exampel it can be caused by incorrect vm fault operations, 
(a) which can return this error without calling allocator at all.
(b) or which can provide incorrect gfp flags and allocator can fail without execution of out_of_memory.
(c) This may happen on stable/LTS kernels when successful allocation was failed by hit into limit of legacy memcg-kmem contoller.
We'll drop it in upstream kernels, however how to handle it in old kenrels?

We can make sure that out_of_memory or alocator was called by set of some per-task flags.

Can pagefault_out_of_memory() send itself a SIGKILL in all these cases?

If not -- task will be looped. 
It is much better than execution of global OOM, however it would be even better to avoid it somehow.

You said: "We cannot really kill the task if we could we would have done it by the oom killer already".
However what to do if we even not tried to use oom-killer? (see (b) and (c)) 
or if we did not used the allocator at all (see (a))

2) in your patch we just exit from pagefault_out_of_memory(). and restart new #PF.
We can call schedule_timeout() and wait some time before a new #PF restart.
Additionally we can increase this delay in each new cycle. 
It helps to save CPU time for other tasks.
What do you think about?

Thank you,
	Vasily Averin
