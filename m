From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Sat, 14 Jul 2018 10:48:01 +0200
Message-ID: <20180714084801.GB4920@worktop.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180713092153.GU2494@hirez.programming.kicks-ass.net>
 <20180713161756.GA21168@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D4UH+YSxBBsFpoWpsdR49sCjczDPjsDoe/b3ykeEbSg=; b=ASPFh83A6P0wyfA5ZSABHOd5G
        2zO4hvGtG0o3nSAY27X5ZIox46ynM+x6Y3pldiRdjZCLLro7MMJmfzHKQugKFbv37WAeLKsZ23Z1K
        e8SfE7irA4q7yc1J2Ajzk79Clk2CmzVVDHZKLampmKjJMZIA+zvSbITA0msbnDC/AlbDsyFhWPi1c
        WYiCDTJy44T1g33FlvxoN3WEGVFGu6NWbtiJiIvKY6sec8eWVH83Uziw4mOvcJIL2KG58RuLWdO55
        8DUU32v6vz6v9qiRq1HCy2ZInxRZImTrbFcV1rBxvhBHllD31pdPvpIvuzRx6wAUdx2jKm8s97yMy
      
Content-Disposition: inline
In-Reply-To: <20180713161756.GA21168@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com


Hi Johannes,

A few quick comments on first reading; I'll do a second and more
thorough reading on Monday.

On Fri, Jul 13, 2018 at 12:17:56PM -0400, Johannes Weiner wrote:
> First off, what I want to do can indeed be done without a strong link
> of a sleeping task to a CPU. We don't rely on it, and it's something I
> only figured out in v2. The important thing is not, as I previously
> thought, that CPUs are tracked independently from each other, but that
> we use potential execution threads as the baseline for potential that
> could be wasted by resource delays. Tracking CPUs independently just
> happens to do that implicitly, but it's not a requirement.

I don't follow, but I don't think I agree.

Consider the case of 2 CPUs and 2 blocked tasks. If they both blocked on
the same CPU, then only that CPU has lost potential. Whereas the only
thing that matters is the number of blocked tasks and the number of idle
CPUs.

Those two tasks can fill the two idle CPUs. Tracking per CPU just
utterly confuses the matter.
