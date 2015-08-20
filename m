From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Thu, 20 Aug 2015 06:00:59 +0200
Message-ID: <1440043259.3515.84.camel@gmail.com>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
	 <1438641689-14655-4-git-send-email-tj@kernel.org>
	 <20150804090711.GL25159@twins.programming.kicks-ass.net>
	 <20150804151017.GD17598@mtj.duckdns.org>
	 <20150805091036.GT25159@twins.programming.kicks-ass.net>
	 <20150805143132.GK17598@mtj.duckdns.org>
	 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
	 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
	 <20150818203117.GC15739@mtj.duckdns.org>
	 <1439954620.3479.30.camel@gmail.com>
	 <20150819164113.GB20716@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=tfMfLHIUrpCqLeDXgGepDwqnFXZGpJPO3Uu6vJ1j+8M=;
        b=iFxqEa1bOpcz2Fr/XVYH4vZD1P5cTvr0NhHkyvuLJzONdo7G/3QkuM3DhoSk5FIJ+B
         SpalQPh6KylevZhtITZyZBI0h9SeTttOQLKNd7OHQ+BT4UNucDb2f+V/BjWxRUMHNIc4
         YD473wX3YC9Ob6u74oxiWHIwShIYRQsRo16ayIWIpiab8mZu9hsKK4yv5oyZyuFrYjFK
         q2FbkALcms7yK8p1FCOQKhETX42nxBN9vcWdM82TsWtB4SPguClSXxiABI6s6ku4hVrs
         Gv6pXwqpwMphRuKcAgcataRryq9qshzOnHFY3UMb/EZH3pgZzd+57wJgIwUXwY35FzXw
         eFrw==
In-Reply-To: <20150819164113.GB20716@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Wed, 2015-08-19 at 09:41 -0700, Tejun Heo wrote:

> Most problems can be solved in different ways and I'm doubtful that
> e.g. bouncing jobs to worker threads would be more expensive than
> migrating the worker back and forth in a lot of cases.  If migrating
> threads around floats somebody's boat, that's fine but that has never
> been and can't be the focus of design and optimization, not at the
> cost of the actual hot paths.

If create/attach/detach/destroy aren't hot paths, what is?  Those are
fork/exec/exit cgroup analogs.  If you have thousands upon thousands of
potentially active cgroups (aka customers), you wouldn't want to keep
them all around just in case when you can launch cgroup tasks the same
way we launch any other task.  You wouldn't contemplate slowing down
fork/exec/exit, but create/attach/detach/destroy are one and the same..
they need to be just as fast/light as they can be, as they are part and
parcel of the higher level process.

That's why my hack ended up in a large enterprise outfit's product, it
was _needed_ to fix up cgroups performance suckage.  That suckage was
fixed up properly quite a bit later.

Anyway, if what they or anybody like them can currently do with their
job launcher/manager gizmos is negatively impacted, they can gripe for
themselves.  All I'm saying is that there are definitely users out there
to whom create/attach/detach/destroy are highly important.

	-Mike
