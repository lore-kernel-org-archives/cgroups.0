From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-throttle: don't check whether or not lower limit is
 valid if CONFIG_BLK_DEV_THROTTLING_LOW is off
Date: Wed, 2 Dec 2020 12:44:38 -0700
Message-ID: <51844d83-3447-cf0f-bde2-d368f5f43f5a@kernel.dk>
References: <20201126031834.40807-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QyEPDAytTEl0uopebdyNHFfe+27dQnLC51NhV3dnBlQ=;
        b=OBM1e4X4T5ctyaC99rN18qygJBuxT+Na4CBNEK0YrhauMduyrFTBQhoBjaEMQ9gkgP
         RJDGNWlQZUoeYB18Zc8lohe07PWMzXOXi36725jdFTsya/BtObnqro1yRkyJ+pPO4K4m
         2Key7R6FaAFR5VWNEtq5Q8UX8qafo/GEDz6cEwX68EMT3OyNwoakm1ExLrjmVVqzAkX5
         TeGUe2RLSQvwYYvowut5+1w4CA2CMErINS9xnd5OutfEFUpKZ1U5Rb+h7ImZFTFCrloo
         BhBk8q6z//pFqFhMRW75a30MgVsZ0ZSTKti8GAxpWsA4PNnPv6iHFpneacE6hFIqcjsz
         uJPQ==
In-Reply-To: <20201126031834.40807-1-yukuai3@huawei.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3@huawei.com>, tj@kernel.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, zhangxiaoxu5@huawei.com

On 11/25/20 8:18 PM, Yu Kuai wrote:
> blk_throtl_update_limit_valid() will search for descendants to see if
> 'LIMIT_LOW' of bps/iops and READ/WRITE is nonzero. However, they're always
> zero if CONFIG_BLK_DEV_THROTTLING_LOW is not set, furthermore, a lot of
> time will be wasted to iterate descendants.
> 
> Thus do nothing in blk_throtl_update_limit_valid() in such situation.

Applied, thanks.

-- 
Jens Axboe

