From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Mon, 6 Aug 2018 18:03:29 +0200
Message-ID: <20180806160329.GP2494@hirez.programming.kicks-ass.net>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
 <20180803165641.GA2476@hirez.programming.kicks-ass.net>
 <20180806151928.GB9888@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8IaTbGiI2kBzPlXkTibDxExERHMd3REdT8BW2Nz2qnY=; b=bSkuTjxYN4NMHmlhw2dJhmPpJ
        P/0O5ZWufJug37n30eMX6zn9IQ0QpAMnZAkNcmK7ou43dU+XTgCRkMmrSLxP6K8g2QeSdU49zFQUk
        UKVCQQkrwn65ney/0EdNe2Jnp9GQB66ViYynnHVgRlOeS4wcg/b791Co6Qn7TbL5q8sJcAQTAGpKP
        qK6iCvfApWakeMjob3w18AAJ53W+BD+pkUu590MFo5HHgYEY4zeE3PDYCg9VX6qeP2R/r5aVuarbv
        nPOtSdbtiXpN80LRv/aCX3eAYocf/L9kvVddGLD3aVruUatVCx0nrIh8Rcf/LEUn+5bFekxQ4rWVI
    
Content-Disposition: inline
In-Reply-To: <20180806151928.GB9888@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Aug 06, 2018 at 11:19:28AM -0400, Johannes Weiner wrote:
> On Fri, Aug 03, 2018 at 06:56:41PM +0200, Peter Zijlstra wrote:
> > On Wed, Aug 01, 2018 at 11:19:57AM -0400, Johannes Weiner wrote:

> > > +		u32 uninitialized_var(nonidle);
> > 
> > urgh.. I can see why the compiler got confused. Dodgy :-)
> 
> :-) I think we can make this cleaner. Something like this (modulo the
> READ_ONCE/WRITE_ONCE you pointed out in the other email)?
> 

> @@ -244,60 +287,17 @@ static bool psi_update_stats(struct psi_group *group)
>  	 */
>  	for_each_online_cpu(cpu) {
>  		struct psi_group_cpu *groupc = per_cpu_ptr(group->pcpu, cpu);
> +		u32 nonidle;
> +
> +		nonidle = read_update_delta(groupc, PSI_NONIDLE, cpu);
> +		nonidle = nsecs_to_jiffies(nonidle);
> +		nonidle_total += nonidle;
> +
> +		for (s = 0; s < PSI_NONIDLE; s++) {
> +			u32 delta;
> +
> +			delta = read_update_delta(groupc, s, cpu);
> +			deltas[s] += (u64)delta * nonidle;
>  		}
>  	}

Yes, much clearer, thanks!
