From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v8 7/8] sched/core: Prevent race condition between cpuset
 and __sched_setscheduler()
Date: Tue, 2 Jul 2019 09:01:12 +0200
Message-ID: <20190702070111.GF26005@localhost.localdomain>
References: <20190628080618.522-1-juri.lelli@redhat.com>
 <20190628080618.522-8-juri.lelli@redhat.com>
 <20190701191141.GD3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190701191141.GD3402@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 01/07/19 21:11, Peter Zijlstra wrote:
> On Fri, Jun 28, 2019 at 10:06:17AM +0200, Juri Lelli wrote:
> > No synchronisation mechanism exists between the cpuset subsystem and
> > calls to function __sched_setscheduler(). As such, it is possible that
> > new root domains are created on the cpuset side while a deadline
> > acceptance test is carried out in __sched_setscheduler(), leading to a
> > potential oversell of CPU bandwidth.
> > 
> > Grab cpuset_rwsem read lock from core scheduler, so to prevent
> > situations such as the one described above from happening.
> > 
> 
> ISTR there being a funny vs normalize_rt_tasks(); maybe mention that?

Yep. I'll add a comment about it.
