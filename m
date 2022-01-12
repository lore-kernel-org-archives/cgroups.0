From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Wed, 12 Jan 2022 12:06:04 +0100
Message-ID: <Yd62HBixfq6jn6jR@hirez.programming.kicks-ass.net>
References: <20220111071212.1210124-1-surenb@google.com>
 <Yd3RClhoz24rrU04@sol.localdomain>
 <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nv9oEebndkSiqv8pTcj7NImvDdA6KxSCBwjzUgND6Ac=; b=taEKJ6bDdHze7bETZnYl9/7wDa
        i1PB5dTa9T6SL6KmLnXcEdUBEYRvwYZrthrA3g0T1QrqulikClYv9M9HvbNDcUVJb2H7n7NdLliLW
        IjvOI145W5idiyDI878zCLuASw1nGZxjQgo3mBCuEYVAOyyT3v4NjAfBpVvre+S50zbLfIN+ncqLF
        EdYH9w6eiC1i03M8nm/At/P5M5zsSY6mqDCtZhyXCJ6G8EtJh7hiXfnaujw8dwc5bThZeAgfc8RhL
        bl2P43CB+lVqBXcekr+4SfEOyavXzuvyo6bi97AI529TiCHN3jeX+vfa5JU/RHAEW/P2OWsK8Zi94
        z5mbKIDA==;
Content-Disposition: inline
In-Reply-To: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, stable <stable@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, syzbot <syzb>

On Tue, Jan 11, 2022 at 11:11:32AM -0800, Linus Torvalds wrote:

> Of course, in practice, for pointers, the whole "dereference off a
> pointer" on the read side *does* imply a barrier in all relevant
> situations. So yes, a smp_store_release() -> READ_ONCE() does work in
> practice, although it's technically wrong (in particular, it's wrong
> on alpha, because of the completely broken memory ordering that alpha
> has that doesn't even honor data dependencies as read-side orderings)

On a tangent, that actually works, even on Alpha, see commit
d646285885154 ("alpha: Override READ_ONCE() with barriered
implementation").
