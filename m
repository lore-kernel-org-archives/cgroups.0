From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Fri, 3 Aug 2018 19:15:38 +0200
Message-ID: <20180803171538.GD2494@hirez.programming.kicks-ass.net>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9SKvL5mBhDInQR64JgTNiYmIMyZrEVQ4JX0o0ob6sKE=; b=XDNWTjb4kDHOqjchaHeMHOCKz
        qLAyFj4tmpJ7kg1kMWohfqFhhR2e2aJFWvpV+CGvJaT57jKrNJ69/TESjYIQZjuwwepQ1PYC4gbKI
        DzkVzL2hoGZD/lW3LQJA3fPYqlbXYTydSrePlgsUAkEqrsGM6zxZbQ/KuqD6r8zUQRdU2ud0hevoN
        VdkmplTJ89s+FnpSH3zBlBjOhvXc2BxNUCjfVD2bYkCTioShyK/nB6edw0lguq263zsCCCyQ2Hzby
        kbkgLiqQapzGXa3ClBs9X5btgdH/pCbPDrY1hD6zwbAq0B0cqv8eXQQRhDMaUieZBFhdE/w8e5Mdf
    
Content-Disposition: inline
In-Reply-To: <20180801151958.32590-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Aug 01, 2018 at 11:19:57AM -0400, Johannes Weiner wrote:
> +	/* total= */
> +	for (s = 0; s < NR_PSI_STATES - 1; s++)
> +		group->total[s] += div_u64(deltas[s], max(nonidle_total, 1UL));

Just a nit; probably not worth fixing.

This looses the remainder of that division. But since the divisor is
variable it becomes really hard to not loose something at some point.


