From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v8 8/8] rcu/tree: Setschedule gp ktread to SCHED_FIFO
 outside of atomic region
Date: Tue, 2 Jul 2019 09:01:28 +0200
Message-ID: <20190702070128.GG26005@localhost.localdomain>
References: <20190628080618.522-1-juri.lelli@redhat.com>
 <20190628080618.522-9-juri.lelli@redhat.com>
 <20190701191308.GE3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190701191308.GE3402@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 01/07/19 21:13, Peter Zijlstra wrote:
> On Fri, Jun 28, 2019 at 10:06:18AM +0200, Juri Lelli wrote:
> > sched_setscheduler() needs to acquire cpuset_rwsem, but it is currently
> > called from an invalid (atomic) context by rcu_spawn_gp_kthread().
> > 
> > Fix that by simply moving sched_setscheduler_nocheck() call outside of
> > the atomic region, as it doesn't actually require to be guarded by
> > rcu_node lock.
> 
> Maybe move this earlier in the series such that the bug doesn't manifest
> in bisection?

OK.
