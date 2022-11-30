From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 04/10] blk-throttle: correct calculation of wait time
 in tg_may_dispatch
Date: Wed, 30 Nov 2022 11:27:21 -1000
Message-ID: <Y4fKuZPlfhf3+eUt@slm.duckdns.org>
References: <20221129030147.27400-1-shikemeng@huawei.com>
 <20221129030147.27400-5-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OaE3ZpzHZEl5tZygmK1eZMJQnqTDFVpbnuVQbcFSMpo=;
        b=fhIxIC91fJgssn5wrwTNqq2fpyPkj4ANNZqyK5aq6JD3fM2trj54irFW0Oq/ERk/Nn
         b1tPCOESjVmOvMZG+fWJ71rfAKe3GHNOcRwxq5IvtLDZOLCrmI2q86+BYBXT6pkGoeVQ
         Tfhj7nSBa4GAViv6nN5JqGHgWk+aM9gf2a8+UMUxzWMiqWvXhVf4xFfOGHZS5Gc83q5G
         7dDMVAAB/4NUbVZcnYIko8IDx3VGepkVRv54w/gX8LGgr+CoCxYiSyyd5JEhlwdVExIw
         zRR2BdjyjZxXMPGlVt+OebFF2GWWFXcjOgQ4c/Zx6t1rlDIwXTyzq8RJ/CXuLB2Lpcq0
         idaw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221129030147.27400-5-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 29, 2022 at 11:01:41AM +0800, Kemeng Shi wrote:
> In C language, When executing "if (expression1 && expression2)" and
> expression1 return false, the expression2 may not be executed.
> For "tg_within_bps_limit(tg, bio, bps_limit, &bps_wait) &&
> tg_within_iops_limit(tg, bio, iops_limit, &iops_wait))", if bps is
> limited, tg_within_bps_limit will return false and
> tg_within_iops_limit will not be called. So even bps and iops are
> both limited, iops_wait will not be calculated and is always zero.
> So wait time of iops is always ignored.
> 
> Fix this by always calling tg_within_bps_limit and tg_within_iops_limit
> to get wait time for both bps and iops.
> 
> Observed that:
> 1. Wait time in tg_within_iops_limit/tg_within_bps_limit need always
> be stored as wait argument is always passed.
> 2. wait time is stored to zero if iops/bps is limited otherwise non-zero
> is stored.
> Simpfy tg_within_iops_limit/tg_within_bps_limit by removing wait argument
> and return wait time directly. Caller tg_may_dispatch checks if wait time
> is zero to find if iops/bps is limited.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
