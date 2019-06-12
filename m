From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RESEND PATCH v3] cpuset: restore sanity to
 cpuset_cpus_allowed_fallback()
Date: Wed, 12 Jun 2019 19:39:31 +0200
Message-ID: <20190612173930.GL3402@hirez.programming.kicks-ass.net>
References: <1560354648-23632-1-git-send-email-jsavitz@redhat.com>
 <20190612160244.GP3341036@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=s/cPizosD0yo9hCc0bnbtGXeZtAcZupgNDhvNsY19l8=; b=WwCSS6HPwhqRa8GP/pqPBaFzP
        GrvimiXjmrb2Lac/YuJURT5NEkTZ03tllxmZf4raxtLhj8xRzZpA1nyAi20YMkh9UtzIOSXqUwbaD
        0BR7cC+o/zli58tv/fpRUXm2OVrbUwH/FYsmRNVzEpFcvERHHW2fDKvlb4bDkK0wlj0y0NUsd2qVZ
        3JysHIJo4FFUfwPT8LTOXD+nG0luamwCYvjGn/kNL2+UTt0EWdKWBa4wSQAWIfqjKIpjtwNr2Lh14
        88uqNEqXa1LNnW3eOP8p1dtHsQPLQ6Z3uJitSTklS2//XqtOvvjlDNUBvXXktfJT1Emo53PWq2got
Content-Disposition: inline
In-Reply-To: <20190612160244.GP3341036@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Joel Savitz <jsavitz@redhat.com>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org

On Wed, Jun 12, 2019 at 09:02:44AM -0700, Tejun Heo wrote:
> On Wed, Jun 12, 2019 at 11:50:48AM -0400, Joel Savitz wrote:
> > In the case that a process is constrained by taskset(1) (i.e.
> > sched_setaffinity(2)) to a subset of available cpus, and all of those are
> > subsequently offlined, the scheduler will set tsk->cpus_allowed to
> > the current value of task_cs(tsk)->effective_cpus.
> > 
> > This is done via a call to do_set_cpus_allowed() in the context of 
> > cpuset_cpus_allowed_fallback() made by the scheduler when this case is
> > detected. This is the only call made to cpuset_cpus_allowed_fallback()
> > in the latest mainline kernel.
> > 
> > However, this is not sane behavior.
> 
> While not perfect (we'll need to stop updating task's cpumask from
> cpuset to make), this is still a signifcant improvement.
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 
> If there's no objection, I'll route it through the cgroup tree.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
