From: Tejun Heo <tj@kernel.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Fri, 22 Sep 2017 14:05:19 -0700
Message-ID: <20170922210519.GH828415@devbig577.frc2.facebook.com>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170921142107.GA20109@cmpxchg.org>
 <alpine.DEB.2.10.1709211357520.60945@chino.kir.corp.google.com>
 <20170922154426.GF828415@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1709221316290.68140@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tYSrMtZ8Ranw5fqDKEIucEAZV2FACOC4ojOXA6LwP/Q=;
        b=TjjgN2MstQHFEq8UP66n92b5FkI4b/TDzrfaKM4kC6ATqeYkNWNZVLZXOrW8uTHUiO
         Liy6/8XkpduKlIHiXX8KeRVanrdQPpn5I4ebzgB2zHdRA9dSvfYyWSv9OvatlLzgdbVs
         K+llhK/4WdORjDs6zoM5p5io8+bGuPwaJscCauIVRsJhhtXqMuXfQQ3/esQU/S2Lbp5W
         JrhgRzND1e9FVGipe9d6f77hcVf66EJhgEeLc5xSbmOstyoM15G6p3w5/CAF5mPNKYCl
         K6JJ/b9fS2mj+6zphrs8Pqrzs727RcFXGEby+5Flf83TbERe9h0DYWGedkIQ3cdY5ivK
         zhDw==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1709221316290.68140@chino.kir.corp.google.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 22, 2017 at 01:39:55PM -0700, David Rientjes wrote:
> Current heuristic based on processes is coupled with per-process
> /proc/pid/oom_score_adj.  The proposed 
> heuristic has no ability to be influenced by userspace, and it needs one.  
> The proposed heuristic based on memory cgroups coupled with Roman's 
> per-memcg memory.oom_priority is appropriate and needed.  It is not 

So, this is where we disagree.  I don't think it's a good design.

> "sophisticated intelligence," it merely allows userspace to protect vital 
> memory cgroups when opting into the new features (cgroups compared based 
> on size and memory.oom_group) that we very much want.

which can't achieve that goal very well for wide variety of users.

> > We even change the whole scheduling behaviors and try really hard to
> > not get locked into specific implementation details which exclude
> > future improvements.  Guaranteeing OOM killing selection would be
> > crazy.  Why would we prevent ourselves from doing things better in the
> > future?  We aren't talking about the semantics of read(2) here.  This
> > is a kernel emergency mechanism to avoid deadlock at the last moment.
> 
> We merely want to prefer other memory cgroups are oom killed on system oom 
> conditions before important ones, regardless if the important one is using 
> more memory than the others because of the new heuristic this patchset 
> introduces.  This is exactly the same as /proc/pid/oom_score_adj for the 
> current heuristic.

You were arguing that we should lock into a specific heuristics and
guarantee the same behavior.  We shouldn't.

When we introduce a user visible interface, we're making a lot of
promises.  My point is that we need to be really careful when making
those promises.

> If you have this low priority maintenance job charging memory to the high 
> priority hierarchy, you're already misconfigured unless you adjust 
> /proc/pid/oom_score_adj because it will oom kill any larger process than 
> itself in today's kernels anyway.
> 
> A better configuration would be attach this hypothetical low priority 
> maintenance job to its own sibling cgroup with its own memory limit to 
> avoid exactly that problem: it going berserk and charging too much memory 
> to the high priority container that results in one of its processes 
> getting oom killed.

And how do you guarantee that across delegation boundaries?  The
points you raise on why the priority should be applied level-by-level
are exactly the same points why this doesn't really work.  OOM killing
priority isn't something which can be distributed across cgroup
hierarchy level-by-level.  The resulting decision tree doesn't make
any sense.

I'm not against adding something which works but strict level-by-level
comparison isn't the solution.

Thanks.

-- 
tejun
