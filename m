From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v7 4/7] sched/core: Prevent race condition between cpuset
 and __sched_setscheduler()
Date: Fri, 5 Apr 2019 14:53:15 +0200
Message-ID: <20190405125315.GC5453@localhost.localdomain>
References: <20190403084650.4414-1-juri.lelli@redhat.com>
 <20190403084650.4414-5-juri.lelli@redhat.com>
 <20190405123645.GT12232@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190405123645.GT12232@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

Hi,

On 05/04/19 14:36, Peter Zijlstra wrote:
> On Wed, Apr 03, 2019 at 10:46:47AM +0200, Juri Lelli wrote:
> > +static inline void cpuset_read_only_lock(unsigned long *flags)
> > +{
> > +	local_irq_save(*flags);
> > +	preempt_disable();
> > +}
> > +
> > +static inline void cpuset_read_only_unlock(unsigned long *flags)
> > +{
> > +	local_irq_restore(*flags);
> > +	preempt_enable();
> > +}
> 
> You can ditch the preempt stuff. IRQs disabled already very much implies
> !preemptible.

OK.

Thanks,

- Juri
