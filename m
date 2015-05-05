From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 21:00:57 +0200
Message-ID: <20150505190057.GR23123@twins.programming.kicks-ass.net>
References: <5546F80B.3070802@huawei.com>
 <1430716247.3129.44.camel@gmail.com>
 <1430717964.3129.62.camel@gmail.com>
 <554737AE.5040402@huawei.com>
 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
 <55483EF7.7070905@huawei.com>
 <20150505141049.GN21418@twins.programming.kicks-ass.net>
 <20150505141838.GR1971@htj.duckdns.org>
 <20150505151949.GQ21418@twins.programming.kicks-ass.net>
 <20150505163112.GU1971@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150505163112.GU1971@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, May 05, 2015 at 12:31:12PM -0400, Tejun Heo wrote:
> 
> What I don't want to happen is controllers failing migrations
> willy-nilly for random reasons leaving users baffled, which we've
> actually been doing unfortunately.  Maybe we need to deal with this
> fixed resource arbitration as a separate class and allow them to fail
> migration w/ -EBUSY.

Ah, _that_ was the problem.

Which is something created by this co-mounting of controllers.

You could of course store the ss-id of the failing operation in
task_struct and have a file reporting the name of the ss-id.

That way, there is a simple way to find out which controller failed the
migrate.
