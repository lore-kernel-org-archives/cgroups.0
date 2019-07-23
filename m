From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 2/8] sched/core: Streamlining calls to task_rq_unlock()
Date: Tue, 23 Jul 2019 06:11:00 -0700
Message-ID: <20190723131100.GE696309@devbig004.ftw2.facebook.com>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-3-juri.lelli@redhat.com>
 <50f00347-ffb3-285c-5a7d-3a9c5f813950@arm.com>
 <20190722083214.GF25636@localhost.localdomain>
 <20190723103131.GB3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KoRrGXS1xcEHJmR9YK4+5JQrZ37H5yKayrFqWfL3n4M=;
        b=KD1ifaEV5p7WnRGC0HNJ+qVWuOXp5bFQDD3BHmiCOTrRHyJxCD1acj+NzS633mjANf
         qj3MMUwF3gw7MrilS8jAjZDuC1lJ0rupY9Z0lpp6AAi5ICwhVg3HpbMqIcbN61z+6b3M
         X0OSdx1umYaZLuzU5u1s8eFwEDV3W2DyznyRzNHTXOrY8eE/a+WgnDVgvAG85VKCFfp2
         TnaiRBneUcCsPFMM0Urvndy67GeHp58bOexgDUyWZQ21UogE8gRNPq45LjaV+HD8rylK
         9TU3/iAboTNbadUuAGZts7QADaQQse2f2jAdTDOFpmyBDF9OuVDyl5m8VdSzZmXl6nQg
         0izQ==
Content-Disposition: inline
In-Reply-To: <20190723103131.GB3402@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, longman@redhat.com, cgroups@vger.kernel.org

On Tue, Jul 23, 2019 at 12:31:31PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 22, 2019 at 10:32:14AM +0200, Juri Lelli wrote:
> 
> > Thanks for reporting. The set is based on cgroup/for-next (as of last
> > week), though. I can of course rebase on tip/sched/core or mainline if
> > needed.
> 
> TJ; I would like to take these patches through the scheduler tree if you
> don't mind. Afaict there's no real conflict vs cgroup/for-next (I
> applied the patches and then did a pull of cgroup/for-next which
> finished without complaints).

Yeah, for sure, please go ahead.

Thanks.

-- 
tejun
