From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 5/5] cpuset: Rebuild root domain deadline accounting
 information
Date: Tue, 25 Sep 2018 14:53:59 +0200
Message-ID: <20180925125359.GB29985@hirez.programming.kicks-ass.net>
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
         bh=YfEgqCZsL0D0MX2UFgrk0gZ2R/zh4SL983DQE0j7GFE=; b=NTAuHPTBofAjMrR1WN4NdN55e
        M4pzeMj4oDIbpsvrsrJcH4K3wVuXgN5eDInCFzwZ4j0sOXcbKOJQcNHHnReiAICb98+JOggs94/A6
        WmgUORQL+iwYxPIQ39WIw09TC/4lqqfj+2cyChwES5GxjnxFJLTkOdd9nY+GAARvHtz2DFzAWZBI5
        Qyax5D13zGJOGVZ4YE79ojWZVfKtV5PbowQJV2bQi9ZroEH06ULaU4xvRQUPcwmWanC4L5l9xjN+n
        n4ZFqlha26Fr5IQwPWhVCuTAGCQqN41cgmbPPfbhq9a8jnaDArrn8wPP7/NSnfknUazAkj94LXF0P
    
Content-Disposition: inline
In-Reply-To: <20180903142801.20046-6-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Mon, Sep 03, 2018 at 04:28:01PM +0200, Juri Lelli wrote:
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index fb7ae691cb82..08128bdf3944 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -1883,8 +1883,19 @@ void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new[],
>  	for (i = 0; i < ndoms_cur; i++) {
>  		for (j = 0; j < n && !new_topology; j++) {
>  			if (cpumask_equal(doms_cur[i], doms_new[j])
> -			    && dattrs_equal(dattr_cur, i, dattr_new, j))
> +			    && dattrs_equal(dattr_cur, i, dattr_new, j)) {

While there, please also fix that wrongly placed operator.

> +				struct root_domain *rd;
> +
> +				/*
> +				 * This domain won't be destroyed and as such
> +				 * its dl_bw->total_bw needs to be cleared.  It
> +				 * will be recomputed in function
> +				 * update_tasks_root_domain().
> +				 */
> +				rd = cpu_rq(cpumask_any(doms_cur[i]))->rd;
> +				dl_clear_root_domain(rd);
>  				goto match1;
> +			}
>  		}
>  		/* No match - a current sched domain not in new doms_new[] */
>  		detach_destroy_domains(doms_cur[i]);
> -- 
> 2.17.1
> 
