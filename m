From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Wed, 18 Jul 2018 18:11:39 -0400
Message-ID: <20180718221139.GF2838@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180717151705.GH2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8FZn5tD2SDlpbmPv1h30BRNTXCLS4iiwX2enbFu/UTs=;
        b=QKc+oagRIRFxaoHWLeUiQvvuHMgci7IB6E2rZmik09n+2ysSUM7loPzfx3v+K3bb4S
         OzutDeSQtn+Ut+kp9nwPScKZUhrU9x6coXmcMU7SnxDDcdQzFNGXGHgSLHzAXWdc/2tl
         SaMWFgNf95alHxpuIW/f6lY8czF3HhaXGxiZm+Yewy2HF8RjCp/7HRAtycS31gl1I4Uk
         ZeYMWDUAdcwJhcO1rcr+jzCAOSVIMthgYN+8DrNhelW+L1tmZdxIwVFMyKXnx3Un9aAK
         BU1BDX3ZRVfPcZluxJFRq6fKZmOmNCtGe5ILgwOb5gL/6Z/E94qEiGlR9ejdFXncnOYx
         wKqQ==
Content-Disposition: inline
In-Reply-To: <20180717151705.GH2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jul 17, 2018 at 05:17:05PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> > @@ -457,6 +457,22 @@ config TASK_IO_ACCOUNTING
> >  
> >  	  Say N if unsure.
> >  
> > +config PSI
> > +	bool "Pressure stall information tracking"
> > +	select SCHED_INFO
> 
> What's the deal here? AFAICT it does not in fact use SCHED_INFO for
> _anything_. You just hooked into the sched_info_{en,de}queue() hooks,
> but you don't use any of the sched_info data.
> 
> So the dependency is an artificial one that should not exist.

You're right, it doesn't strictly depend on it. I'll split that out.
