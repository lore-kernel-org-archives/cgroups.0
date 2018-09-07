From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Fri, 7 Sep 2018 12:21:46 +0200
Message-ID: <20180907102146.GI24142@hirez.programming.kicks-ass.net>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180828172258.3185-9-hannes@cmpxchg.org>
 <20180907101634.GO24106@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Eq01cLMg5iKSpygwdgzLuH8ZJOgXQTo85H8k76w6kQE=; b=cO+ClPLjcCRKc9Vk5rAhcgKG5
        apmJAE4BZclQUraoT+/LshdygtxYfd7v68xRktCTMt5Q51zBa9FTLrtobQiJvZQE6IKMkING4KfRO
        hDVTIMT0daV0oTUzWvQwCy67rD35BcOS5rhOEuClnrOPCj04dsmy64sCXPWd+Uemsrd/brgGjU5sq
        1XOIhOXHBKbjIa0X4+Ke80qZ9AAL2J/mT5nT550p6dgWtfcpK5P+YOUq7zAslccDACWH5DJqAHUVs
        YBdhKSZJKeDLM3J0t8gWxnCCT08quaWfuiZBaw2/itFXSK9dmfbFCfGAu0qA+TPVI69vlMZii2EVN
      
Content-Disposition: inline
In-Reply-To: <20180907101634.GO24106@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Sep 07, 2018 at 12:16:34PM +0200, Peter Zijlstra wrote:
> This does the whole seqcount thing 6x, which is a bit of a waste.
> 
> struct snapshot {
> 	u32 times[NR_PSI_STATES];
> };
> 
> static inline struct snapshot get_times_snapshot(struct psi_group *pg, int cpu)
> {
> 	struct pci_group_cpu *pgc = per_cpu_ptr(pg->pcpu, cpu);
> 	struct snapshot s;
> 	unsigned int seq;
> 	u32 delta;
> 	int i;
> 
> 	do {
> 		seq = read_seqcount_begin(&pgc->seq);
> 
> 		delta = cpu_clock(cpu) - pgc->state_start;
> 		for (i = 0; i < NR_PSI_STATES; i++) {
> 			s.times[i] = gpc->times[i];
> 			if (test_state(pgc->tasks, i))
> 				s.times[i] += delta;
> 		}
> 
> 	} while (read_seqcount_retry(&pgc->seq, seq);

Sorry, I forgot the whole times_prev thing:

	for (i = 0; i < NR_PSI_STATES; i++) {
		tmp = s.times[i];
		s.times[i] -= pgc->times_prev[i];
		pgc->times_prev[i] = tmp;
	}

> 	return s;
> }
> 
> 
> 	for_each_possible_cpu(cpu) {
> 		struct snapshot s = get_times_snapshot(pg, cpu);
> 
> 		nonidle = nsecs_to_jiffies(s.times[PSI_NONIDLE]);
> 		nonidle_total += nonidle;
> 
> 		for (i = 0; i < PSI_NONIDLE; i++)
> 			deltas[s] += (u64)s.times[i] * nonidle;
> 
> 		/* ... */
> 
> 	}
> 
> 
> It's a bit cumbersome, but that's because of C.
