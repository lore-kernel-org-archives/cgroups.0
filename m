From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Thu, 19 Jul 2018 14:47:40 -0400
Message-ID: <20180719184740.GA26291@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180718120318.GC2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KT+qQrhkPOdj9KSwdKORNY3MjeHa+bwmY9V62UKACe4=;
        b=qSyLwTefz1F9TPIo0gk+DUZXG4yRjqXcQZsvLgEKB+sNMIr5swUVfQ7adGSohUr8vp
         KZmO+M123GTQ/EkbtgtPJB7lxuPiMt8t/5XzWrBi33+7gqvPtrAYf3tdQ718nSjj8WPD
         i51upaQ/EQYRix520UiB8CSUMwv+85YBF+D/k2rkuUM/+rj7Z06WDvrPe7H4aWiUYj+e
         NZ/xSqe0h+aPLr/52Fv3Cyq4nuTkVNqSglK/FBoPPMBUMlUT/myRJ2UN8cKsv9QJ6g1j
         nSE0jo4ufIALI3oF+iYhTht4YMH9tecf59oZlZu35arj4AmZZqkYwop1csWp+wjOz+e+
         ySoA==
Content-Disposition: inline
In-Reply-To: <20180718120318.GC2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Jul 18, 2018 at 02:03:18PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> > +	/* Update task counts according to the set/clear bitmasks */
> > +	for (to = 0; (bo = ffs(clear)); to += bo, clear >>= bo) {
> > +		int idx = to + (bo - 1);
> > +
> > +		if (tasks[idx] == 0 && !psi_bug) {
> > +			printk_deferred(KERN_ERR "psi: task underflow! cpu=%d idx=%d tasks=[%u %u %u] clear=%x set=%x\n",
> > +					cpu, idx, tasks[0], tasks[1], tasks[2],
> > +					clear, set);
> > +			psi_bug = 1;
> > +		}
> 
> 		WARN_ONCE(!tasks[idx], ...);

It's just open-coded because of the printk_deferred, since this is
inside the scheduler.

It actually used to be a straight-up WARN_ONCE() in older
versions. Recursive scheduling bugs are no fun to debug ;)
