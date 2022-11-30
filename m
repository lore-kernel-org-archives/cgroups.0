From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 09/10] blk-throttle: Use more siutable time_after
 check for update of slice_start
Date: Wed, 30 Nov 2022 11:34:59 -1000
Message-ID: <Y4fMg4Hnu3dDTjId@slm.duckdns.org>
References: <20221129030147.27400-1-shikemeng@huawei.com>
 <20221129030147.27400-10-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XXkUDMcMs9WgGhgTQ1dg9rnTqsob6sBXrwZraJBx4kE=;
        b=nWCah6XMtnPWKJh6vnssFI5N/d9FQPdB7jV8COmfDte+xB72bpw8YGjxueh9go/+G/
         0ZvDJSh6pXGklPLGyb0MTiquttx+tLL5zhtb7mB4UMKuRA0LfDsaftGMmGD+ZpW5PJb/
         xXRY/EOFmjzjgw4kZlueQSvs71oZrem4XKD1bspbiugsDherySnobRVkOHdTFMGJnjVT
         GtqfIvq/dIWRXzZdN+argCD1CLF+29dpyp9+Oy9nnf2Q427psbpiQ09Cn3bXrz1xzK2I
         qomSU9j6YdH2Yx+l7cXqkPoxlytpnPZCRGQJoI0rp84YFDzMFwOzdpfa2Qg7itviowav
         Ayig==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221129030147.27400-10-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 29, 2022 at 11:01:46AM +0800, Kemeng Shi wrote:
> There is no need to update tg->slice_start[rw] to start when they are
> equal already. So remove "eq" part of check before update slice_start.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
