From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Thu, 19 Jul 2018 22:31:15 +0200
Message-ID: <20180719203114.GL2494@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180718120318.GC2476@hirez.programming.kicks-ass.net>
 <20180719184740.GA26291@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0j69lDSxJE6g6prtT5F3TYNRStuPMqOk5KNLppvYte4=; b=SPrDf8e7cdkMnTrlxBDtLRzxu
        Y6ToCckFOtPgl4j/NlWqlIydKMm1yu3PjE/Ablc+SlyYMFzBxwvMtZIU7uawOwgUp4ySB/KcqwPpN
        /MeI1pxNuEKljrR89mTFCPYGsgEt5HzVypeInjSGZwyEINMXVCCx1narj+09X8/BZDRrDockerrhu
        Uzopnjgpn8nc18AjMk7k/jodFMVx4jtblDH/GZqGwahOpQacuxAh7ulxc2VJd4r6Jfi5sMAYU7Qdc
        9VT8HHAPW4ZBVz/vZ5MevhUEaT+N/s8pet8H3K+GkNyL8eANOojnr0vyC8TXijg0L7WeX54TnJlqv
    
Content-Disposition: inline
In-Reply-To: <20180719184740.GA26291@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 19, 2018 at 02:47:40PM -0400, Johannes Weiner wrote:
> On Wed, Jul 18, 2018 at 02:03:18PM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> > > +	/* Update task counts according to the set/clear bitmasks */
> > > +	for (to = 0; (bo = ffs(clear)); to += bo, clear >>= bo) {
> > > +		int idx = to + (bo - 1);
> > > +
> > > +		if (tasks[idx] == 0 && !psi_bug) {
> > > +			printk_deferred(KERN_ERR "psi: task underflow! cpu=%d idx=%d tasks=[%u %u %u] clear=%x set=%x\n",
> > > +					cpu, idx, tasks[0], tasks[1], tasks[2],
> > > +					clear, set);
> > > +			psi_bug = 1;
> > > +		}
> > 
> > 		WARN_ONCE(!tasks[idx], ...);
> 
> It's just open-coded because of the printk_deferred, since this is
> inside the scheduler.

Yeah, meh. There's ton of WARNs in the scheduler, WARNs should not
trigger anyway. But yeah printk is crap, which is why I don't use printk
anymore:

  https://lkml.kernel.org/r/20170928121823.430053219@infradead.org


