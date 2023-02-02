From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Thu, 2 Feb 2023 10:48:45 -1000
Message-ID: <Y9whrU4IUeleqdrt@slm.duckdns.org>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9t1sP/6nFht7RSN@hirez.programming.kicks-ass.net>
 <d630ca53-71f0-c735-fbc3-e826479aa86b@redhat.com>
 <Y9wSC1Wxlm8CKKlN@hirez.programming.kicks-ass.net>
 <2bc730db-704d-080b-6869-02f6d0035fad@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9T0aTLZbkN8XqrJT/9QUriZzH/uz3lyoG7H0b5y1+Us=;
        b=JqOSyKSx/Q04WMXyzVA64PFu7mjTc7g1areNDs9DvDPhAH1PrnblGFeHkNqjRvTblJ
         t4fgGhLvbUHsb22rIXKxlZbNYo6s4DBES9ED6XtqIrl7G7la7/uR3AwnBBiPR+5hVOhc
         8yr+yXcS+Z8Wz7xE6PQww6X8bb0Nkq9hO4iwAmPj3hHt0Gqc8ukdiF4tR21qkWALxW/n
         BCJdBQJ89sswDZto8VKi/MaVkWshYKrRwRWy4sX/VNekdN+1Gf4n10V1d9MeZBIjViPy
         PvgKGCYZ71/OP+JhYY+zZAf4t4HpT4u9ZYA18IWzsucztkrtgjzSN124vlc1oKDwnbXw
         gEpQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2bc730db-704d-080b-6869-02f6d0035fad-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 02, 2023 at 03:46:02PM -0500, Waiman Long wrote:
> > > I will work on a patchset to do that as a counter offer.
> > We will need a small and simple patch for /urgent, or I will need to
> > revert all your patches -- your call.
> > 
> > I also don't tihnk you fully appreciate the ramifications of
> > task_cpu_possible_mask(), cpuset currently gets that quite wrong.
> 
> OK, I don't realize the urgency of that. If it is that urgent, I will have
> no objection to get it in for now. We can improve it later on. So are you
> planning to get it into the current 6.2 rc or 6.3?
> 
> Tejun, are you OK with that as you are the cgroup maintainer?

Yeah, gotta fix the regression but is there currently a solution which fixes
the regression but doesn't further break other stuff?

Thanks.

-- 
tejun
