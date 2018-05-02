From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH v7 2/5] cpuset: Add cpuset.sched_load_balance to v2
Date: Wed, 02 May 2018 16:35:02 +0200
Message-ID: <1525271702.4975.3.camel@gmx.de>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
         <1524145624-23655-3-git-send-email-longman@redhat.com>
         <20180502102416.GJ12180@hirez.programming.kicks-ass.net>
         <14d7604c-1254-1146-e2b6-23f4cc020b34@redhat.com>
         <20180502134225.GR12217@hirez.programming.kicks-ass.net>
         <94c80e1c-049d-6ec3-8e8c-40eb88d1341d@redhat.com>
         <20180502140226.GU12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502140226.GU12217@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On Wed, 2018-05-02 at 16:02 +0200, Peter Zijlstra wrote:
> On Wed, May 02, 2018 at 09:47:00AM -0400, Waiman Long wrote:
> 
> > > I've read half of the next patch that adds the isolation thing. And
> > > while that kludges around the whole root cgorup is magic thing, it
> > > doesn't help if you move the above scenario on level down:
> > >
> > >
> > > 	R
> > >      /    \
> > >    A        B
> > >           /   \
> > >         C       D
> > >
> > >
> > > R: cpus=0-7, load_balance=0
> > > A: cpus=0-1, load_balance=1
> > > B: cpus=2-7, load_balance=0
> > > C: cpus=2-3, load_balance=1
> > > D: cpus=4-7, load_balance=1
> > >
> > >
> > > Also, I feel we should strive to have a minimal amount of tasks that
> > > cannot be moved out of the root group; the current set is far too large.
> > 
> > What exactly is the use case you have in mind with loading balancing
> > disabled in B, but enabled in C and D? We would like to support some
> > sensible use cases, but not every possible combinations.
> 
> Suppose A is your system group, and C and D are individual RT workloads
> or something.

Yeah, it does have a distinct "640K ought to be enough for anybody"
flavor to it.

	-Mike
