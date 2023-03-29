From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] block, bfq: remove BFQ_WEIGHT_LEGACY_DFL
Date: Wed, 29 Mar 2023 08:59:22 -1000
Message-ID: <ZCSKirFH8f1JdQS2@slm.duckdns.org>
References: <20230328145701.33699-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680116364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zJfV/EDnHa0A2JJ1AesjXORYSgBsKU2wVwRQ4vy/4iQ=;
        b=FKaRnypaQDkZ4l8caHAGiLzNJrsI9T/qkI3o1WjciLQxnvIT5nqZmeoU2y2X2UJ50o
         o+9veybnwPzpDwC216zieg0Z51t/l+P4o9agFbIL60MDJ4DWn9H6WsqPjGA7LGnzRYNH
         t5B848SJZVl3dwJN0TDEIayEToErYSLiDNzBG1cBuA3RKKEjmh+tpz/TiIsmi5wkKebT
         KKevTWRdYDjlS3joQpYK3peN4xY1PsjJ8nZ4DRuvuaJUr4Z3Fk6ySh0SM9O9NDV2mX8Q
         12bwDpgiCXja6r+jdbrtZkTCWor73mD1+S1C/pRB8grwYrSRvvLKDlyn/t3OJJ36OzN5
         /nQg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230328145701.33699-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: paolo.valente@linaro.org, axboe@kernel.dk, josef@toxicpanda.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Mar 28, 2023 at 10:56:58PM +0800, Chengming Zhou wrote:
> BFQ_WEIGHT_LEGACY_DFL is the same as CGROUP_WEIGHT_DFL, which means
> we don't need cpd_bind_fn() callback to update default weight when
> attached to a hierarchy.
> 
> This patch remove BFQ_WEIGHT_LEGACY_DFL and cpd_bind_fn().
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

For 1-3,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
