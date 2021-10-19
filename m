From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] block, bfq: fix UAF problem in bfqg_stats_init()
Date: Tue, 19 Oct 2021 08:02:07 -1000
Message-ID: <YW8IH83UVyWrivVS@slm.duckdns.org>
References: <20211018024225.1493938-1-zhengliang6@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3sZM03eQhB2KzVvExB+/wmjn4hXG0h6WujSIe5Eehcg=;
        b=pdVCsGnAm94532oZGMO3Ez89POaEjaCzYWHB2T/AXlJ5kW/oyCcWkHgf25+XwKca1J
         a47acU8a9sfAUgqWXUcaYq6slfGMUYBcESJfuGUEzt59CGaW4CqsPe3VS7FX0eWlaWhY
         Tue14lvZ5Y9McXLISdKd/pFYeNK4mCBpxO68v+BXR5kIHZC8lSzQPxTglTLjji3OEUfF
         jd0nuqkcjHEy1T0nrO1S31iGZ4id5Zj4PP0mtLuD+ZExXNnS9W+N2mxFdx98uKgkUsiL
         YMyY88VFK/hzjbyEi+Mt/sTW45vXwseARbgOmeCXLABsSN/a1/jfF8CMViONAjZbJAnL
         f5HA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211018024225.1493938-1-zhengliang6@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zheng Liang <zhengliang6@huawei.com>
Cc: axboe@kernel.dk, paolo.valente@linaro.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, yi.zhang@huawei.com

On Mon, Oct 18, 2021 at 10:42:25AM +0800, Zheng Liang wrote:
> In bfq_pd_alloc(), the function bfqg_stats_init() init bfqg. If
> blkg_rwstat_init() init bfqg_stats->bytes successful and init
> bfqg_stats->ios failed, bfqg_stats_init() return failed, bfqg will
> be freed. But blkg_rwstat->cpu_cnt is not deleted from the list of
> percpu_counters. If we traverse the list of percpu_counters, It will
> have UAF problem.
> 
> we should use blkg_rwstat_exit() to cleanup bfqg_stats bytes in the
> above scenario.
> 
> Fixes: commit fd41e60331b ("bfq-iosched: stop using blkg->stat_bytes and ->stat_ios")
> Signed-off-by: Zheng Liang <zhengliang6@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
