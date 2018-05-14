From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Mon, 14 May 2018 14:55:20 -0400
Message-ID: <20180514185520.GA7398@cmpxchg.org>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <010001635f4e8be9-94e7be7a-e75c-438c-bffb-5b56301c4c55-000000@email.amazonses.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eVYpmjqcSZBn4kAVO0jNYh3Jhm47wWqyq0luxDgSTjU=; b=zBJZOJtcA7Tqlr13PMNOADnYVw
        I9jymj6mOnTFq6oqZjvSUij7TaK7krj8bkMyezzwx7yhFovx5j5mtEHFhP7JTQUNvQQkxJwHWA0/R
        ArdJqr/xsRVT7hyQddGiCjAKEfHPx9P7w7kvvNkOiwVFWDJnlnOz0c4qWy58nHS0oOBA=;
Content-Disposition: inline
In-Reply-To: <010001635f4e8be9-94e7be7a-e75c-438c-bffb-5b56301c4c55-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon, May 14, 2018 at 03:39:33PM +0000, Christopher Lameter wrote:
> On Mon, 7 May 2018, Johannes Weiner wrote:
> 
> > What to make of this number? If CPU utilization is at 100% and CPU
> > pressure is 0, it means the system is perfectly utilized, with one
> > runnable thread per CPU and nobody waiting. At two or more runnable
> > tasks per CPU, the system is 100% overcommitted and the pressure
> > average will indicate as much. From a utilization perspective this is
> > a great state of course: no CPU cycles are being wasted, even when 50%
> > of the threads were to go idle (and most workloads do vary). From the
> > perspective of the individual job it's not great, however, and they
> > might do better with more resources. Depending on what your priority
> > is, an elevated "some" number may or may not require action.
> 
> This looks awfully similar to loadavg. Problem is that loadavg gets
> screwed up by tasks blocked waiting for I/O. Isnt there some way to fix
> loadavg instead?

Counting iowaiting tasks is one thing, but there are a few more things
that make it hard to use for telling the impact of CPU competition:

- It's not normalized to available CPU count. The loadavg in isolation
  doesn't mean anything, and you have to know the number of CPUs and
  any CPU bindings / restrictions in effect, which presents at least
  some difficulty when monitoring a big heterogeneous fleet.

- The way it's sampled makes it impossible to use for latencies. You
  could be mostly idle but periodically have herds of tasks competing
  for the CPU for short, low-latency operations. Even if we changed
  this in the implementation, you're still stuck with the interface
  that has...

- ...a short-term load window of 1m. This is generally fairly coarse
  for something that can be loaded and unloaded as abruptly as the CPU

I'm trying to fix these with a portable way of aggregating multi-cpu
states, as well as tracking the true time spent in a state instead of
sampling it. Plus a smaller short-term window of 10s, but that's
almost irrelevant because I'm exporting the absolute state time clock
so you can calculate your own averages over any time window you want.

Since I'm using the same model and infrastructure for memory and IO
load as well, IMO it makes more sense to present them in a coherent
interface instead of trying to retrofit and change the loadavg file,
which might not even be possible.
