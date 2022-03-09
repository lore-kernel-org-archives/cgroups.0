From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 0/4] Introduce group balancer
Date: Wed, 9 Mar 2022 08:00:54 -1000
Message-ID: <YijrVmzG8/yT9a0f@slm.duckdns.org>
References: <20220308092629.40431-1-dtcccc@linux.alibaba.com>
 <YieOvaqJeEW2lta/@slm.duckdns.org>
 <defa02c1-9660-f335-a764-d89dbe2f502e@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZwDlrDADymvuEvHXEeAaoGU1H0sTeVDarhXCy/fUKn8=;
        b=IsL8LuurpdDpc0AEUobmmiq89FZUOGuAFYA8VyBDP2OUqbxgJ2B0YxLzuItup4B017
         DKmjObLAh3EyyNNvbJxuzTG9SaerxZQ9rClPzKCwe/En/+7SuQ7tSd/W1F/Fnxbsn47O
         tuAP36lsbfl9uz7ukzXnOa2w2FRIcTU+UPZZ7DhgX2VwyoRjNeeJhSzqMq2z5FneAco7
         EauVlyWMy1iZCN+AOFEuElRK+yY9h2lIuu6EOmSLaJNgLvq7fZZsBwDujdLOwTUa/spN
         HylYD6x3a2IV/6BndyQbgUjFjzFjwGgRmP4xPtSt+B/quHQvEwzXw5vQYEsL3aO34Cst
         HSrQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <defa02c1-9660-f335-a764-d89dbe2f502e-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michael Wang <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Cruz Zhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Masahiro Yamada <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <ar>

Hello,

On Wed, Mar 09, 2022 at 04:30:51PM +0800, Tianchen Ding wrote:
> "the sched domains and the load balancer" you mentioned are the ways to
> "balance" tasks on each domains. However, this patchset aims to "group" them
> together to win hot cache and less competition, which is different from load
> balancer. See commit log of the patch 3/4 and this link:
> https://lore.kernel.org/all/11d4c86a-40ef-6ce5-6d08-e9d0bc9b512a-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org/

I read that but it doesn't make whole lot of sense to me. As Peter noted, we
already have issues with cross NUMA node balancing interacting with in-node
balancing, which likely indicates that it needs more unified solution rather
than more fragmented. I have a hard time seeing how adding yet another layer
on top helps the situation.

> > * If, for some reason, you need more customizable behavior in terms of cpu
> >    allocation, which is what cpuset is for, maybe it'd be better to build the
> >    load balancer in userspace. That'd fit way better with how cgroup is used
> >    in general and with threaded cgroups, it should fit nicely with everything
> >    else.
> > 
> 
> We put group balancer in kernel space because this new policy does not
> depend on userspace apps. It's a "general" feature.

Well, it's general for use cases which are happy with the two knobs that you
defined for your use case.

> Doing "dynamic cpuset" in userspace may also introduce performance issue,
> since it may need to bind and unbind different cpusets for several times,
> and is too strict(compared with our "soft bind").

My bet is that you're gonna be able to get just about the same bench results
with userspace diddling with thread cgroup membership. Why not try that
first? The interface is already there. I have a hard time seeing the
justification for hard coding this into the kernel at this stage.

Thanks.

-- 
tejun
