From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 5/5] cpuset: Rebuild root domain deadline accounting
 information
Date: Tue, 25 Sep 2018 14:32:22 +0200
Message-ID: <20180925123222.GA29985@hirez.programming.kicks-ass.net>
References: <20180903142801.20046-1-juri.lelli@redhat.com>
 <20180903142801.20046-6-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fVeypW0c9yXTee3kTdE5jLY+GhHFXVY9Trn7iK79WZQ=; b=RdLVZhG+lDkTXc9gPp6JKufWK
        XYlEPTdEsYb5m/FWU0aWrOza2KZ+bdH0Z9EwY5OnN6aBeJz5+Y6K296s6j6sEXbAzKvnFDah2gKZE
        jdbZvcDhXnt8T/NOP4WCScOZCzud2CiDfyTxComHG/D+cJG5/7SbiFvuVRTzL3pkZpNmYtx/LLdaF
        gWWpf+RLxMGoeFqqMcLLuKt90bA9UGl4iYAdpi7C/wm5sipmZ9MYL8i7ZZib5Y25FvIqUcf15ebNy
        aB6+jEPDnNLhhqJFv30zZS6anOycuXpSw2uA8eSgSYDdc7D/t+niJiBsk9xRgQTEQEDZTjDF71i+/
    
Content-Disposition: inline
In-Reply-To: <20180903142801.20046-6-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Mon, Sep 03, 2018 at 04:28:01PM +0200, Juri Lelli wrote:
> +/*
> + * Called with cpuset_mutex held (rebuild_sched_domains())
> + * Called with hotplug lock held (rebuild_sched_domains_locked())
> + * Called with sched_domains_mutex held (partition_and_rebuild_domains())

Isn't that what we have lockdep_assert_held() for?

> + */
> +static void rebuild_root_domains(void)
> +{
> +	struct cpuset *cs = NULL;
> +	struct cgroup_subsys_state *pos_css;
> +
> +	rcu_read_lock();
> +
> +	/*
> +	 * Clear default root domain DL accounting, it will be computed again
> +	 * if a task belongs to it.
> +	 */
> +	dl_clear_root_domain(&def_root_domain);
> +
> +	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
> +
> +		if (cpumask_empty(cs->effective_cpus)) {
> +			pos_css = css_rightmost_descendant(pos_css);
> +			continue;
> +		}
> +
> +		css_get(&cs->css);
> +
> +		rcu_read_unlock();

That looks really dodgy, but I suppose the comment near
css_next_descendant_pre() spells out that this is in fact OK.

> +		update_tasks_root_domain(cs);
> +
> +		rcu_read_lock();
> +		css_put(&cs->css);
> +	}
> +	rcu_read_unlock();
> +}
