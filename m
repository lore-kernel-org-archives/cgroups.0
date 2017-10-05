From: David Rientjes <rientjes@google.com>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Thu, 5 Oct 2017 14:53:02 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710051446310.87457@chino.kir.corp.google.com>
References: <20171004154638.710-1-guro@fb.com> <20171004154638.710-4-guro@fb.com> <alpine.DEB.2.10.1710041322160.67374@chino.kir.corp.google.com> <20171004204153.GA2696@cmpxchg.org> <alpine.DEB.2.10.1710050123180.20389@chino.kir.corp.google.com>
 <20171005102716.GA4922@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=sp5tDRJDFkQjSfxYOCWOzLW5Faoxj+OWvRf0Qm6otR4=;
        b=iY7ybxjNVg5GZgtZkEV8HU88eT4pafoOlTnzCFEh7nS5Lu1Ci08Mai8qL4S249Us+8
         pSBv0R9HsV48e/nSBbOa/83nYoT4ACf8x6wRaiqwSrAf8w0j2atIMY8FwOJDyv4mF4Ob
         H8jvAtr6+PhkxRdfd9THPSitHSmsTcgeQHONukLqxfc7BJedHsAQXp3DgR81KsUs3JzW
         gUFBZAlfLtHz15Eyv4VemUZ8SbhZfCGHfYM2Dc3e5efcLmZSkdA/NSDEd4ZIVrvIMc3B
         9lJ3qHhG/7IXjUwNn3OcTkp6QAuJBmJvngIZg0SnJ7OjMKeM3YxIXZE0v4IR2EeXUy7a
         f+wA==
In-Reply-To: <20171005102716.GA4922@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 5 Oct 2017, Johannes Weiner wrote:

> > It is, because it can quite clearly be a DoSand was prevented with 
> > Roman's earlier design of iterating usage up the hierarchy and comparing 
> > siblings based on that criteria.  I know exactly why he chose that 
> > implementation detail early on, and it was to prevent cases such as this 
> > and to not let userspace hide from the oom killer.
> 
> This doesn't address how it's different from a single process
> following the same pattern right now.
> 

Are you referring to a single process being rewritten into N different 
subprocesses that do the same work as the single process but is separated 
in this manner to avoid having a large rss for any single process to avoid  
being oom killed?

This is solved by a cgroup-aware oom killer because these subprocesses 
should not be able to escape their own chargable entity.  It's exactly the 
usecase that Roman is addressing, correct?  My suggestion is to continue 
to iterate the usage up the hierarchy so that users can't easily defeat 
this by creating N subcontainers instead.

> > Let's resolve that global oom is a real condition and getting into that 
> > situation is not a userspace problem.  It's the result of overcommiting 
> > the system, and is used in the enterprise to address business goals.  If 
> > the above is true, and its up to memcg to prevent global oom in the first 
> > place, then this entire patchset is absolutely pointless.  Limit userspace 
> > to 95% of memory and when usage is approaching that limit, let userspace 
> > attached to the root memcg iterate the hierarchy itself and kill from the 
> > largest consumer.
> > 
> > This patchset exists because overcommit is real, exactly the same as 
> > overcommit within memcg hierarchies is real.  99% of the time we don't run 
> > into global oom because people aren't using their limits so it just works 
> > out.  1% of the time we run into global oom and we need a decision to made 
> > based for forward progress.  Using Michal's earlier example of admins and 
> > students, a student can easily use all of his limit and also, with v10 of 
> > this patchset, 99% of the time avoid being oom killed just by forking N 
> > processes over N cgroups.  It's going to oom kill an admin every single 
> > time.
> 
> We overcommit too, but our workloads organize themselves based on
> managing their resources, not based on evading the OOM killer. I'd
> wager that's true for many if not most users.
> 

No workloads are based on evading the oom killer, we are specifically 
trying to avoid that with oom priorities.  They have the power over 
increasing their own priority to be preferred to kill, but not decreasing 
their oom priority that was set by an activity manager.  This is exactly 
the same as how /proc/pid/oom_score_adj works.  With a cgroup-aware oom 
killer, which we'd love, nothing can possibly evade the oom killer if 
there are oom priorities.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
