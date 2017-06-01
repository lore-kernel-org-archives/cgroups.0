From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 1 Jun 2017 16:38:15 -0400
Message-ID: <20170601203815.GA13390@htj.duckdns.org>
References: <20170519202624.GA15279@wtj.duckdns.org>
 <b1d02881-f522-8baa-5ebe-9b1ad74a03e4@redhat.com>
 <20170524203616.GO24798@htj.duckdns.org>
 <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
 <20170524212745.GP24798@htj.duckdns.org>
 <20170601145042.GA3494@htj.duckdns.org>
 <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
 <ffa991a3-074d-ffd5-7a6a-556d6cdd08fe@redhat.com>
 <20170601184740.GC3494@htj.duckdns.org>
 <ca834386-c41c-2797-702f-91516b06779f@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7TnVVYnjIyqRwxUKKNXqWmiv0YJsO27q88qfl6rQHQ4=;
        b=nU6PLJydAMh1MblhStJ3LwBkPM6Y1plDBLXEnhD4PC7mQVOjn3wk1wskX445K+tre0
         4BuUlzTOcb4Y6IYzk0JqLaR0DUn7XBVn3OboAHVVU1vUmdE+ORDZQddSMDbedql9oKwe
         zaYc73yOZOfzpkqDw4uq2M2edlx2BmecL0OgE5gMOvms2xnamJ0H+6axhMG2bUxQ5+Eg
         FBBbICXfIzpxlzUfeH34wxGxGqr2UoTCarMNbAfxA2egcBrFbGeFs4V9AAeUK0tYb9rr
         ixIlBh/GTPVqPKdFCDgmehv1Vj+p62mBzt9wz47Spzse1pRPjGHbxMk9G1Uih4OH4/sZ
         f6uQ==
Content-Disposition: inline
In-Reply-To: <ca834386-c41c-2797-702f-91516b06779f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org

Hello,

On Thu, Jun 01, 2017 at 03:27:35PM -0400, Waiman Long wrote:
> As said in an earlier email, I agreed that masking it on the kernel side
> may not be the best solution. I offer 2 other alternatives:
> 1) Document on how to work around the resource domains issue by proper
> setup of the cgroup hierarchy.

We can definitely improve documentation.

> 2) Mark those controllers that require the no internal process
> competition constraint and disallow internal process only when those
> controllers are active.

We *can* do that but wouldn't this be equivalent to enabling thread
mode implicitly when only thread aware controllers are enabled?

> I prefer the first alternative, but I can go with the second if necessary.
> 
> The major rationale behind my enhanced thread mode patch was to allow
> something like
> 
>      R -- A -- B
>      \
>       T1 -- T2
> 
> where you can have resource domain controllers enabled in the thread
> root as well as some child cgroups of the thread root. As no internal
> process rule is currently not applicable to the thread root, this
> creates the dilemma that we need to deal with internal process competition.
> 
> The container invariant that PeterZ talked about will also be a serious
> issue here as I don't think we are going to set up a container root
> cgroup that will have no process allowed in it because it has some child
> cgroups. IMHO, I don't think cgroup v2 will get wide adoption without
> getting rid of that no internal process constraint.

The only thing which is necessary from inside a container is putting
the management processes into their own cgroups so that they can be
controlled (ie. the same thing you did with your patch but doing that
explicitly from userland) and userland management sw can do the same
thing whether it's inside a container or on a bare system.  BTW,
systemd already does so and works completely fine in terms of
containerization on cgroup2.  It is arguable whether we should make
this more convenient from kernel side but using cgroup2 for resource
control already requires the userspace tools to be adapted to it, so
I'm not sure how much benefit we'd gain from adding that compared to
explicitly documenting it.

Thanks.

-- 
tejun
