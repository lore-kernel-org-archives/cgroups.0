From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Wed, 18 Jul 2018 18:03:10 -0400
Message-ID: <20180718220310.GD2838@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180717142157.GF2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R+3dIiRyHP1fioKsYuh/dXRSLNmOYtxcUdsY0xfFPLo=;
        b=amPbMbni5KHTRvpPS5NjL05oE2UvGrywukrjUnj2kEd1CfT5OTDljNtSSvCfP39OrS
         O4sbirpnCMUqYoU8wJY8VLnmXdSGyaUyaSMTTJcXwdAp2WHXplAv2sdsmocf7252eDnF
         SoWrKGLI7Q0ru8aGPL06iXNRLMd8c3GtKvrKFvFMuMKY8JYWog6UDSEW/juvJ+8PP6Jr
         9e0TxBrVWZQtgcQ/853DK51pdsVde684uEXBSt6GYuY+1cMcnLAMCukDPLbJk+26fqCd
         vretef6I9vYmh6e1wi09Ef6DufqmFzbg2MzYFIx90It9aMVasokYwyA2zP1WkHgmlYkT
         nCkA==
Content-Disposition: inline
In-Reply-To: <20180717142157.GF2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jul 17, 2018 at 04:21:57PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> > diff --git a/include/linux/sched/stat.h b/include/linux/sched/stat.h
> > index 04f1321d14c4..ac39435d1521 100644
> > --- a/include/linux/sched/stat.h
> > +++ b/include/linux/sched/stat.h
> > @@ -28,10 +28,14 @@ static inline int sched_info_on(void)
> >  	return 1;
> >  #elif defined(CONFIG_TASK_DELAY_ACCT)
> >  	extern int delayacct_on;
> > +	if (delayacct_on)
> > +		return 1;
> > +#elif defined(CONFIG_PSI)
> > +	extern int psi_disabled;
> > +	if (!psi_disabled)
> > +		return 1;
> >  #endif
> > +	return 0;
> >  }
> 
> Doesn't that want to be something like:
> 
> static inline bool sched_info_on(void)
> {
> #ifdef CONFIG_SCHEDSTAT
> 	return true;
> #else /* !SCHEDSTAT */
> #ifdef CONFIG_TASK_DELAY_ACCT
> 	extern int delayacct_on;
> 	if (delayacct_on)
> 		return true;
> #endif /* DELAYACCT */
> #ifdef CONFIG_PSI
> 	extern int psi_disabled;
> 	if (!psi_disabled)
> 		return true;
> #endif
> 	return false;
> #endif /* !SCHEDSTATE */
> }
> 
> Such that if you build a TASK_DELAY_ACCT && PSI kernel, and boot with
> nodelayacct, you still get sched_info_on().

You're right, that was a brainfart on my end. But as you point out in
the other email, the SCHED_INFO dependency is artificial, so I'll
rework this entire part.
