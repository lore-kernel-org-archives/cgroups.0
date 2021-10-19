From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 -next 2/2] blk-cgroup: synchoronize blkg creation
 against policy deactivation
Date: Tue, 19 Oct 2021 07:03:13 -1000
Message-ID: <YW76UThK20WaCWO6@slm.duckdns.org>
References: <20211019024132.432458-1-yukuai3@huawei.com>
 <20211019024132.432458-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cb9GiFttJIShHLaHyamc/d4toGTaUJ3k9crbveF7gg0=;
        b=BOmxdUfCMIyD2fZr8/EH5QtzCVoYpqEgfRrF3aH/hGloS6T1vl6Tdvj6YFM6KkUavy
         RiUXbbMRJjlY/7JW6N+rgYfOaijFtrV2a2N5RWQjGjYI85VTkaXw4F6dEJMh/rwPnErE
         9QvDSK3qqn5jZQmbFWAY01uZ8ra8GZSHVmcG88sibvQ4RKTsqXh8NXIegJhSOCJ96AsF
         Vno+Bp3O5ZCNCbjIws4ckNImT7MTuDSOuciaJjDvQf91B2i9lFqT1X4AItb1f1dlFh6m
         cHO+YPJKuZP4eSgU0q6J694zr7qbycHQ+3esEoDmKGhX7LfHVRQP9bFkEsGD61GBLbS7
         QdNQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211019024132.432458-3-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: axboe@kernel.dk, paolo.valente@linaro.org, avanzini.arianna@gmail.com, fchecconi@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Hello,

Some nitpicks.

On Tue, Oct 19, 2021 at 10:41:32AM +0800, Yu Kuai wrote:
...
> Because blkcg_deactivate_policy() require queue to be freezed, thus grab
                                    ^                   ^        ^
                                    requires            frozen   we can grab

> q_usage_counter to synchoronize blkg_conf_prep() against
> blkcg_deactivate_policy().
...
> +	/*
> +	 * blkcg_deactivate_policy() require queue to be freezed, thus grab
> +	 * q_usage_counter to prevent concurrent with blkcg_deactivate_policy().
> +	 */

Same here.

Looks good otherwise. Please feel free to add

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
