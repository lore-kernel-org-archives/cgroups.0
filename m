From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v8 6/8] cgroup/cpuset: Change cpuset_rwsem and hotplug
 lock order
Date: Mon, 1 Jul 2019 08:52:33 +0200
Message-ID: <20190701065233.GA26005@localhost.localdomain>
References: <20190628080618.522-1-juri.lelli@redhat.com>
 <20190628080618.522-7-juri.lelli@redhat.com>
 <20190628130308.GU3419@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190628130308.GU3419@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Prateek Sood <prsood@codeaurora.org>

Hi,

On 28/06/19 15:03, Peter Zijlstra wrote:
> On Fri, Jun 28, 2019 at 10:06:16AM +0200, Juri Lelli wrote:
> > cpuset_rwsem is going to be acquired from sched_setscheduler() with a
> > following patch. There are however paths (e.g., spawn_ksoftirqd) in
> > which sched_scheduler() is eventually called while holding hotplug lock;
> > this creates a dependecy between hotplug lock (to be always acquired
> > first) and cpuset_rwsem (to be always acquired after hotplug lock).
> > 
> > Fix paths which currently take the two locks in the wrong order (after
> > a following patch is applied).
> > Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> 
> This all reminds me of this:
> 
>   https://lkml.kernel.org/r/1510755615-25906-1-git-send-email-prsood@codeaurora.org
> 
> Which sadly got reverted again. If we do this now (I've always been a
> proponent), then we can make that rebuild synchronous again, which
> should also help here IIRC.

Why was that reverted? Perf regression of some type?

Thanks,

Juri
