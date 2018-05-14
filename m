From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Mon, 14 May 2018 10:33:53 +0200
Message-ID: <20180514083353.GN12217@hirez.programming.kicks-ass.net>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
 <20180509104618.GP12217@hirez.programming.kicks-ass.net>
 <20180509113849.GJ12235@hirez.programming.kicks-ass.net>
 <20180510134132.GA19348@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uxSr9G2yLzyaKMD8TB9JquJDsNTRajF0bUGML9eDoJA=; b=qI3Dg6aA638jPjR24weNa7guI
        GH+YWazsw03Rg4d1B2AP1EcutQPrE0BQqeFGUxHzUVMjRvlzaFlqfjwgUnEVBQv0h7/G6e0gtknxi
        Yd4EzN6g0YE+bvZPhpP+La6b0acjHyOWs8dJWo1uRX6iVCa1jSjhDjAJuRIZmOa/6TvLL/eXnqmgY
        7wQUf4e0T6beDh3QQHaFXGvRdu7l3jR8Y48xtki9FHQDZBaT9JAvCVjiQVP4+qgCh7idnTEB4yjIt
        P1F309bE2Pu10fL40Ob4ZSFG1bYB9tydiR3Ex7UuFRJpiKfsvKN02T/NBbAKkxCsMDQ7Rdj5cH/hk
    
Content-Disposition: inline
In-Reply-To: <20180510134132.GA19348@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Thu, May 10, 2018 at 09:41:32AM -0400, Johannes Weiner wrote:
> So there is a reason I'm tracking productivity states per-cpu and not
> globally. Consider the following example periods on two CPUs:
> 
>     CPU 0
> Task 1: | EXECUTING  | memstalled |
> Task 2: | runqueued  | EXECUTING  |
> 
>     CPU 1
> Task 3: | memstalled | EXECUTING  |
> 
> If we tracked only the global number of stalled tasks, similarly to
> nr_uninterruptible, the number would be elevated throughout the whole
> sampling period, giving a pressure value of 100% for "some stalled".
> And, since there is always something executing, a "full stall" of 0%.

But if you read the comment about SMP IO-wait; see commit:

  e33a9bba85a8 ("sched/core: move IO scheduling accounting from io_schedule_timeout() into scheduler")

you'll see that per-cpu accounting has issues too.

Also, note that in your example above you have 1 memstalled task (at any
one time), but _2_ CPUs. So at most you should end up with a 50% value.
There is no way 1 task could consume 2 CPUs worth of time.

Furthermore, associating a blocked task to any particular CPU is
fundamentally broken and I'll hard NAK anything that relies on it.

> Now consider what happens when the Task 3 sequence is the other way
> around:
> 
>     CPU 0
> Task 1: | EXECUTING  | memstalled |
> Task 2: | runqueued  | EXECUTING  |
> 
>     CPU 1
> Task 3: | EXECUTING  | memstalled |
> 
> Here the number of stalled tasks is elevated only during half of the
> sampling period, this time giving a pressure reading of 50% for "some"
> (and again 0% for "full").

That entirely depends on your averaging; an exponentially decaying
average would not typically result in 50% for the above case. But I
think we can agree that this results in one 0% and one 100% sample -- we
have two stalled tasks and two CPUs.

> That's a different measurement, but in terms of workload progress, the
> sequences are functionally equivalent. In both scenarios the same
> amount of productive CPU cycles is spent advancing tasks 1, 2 and 3,
> and the same amount of potentially productive CPU time is lost due to
> the contention of memory. We really ought to read the same pressure.

And you do -- subject to the averaging used, as per the above.

The first gives two 50% samples, the second gives 0%, 100%.

> So what I'm doing is calculating the productivity loss on each CPU in
> a sampling period as if they were independent time slices. It doesn't
> matter how you slice and dice the sequences within each one - if used
> CPU time and lost CPU time have the same proportion, we have the same
> pressure.

I'm still thinking you can do basically the same without the stong CPU
relation.

> To illustrate:
> 
>     CPU X
>         1            2            3            4
> Task 1: | EXECUTING  | memstalled | sleeping   | sleeping   |
> Task 2: | runqueued  | EXECUTING  | sleeping   | sleeping   |
> Task 3: | sleeping   | sleeping   | EXECUTING  | memstalled |
> 
> You can clearly see the 50% of walltime in which *somebody* isn't
> advancing (2 and 4), and the 25% of walltime in which *no* tasks are
> (3). Same amount of work, same memory stalls, same pressure numbers.
> 
> Globalized state tracking would produce those numbers on the single
> CPU (obviously), but once concurrency gets into the mix, it's
> questionable what its results mean. It certainly isn't able to
> reliably detect equivalent slowdowns of individual tasks ("some" is
> all over the place), and in this example wasn't able to capture the
> impact of contention on overall work completion ("full" is 0%).
> 
> * CPU 0: some = 50%, full =  0%
>   CPU 1: some = 50%, full = 50%
>     avg: some = 50%, full = 25%

I'm not entirely sure I get your point here; but note that a task
doesn't sleep on a CPU. When it sleeps it is not strictly associated
with a CPU, only when it runs does it have an association.

What is the value of accounting a sleep state to a particular CPU if the
task when wakes up on another? Where did the sleep take place?

All we really can say is that a task slept, and if we can reduce the
reason for its sleeping (IO, reclaim, whatever) then it could've ran
sooner. And then you can make predictions based on the number of CPUs
and global idle time, how much that could improve things.

