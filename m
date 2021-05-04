From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] psi: fix psi state corruption when schedule() races with
 cgroup move
Date: Tue, 4 May 2021 13:20:44 +0200
Message-ID: <YJEuDJS0e9qF6CGn@hirez.programming.kicks-ass.net>
References: <20210503174917.38579-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iBL4wdk0hhtcp9IJCKPORLOWrfs/6Ue7vXO+EKvQ+U4=; b=jRYVtQEvL1LjLX9sOdEIZ3Pg5v
        lQcWFUeGo26VBne1KPVPxMpUkCVBr0WUHqsfLlJmFYMs3cl3ShoRT/WNl8xN/RREl4d897cswWTcL
        YuPKl90SPVXTjl6i6HXCbCQ8KaOTAXWe0+Nl8HjnDk72i2T/n8LvaoAKERArZl++X46h0fNZpM+Nk
        nGdy7fNsNc1fQwOK+mJmbJHEKqyDP+DpxSXLCPwDk/bACv7Q8zuGyNa5dN0IwzsZvF5dK2QSwbCHw
        CfgE6uM5zjMF34lbAbUv9ET/hjVtatihzy0uPoSEqCEyWi3tDW4p2uO/mNuFXFOvKbiGhOB2c5rii
        mqlIUmXw==;
Content-Disposition: inline
In-Reply-To: <20210503174917.38579-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, May 03, 2021 at 01:49:17PM -0400, Johannes Weiner wrote:
> 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
> introduced a race condition that corrupts internal psi state. This
> manifests as kernel warnings, sometimes followed by bogusly high IO
> pressure:
> 
>   psi: task underflow! cpu=1 t=2 tasks=[0 0 0 0] clear=c set=0
>   (schedule() decreasing RUNNING and ONCPU, both of which are 0)
> 
>   psi: incosistent task state! task=2412744:systemd cpu=17 psi_flags=e clear=3 set=0
>   (cgroup_move_task() clearing MEMSTALL and IOWAIT, but task is MEMSTALL | RUNNING | ONCPU)
> 
> What the offending commit does is batch the two psi callbacks in
> schedule() to reduce the number of cgroup tree updates. When prev is
> deactivated and removed from the runqueue, nothing is done in psi at
> first; when the task switch completes, TSK_RUNNING and TSK_IOWAIT are
> updated along with TSK_ONCPU.
> 
> However, the deactivation and the task switch inside schedule() aren't
> atomic: pick_next_task() may drop the rq lock for load balancing. When
> this happens, cgroup_move_task() can run after the task has been
> physically dequeued, but the psi updates are still pending. Since it
> looks at the task's scheduler state, it doesn't move everything to the
> new cgroup that the task switch that follows is about to clear from
> it. cgroup_move_task() will leak the TSK_RUNNING count in the old
> cgroup, and psi_sched_switch() will underflow it in the new cgroup.
> 
> A similar thing can happen for iowait. TSK_IOWAIT is usually set when
> a p->in_iowait task is dequeued, but again this update is deferred to
> the switch. cgroup_move_task() can see an unqueued p->in_iowait task
> and move a non-existent TSK_IOWAIT. This results in the inconsistent
> task state warning, as well as a counter underflow that will result in
> permanent IO ghost pressure being reported.
> 
> Fix this bug by making cgroup_move_task() use task->psi_flags instead
> of looking at the potentially mismatching scheduler state.
> 
> [ We used the scheduler state historically in order to not rely on
>   task->psi_flags for anything but debugging. But that ship has sailed
>   anyway, and this is simpler and more robust.
> 
>   We previously already batched TSK_ONCPU clearing with the
>   TSK_RUNNING update inside the deactivation call from schedule(). But
>   that ordering was safe and didn't result in TSK_ONCPU corruption:
>   unlike most places in the scheduler, cgroup_move_task() only checked
>   task_current() and handled TSK_ONCPU if the task was still queued. ]
> 
> Fixes: 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks! queued for sched/urgent.
