From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Wed, 18 Jul 2018 18:00:06 -0400
Message-ID: <20180718220006.GC2838@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180717141614.GE2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4ker0quClZEgZ5kE8sfGIwDQw5tHDLXhMgyW7gYa9G0=;
        b=o9RGiv4y0vhHEG2inTBc8qIvGE+KizE7Db5zpOsll0EtQgVu+/dDkWiHq0Q9tuC1pj
         2/thP6va7TBIeHrgQQptHGESNnwaotgins3E3RxUI+zsXvp7kWIXi1fos7xzchs/iSoI
         GbYrlNAVKdvu8699D3yCX4g6kQ5uh2Ui2AyIQAgzRnSXv3fOM5vmcQEBoQGLVq0EnmGI
         VlUbYrHBGFtF5dPgRDgSO4oCivjJJiYFNWy5rlWSR4RSF8+sVSJotQK8Vf7iKwhxIsm1
         ZPA9tTbvzihNzcsH5o9X0vQSO1CKSvGKcZsPW20Kv1sVqllaRkNurDa3w0EZAyTpZ68h
         OsPw==
Content-Disposition: inline
In-Reply-To: <20180717141614.GE2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jul 17, 2018 at 04:16:14PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> > +/* Tracked task states */
> > +enum psi_task_count {
> > +	NR_RUNNING,
> > +	NR_IOWAIT,
> > +	NR_MEMSTALL,
> > +	NR_PSI_TASK_COUNTS,
> > +};
> 
> > +/* Resources that workloads could be stalled on */
> > +enum psi_res {
> > +	PSI_CPU,
> > +	PSI_MEM,
> > +	PSI_IO,
> > +	NR_PSI_RESOURCES,
> > +};
> 
> These two have mem and iowait in different order. It really doesn't
> matter, but my brain stumbled.

No problem, I swapped them around for v3.
