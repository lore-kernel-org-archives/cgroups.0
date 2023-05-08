From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v2 0/6] sched/deadline: cpuset: Rework DEADLINE bandwidth
 restoration
Date: Mon, 8 May 2023 10:02:46 +0200
Message-ID: <ZFispnba4DZt50Io@localhost.localdomain>
References: <20230503072228.115707-1-juri.lelli@redhat.com>
 <20230504062525.GF1734100@hirez.programming.kicks-ass.net>
 <ZFNqJf+BQ0GMdr+y@localhost.localdomain>
 <ZFVZdbdZTLGhqYp4@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683532976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+MFXAjFUnD3DQtiGulvH5viQWsTkaor8wEAJr5G/4CI=;
        b=itW82EutQJUnTDfP5ltBGXdaLWHhXC7491+wduQJ1XIQHTRINmW5LDisQu2ccnYth//jPT
        Uj7s3NxQ7mphFTw7xxLfTW+InYZyc7Ai0GMsi4a2LY4xwjZwhyvfPWwYYAH7b5RWDFxqHl
        PJQn7mEEM5e6M0hey15XtO2+H6QWu5g=
Content-Disposition: inline
In-Reply-To: <ZFVZdbdZTLGhqYp4@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Qais Yousef <qyousef@layalina.io>, Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agor>

Hi,

On 05/05/23 09:31, Tejun Heo wrote:
> On Thu, May 04, 2023 at 10:17:41AM +0200, Juri Lelli wrote:
> > On 04/05/23 08:25, Peter Zijlstra wrote:
> > > On Wed, May 03, 2023 at 09:22:22AM +0200, Juri Lelli wrote:
> > > 
> > > > Dietmar Eggemann (2):
> > > >   sched/deadline: Create DL BW alloc, free & check overflow interface
> > > >   cgroup/cpuset: Free DL BW in case can_attach() fails
> > > > 
> > > > Juri Lelli (4):
> > > >   cgroup/cpuset: Rename functions dealing with DEADLINE accounting
> > > >   sched/cpuset: Bring back cpuset_mutex
> > > >   sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets
> > > >   cgroup/cpuset: Iterate only if DEADLINE tasks are present
> > > > 
> > > >  include/linux/cpuset.h  |  12 +-
> > > >  include/linux/sched.h   |   4 +-
> > > >  kernel/cgroup/cgroup.c  |   4 +
> > > >  kernel/cgroup/cpuset.c  | 242 ++++++++++++++++++++++++++--------------
> > > >  kernel/sched/core.c     |  41 +++----
> > > >  kernel/sched/deadline.c |  67 ++++++++---
> > > >  kernel/sched/sched.h    |   2 +-
> > > >  7 files changed, 244 insertions(+), 128 deletions(-)
> > > 
> > > Aside from a few niggles, these look fine to me. Who were you expecting
> > > to merge these, tj or me?
> > 
> > Thanks for reviewing!
> > 
> > Not entirely sure, it's kind of split, but maybe the cgroup changes are
> > predominant (cpuset_mutex is probably contributing the most). So, maybe
> > tj? Assuming this looks good to him as well of course. :)
> 
> Yeah, they all look sane to me and both Waiman and Peter seem okay with
> them. If you post an updated version with the minor suggestions applied,
> I'll route the series through the cgroup tree.

Thanks for reviewing and eventually taking care of the series. v3 just
posted (20230508075854.17215-1-juri.lelli@redhat.com).

Best,
Juri

