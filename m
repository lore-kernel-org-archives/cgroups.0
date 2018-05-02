From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 2/5] cpuset: Add cpuset.sched_load_balance to v2
Date: Wed, 2 May 2018 16:02:26 +0200
Message-ID: <20180502140226.GU12217@hirez.programming.kicks-ass.net>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
 <1524145624-23655-3-git-send-email-longman@redhat.com>
 <20180502102416.GJ12180@hirez.programming.kicks-ass.net>
 <14d7604c-1254-1146-e2b6-23f4cc020b34@redhat.com>
 <20180502134225.GR12217@hirez.programming.kicks-ass.net>
 <94c80e1c-049d-6ec3-8e8c-40eb88d1341d@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LM41facvwdAdcWlT+sVCARHogY3zOl1hiq5UQKcJaCY=; b=cUS4bgA6zI0xj359Td6zTURD0
        148vvFKWkWWDVGNThKgtvKFotDDGf3kPvLbQOQLD2b5gOnVp5/xFAMpOfIMLtpntPVMvGmC1Cnum8
        3dr6dJWyp/59YdX4QH/Rkp03xkYB1BQpL9hkQmQ846OrJ8nk+Pmk+GbQ5djourDJGt7rH1jAsv9ds
        XiiinU54TfAAjZfoy1UY7Ndf4SGvsoSV09KPExVWsrr16JXuchICDadPZoPn76cj/bAW30C9YGZ/3
        zas1FUXOI7sjpct3zEPtmNL5xRf/NULdNnSzOsizTB50S5QvC+JnQXgsjKYEetFZVwf5/SmgdiIL8
      
Content-Disposition: inline
In-Reply-To: <94c80e1c-049d-6ec3-8e8c-40eb88d1341d@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On Wed, May 02, 2018 at 09:47:00AM -0400, Waiman Long wrote:

> > I've read half of the next patch that adds the isolation thing. And
> > while that kludges around the whole root cgorup is magic thing, it
> > doesn't help if you move the above scenario on level down:
> >
> >
> > 	R
> >      /    \
> >    A        B
> >           /   \
> >         C       D
> >
> >
> > R: cpus=0-7, load_balance=0
> > A: cpus=0-1, load_balance=1
> > B: cpus=2-7, load_balance=0
> > C: cpus=2-3, load_balance=1
> > D: cpus=4-7, load_balance=1
> >
> >
> > Also, I feel we should strive to have a minimal amount of tasks that
> > cannot be moved out of the root group; the current set is far too large.
> 
> What exactly is the use case you have in mind with loading balancing
> disabled in B, but enabled in C and D? We would like to support some
> sensible use cases, but not every possible combinations.

Suppose A is your system group, and C and D are individual RT workloads
or something.

Or suppose B has siblings and each group at that level is a delegate to
a particular user/container. And the user/container in B happens to need
2 partitioned VMs or whatever.

The idea is the same in all the examples, you want to allow
sub-partitions.
