From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpuset: Enforce that a child's cpus must be a subset of
 the parent
Date: Wed, 6 Jun 2018 13:56:35 -0700
Message-ID: <20180606205635.GP1351649@devbig577.frc2.facebook.com>
References: <1527687991-1431-1-git-send-email-longman@redhat.com>
 <5B0F4F09.9050100@huawei.com>
 <5B0FAE72.1090204@huawei.com>
 <20180531082613.GF12180@hirez.programming.kicks-ass.net>
 <5B0FB58C.9030705@huawei.com>
 <4dc718bc-4bd5-4998-853b-9c6ba67b89a0@redhat.com>
 <20180531155807.GU1351649@devbig577.frc2.facebook.com>
 <20180531161645.GN12180@hirez.programming.kicks-ass.net>
 <20180531161942.GW1351649@devbig577.frc2.facebook.com>
 <20180531163826.GO12180@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oEq8RfKwJYuD+6COTlowiE5qVzPl8iEYjnmxgan8HMs=;
        b=bt3lmGMx2YHf5xMnHKL7hZivSOnPbNPPFFO1DnI5xOtjZqFQPJv2ha3VnWwu1Scew9
         Nn2vGjpB7GVKOMqtk/TtVaWCp9tSwh+QJVGcJreo479iM/lYEuDf6+Cw+L2FYDruia/A
         LjcXiSpTq05dTABV/IBBDYVoVKuaCMmK3vLwenjkGAl1bDj2WtpOiaVPvL25mUDggr/s
         A6h9FEnmVT9gQXeBkI/5OG1rdyUj8zsWZqKNOc8hoXjkEmKvtW0XraAoJM4IX3jmIRkr
         piT0IPuYP9FccblRJKKe+/QJVhL58zKtVO1odXG8dlOU6LeoT2BDJOE7WqKEw7OyCKZE
         60RA==
Content-Disposition: inline
In-Reply-To: <20180531163826.GO12180@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>, Zefan Li <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello, Peter.

Sorry about late reply.

On Thu, May 31, 2018 at 06:38:26PM +0200, Peter Zijlstra wrote:
> > Yeah, for cpuset, it's messier, but it isn't different from hotunplug
> > scenario, right?  I think the best we can do there is putting ancestor
> > operation on an equal footing as hotplug ops.
> 
> Right, but hotplug is exceedingly rare, while I get the impression you
> think it is perfectly fine to recind on your resource grants.

Well, yeah, for a trivial example, imagine dynamic workload management
where you wanna restrict what a side-loaded batch workload can do on
and off peak hours.  All other controllers can do that.  It'd be a
really odd design trade-off if we make that really clumsy for cpuset
especially given that we wouldn't be gaining any actual
functionalities.

Thanks.

-- 
tejun
