From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Tue, 17 Jul 2018 17:32:38 +0200
Message-ID: <20180717153238.GA2476@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sivGMNeEa4hjba3vK8UUdaWd0cu+fx+tu0F6HbvTrKA=; b=hHAYmvK5aBQZ/JPLolPltIS+R
        oIt6zn65AFHH8Xyv1WVfZmTOK4s1oPtWpTY/LE7traJl+mb5dIsiUqeEbmIBbAQ3V5hUR8qmtvnxj
        oUz2cwFyOCIRvX7k6+fCZ/dt6FElVDBlHXlu4LLju8lKu4szc2UzvDHNgPYM7nq7DFKZC6g2mUdGi
        NGyqbyI1IGm4DlCVsTKaFtDR9Hw7XqBkzJG+8h0uhc4XdCH6vqaZiw6bzR2eVPyvGG8kzG88vYZ59
        626IRZOrhLVKyAdGVYXryCuFys1yKUtNAc9qlpvb4Lu/ExBwd3rbHwAochgQFTYZ95DfB9MdWoVoh
    
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> +struct psi_group {
> +	struct psi_group_cpu *cpus;

That one wants a __percpu annotation on I think. Also, maybe a rename.

> +
> +	struct mutex stat_lock;
> +
> +	u64 some[NR_PSI_RESOURCES];
> +	u64 full[NR_PSI_RESOURCES];
> +
> +	unsigned long period_expires;
> +
> +	u64 last_some[NR_PSI_RESOURCES];
> +	u64 last_full[NR_PSI_RESOURCES];
> +
> +	unsigned long avg_some[NR_PSI_RESOURCES][3];
> +	unsigned long avg_full[NR_PSI_RESOURCES][3];
> +
> +	struct delayed_work clock_work;
> +};
