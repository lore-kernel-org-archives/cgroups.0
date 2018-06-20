From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v10 3/9] cpuset: Simulate auto-off of sched.domain_root
 at cgroup removal
Date: Wed, 20 Jun 2018 16:11:44 +0200
Message-ID: <20180620141144.GI2494@hirez.programming.kicks-ass.net>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-4-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fszqOchqOK3zF6lfDyZsNt7DpBDbt1prSdKz0mQ/Vac=; b=nkDEBr1v+wQdIXBAbpPMewwXH
        ikym0EHbvTkNrpgGatILlOzNxqC+wGfnKDkFb4wHzyaPlqAa9xIz4J78Te/1OviOBCq9cI1D2GEhe
        /EGBiryv3/kSnaFw3rmlz3+Bt3Y4cR2CWnsxiApROVEyuXTM1G6SfS5U74vh2JDS0gYDyqHRv+rMb
        dofvYdyJCCySf/dkTUDDqHOZ94YzSHPT5xYLOBPwIRF2Vpf6heUKyM2Af3giTr42MXqgDjxmRuhds
        7bT6v1NvJflu5WfF/AzGhqyuRgzphX7XZAUpa/voOKaMRSAPASzn6rDb3BhygM23vJXWpppjYALJy
    
Content-Disposition: inline
In-Reply-To: <1529295249-5207-4-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Mon, Jun 18, 2018 at 12:14:02PM +0800, Waiman Long wrote:
> @@ -1058,7 +1060,12 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
>  	 * Check if any CPUs in addmask or delmask are in the effective_cpus
>  	 * of a sibling cpuset. The implied cpu_exclusive of a scheduling
>  	 * domain root will ensure there are no overlap in cpus_allowed.
> +	 *
> +	 * This check is skipped if the cpuset is dying.

Comments that state what the code does are mostly useless; please
explain _why_ if anything.

>  	 */
> +	if (dying)
> +		goto updated_reserved_cpus;
> +
>  	rcu_read_lock();
>  	cpuset_for_each_child(sibling, pos_css, parent) {
>  		if ((sibling == cpuset) || !(sibling->css.flags & CSS_ONLINE))
