From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v9 2/8] sched/core: Streamlining calls to task_rq_unlock()
Date: Tue, 23 Jul 2019 16:58:18 +0200
Message-ID: <20190723145818.GI25636@localhost.localdomain>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-3-juri.lelli@redhat.com>
 <50f00347-ffb3-285c-5a7d-3a9c5f813950@arm.com>
 <20190722083214.GF25636@localhost.localdomain>
 <20190723103131.GB3402@hirez.programming.kicks-ass.net>
 <20190723131100.GE696309@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190723131100.GE696309@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, longman@redhat.com, cgroups@vger.kernel.org

On 23/07/19 06:11, Tejun Heo wrote:
> On Tue, Jul 23, 2019 at 12:31:31PM +0200, Peter Zijlstra wrote:
> > On Mon, Jul 22, 2019 at 10:32:14AM +0200, Juri Lelli wrote:
> > 
> > > Thanks for reporting. The set is based on cgroup/for-next (as of last
> > > week), though. I can of course rebase on tip/sched/core or mainline if
> > > needed.
> > 
> > TJ; I would like to take these patches through the scheduler tree if you
> > don't mind. Afaict there's no real conflict vs cgroup/for-next (I
> > applied the patches and then did a pull of cgroup/for-next which
> > finished without complaints).
> 
> Yeah, for sure, please go ahead.
> 
> Thanks.

Thanks!
