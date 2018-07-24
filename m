From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Tue, 24 Jul 2018 11:15:19 -0400
Message-ID: <20180724151519.GA11598@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <CAKTCnzmt_CnfZMMdK9_-rBrL4kUmoE70nVbnE58CJp++FP0CCQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=25p+jS6o/YSjFhg21X4cZUNJeO7pDLhB002v7M4Ttrg=;
        b=2T9HVUty2FPpzSaRvkyytY7qYsf6KygIQql8HGohvCxCdtXaFvflzT198tHPS3a4O8
         UEygwfbFzrxLFPXRTZlk6MLEctMw4TbRwo1BkClVbcWPtEriD9S5ADY0s2OESKbqZjNE
         dsbKY1akpq5xJTWblND4TpUXcQq+OzL4PTwB/q7P2+1lbeBS+2UwdYuKOWj6gxzgrQ9i
         cSJKIHCQOVfYpxJdbAc486hY4oiRdNwR/gXJOrRbX5AKFrp3Lo+WnDl7EzDBUSQgDodm
         U/gLQSGEHdNL0quDAva9w1O/YWNqoeqejPsS0+Ct7tO4PZs4b1z4y9Zw6WgK/WtLds2R
         lsBA==
Content-Disposition: inline
In-Reply-To: <CAKTCnzmt_CnfZMMdK9_-rBrL4kUmoE70nVbnE58CJp++FP0CCQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balbir Singh <bsingharora@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, surenb@google.com, Vinayak Menon <vinmenon@codeaurora.org>, Christoph Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm <linux-mm@kvack.org>, cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com

Hi Balbir,

On Tue, Jul 24, 2018 at 07:14:02AM +1000, Balbir Singh wrote:
> Does the mechanism scale? I am a little concerned about how frequently
> this infrastructure is monitored/read/acted upon.

I expect most users to poll in the frequency ballpark of the running
averages (10s, 1m, 5m). Our OOMD defaults to 5s polling of the 10s
average; we collect the 1m average once per minute from our machines
and cgroups to log the system/workload health trends in our fleet.

Suren has been experimenting with adaptive polling down to the
millisecond range on Android.

> Why aren't existing mechanisms sufficient

Our existing stuff gives a lot of indication when something *may* be
an issue, like the rate of page reclaim, the number of refaults, the
average number of active processes, one task waiting on a resource.

But the real difference between an issue and a non-issue is how much
it affects your overall goal of making forward progress or reacting to
a request in time. And that's the only thing users really care
about. It doesn't matter whether my system is doing 2314 or 6723 page
refaults per minute, or scanned 8495 pages recently. I need to know
whether I'm losing 1% or 20% of my time on overcommitted memory.

Delayacct is time-based, so it's a step in the right direction, but it
doesn't aggregate tasks and CPUs into compound productivity states to
tell you if only parts of your workload are seeing delays (which is
often tolerable for the purpose of ensuring maximum HW utilization) or
your system overall is not making forward progress. That aggregation
isn't something you can do in userspace with polled delayacct data.

> -- why is the avg delay calculation in the kernel?

For one, as per above, most users will probably be using the standard
averaging windows, and we already have this highly optimizd
infrastructure from the load average. I don't see why we shouldn't use
that instead of exporting an obscure number that requires most users
to have an additional library or copy-paste the loadavg code.

I also mentioned the OOM killer as a likely in-kernel user of the
pressure percentages to protect from memory livelocks out of the box,
in which case we have to do this calculation in the kernel anyway.

> There is no talk about the overhead this introduces in general, may be
> the details are in the patches. I'll read through them

I sent an email on benchmarks and overhead in one of the subthreads, I
will include that information in the cover letter in v3.

https://lore.kernel.org/lkml/20180718215644.GB2838@cmpxchg.org/

Thanks!
