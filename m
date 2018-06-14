From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v4 4/5] sched/core: Prevent race condition between cpuset
 and __sched_setscheduler()
Date: Thu, 14 Jun 2018 15:51:19 +0200
Message-ID: <20180614135119.GF12032@localhost.localdomain>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
 <20180613121711.5018-5-juri.lelli@redhat.com>
 <20180614094518.00a181cf@gandalf.local.home>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614094518.00a181cf@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 14/06/18 09:45, Steven Rostedt wrote:
> On Wed, 13 Jun 2018 14:17:10 +0200
> Ju
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index b42037e6e81d..d26fd4795aa3 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -2409,6 +2409,22 @@ void __init cpuset_init_smp(void)
> >  	BUG_ON(!cpuset_migrate_mm_wq);
> >  }
> >  
> > +/**
> > + * cpuset_lock - Grab the cpuset_mutex from another subsysytem
> > + */
> > +int cpuset_lock(void)
> 
> Shouldn't this be called "cpuset_trylock()" otherwise one may think
> that it will always return with the cpuset_mutex locked.

Sure.

Thanks,

- Juri
