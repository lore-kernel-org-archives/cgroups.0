From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v10 6/9] cpuset: Make generate_sched_domains() recognize
 reserved_cpus
Date: Wed, 20 Jun 2018 16:17:30 +0200
Message-ID: <20180620141730.GK2494@hirez.programming.kicks-ass.net>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-8-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YZmOzkQx23KS2w8ksxyoFyEFxXJUEXkTrldxqXASDdM=; b=sCEIb4dZo2wwINHNDKtF1ru2m
        dnr/geXd+7fDCKoe6wTqyB/xuEgV4el/YjrhyMK7lgRefdqn1OKJxP/UDLjPaPP9fvYV9RRd8I7VI
        Pxp9bOckr0dvCum33zPajjDTg0uLh+1A9iXDSmaguTNYME/bEm6YDEkh2aB8Ib2zQ5U8gq25c58jh
        tqRMQ7vk37YWDPmUuXwt6ki/nuwJV4SZumjY7rbRs+Rfayezw1nMZI7HvxQTxkP2rlnbX0bzaLwwH
        jQX6ju/4kwK1Q77JXXur0/x5TvI3puSP+UgH0BaGnppvcLKATRiyB01cXuh0fF5H63LoIzP25YcgR
    
Content-Disposition: inline
In-Reply-To: <1529295249-5207-8-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Mon, Jun 18, 2018 at 12:14:06PM +0800, Waiman Long wrote:
> The generate_sched_domains() function is modified to make it work
> correctly with the newly introduced reserved_cpus mask for schedule
> domains generation.

Why isn't this (and the previous) patch part of the patch that
introduces reserved_cpus? It seems weird to have this broken
intermediate state.
