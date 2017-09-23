From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Sat, 23 Sep 2017 01:16:30 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709230111250.116512@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com> <20170921142107.GA20109@cmpxchg.org> <alpine.DEB.2.10.1709211357520.60945@chino.kir.corp.google.com> <20170922154426.GF828415@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1709221316290.68140@chino.kir.corp.google.com> <20170922210519.GH828415@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=6zuN8WSbvbC0cfVZBt/JYOmN6NL7gqUyw9K/DZkORso=;
        b=pgk6aUKKEa09E56jpUDCCRMGbMg8rgirExMruGrIEu8cNGamOqoMPzLB1H5qxT8CZU
         oJATHYPb/ktE+UYaU1rqKvoWYdN2CIw8FIVUxpF4fERjDOjV9JvRvfwyVzv68gj3F90m
         Bts7P8tTQlhOUL3aFxlub/Oka5j4RYxz1D+yORCpCdJRwzvi8MWHqFSZ3JVo3pSE2WKt
         xWozLsYmHXw7XBYYhQo2W+7d0YEw1L4iZx9HYOyxBgwOYmuwJ+InEWtdtNlclo3bgGSv
         yXK83s+tnKIIB8fHor2o+KdOBsWmwb4qs7O6FIfwu/zcOW7/cJxWVkqEFVH6ZOD8Jzcn
         9SHg==
In-Reply-To: <20170922210519.GH828415@devbig577.frc2.facebook.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 22 Sep 2017, Tejun Heo wrote:

> > If you have this low priority maintenance job charging memory to the high 
> > priority hierarchy, you're already misconfigured unless you adjust 
> > /proc/pid/oom_score_adj because it will oom kill any larger process than 
> > itself in today's kernels anyway.
> > 
> > A better configuration would be attach this hypothetical low priority 
> > maintenance job to its own sibling cgroup with its own memory limit to 
> > avoid exactly that problem: it going berserk and charging too much memory 
> > to the high priority container that results in one of its processes 
> > getting oom killed.
> 
> And how do you guarantee that across delegation boundaries?  The
> points you raise on why the priority should be applied level-by-level
> are exactly the same points why this doesn't really work.  OOM killing
> priority isn't something which can be distributed across cgroup
> hierarchy level-by-level.  The resulting decision tree doesn't make
> any sense.
> 

It works very well in practice with real world usecases, and Roman has 
developed the same design independently that we have used for the past 
four years.  Saying it doesn't make any sense doesn't hold a lot of weight 
when we both independently designed and implemented the same solution to 
address our usecases.

> I'm not against adding something which works but strict level-by-level
> comparison isn't the solution.
> 

Each of the eight versions of Roman's cgroup aware oom killer has done 
comparisons between siblings at each level.  Userspace influence on that 
comparison would thus also need to be done at each level.  It's a very 
powerful combination in practice.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
