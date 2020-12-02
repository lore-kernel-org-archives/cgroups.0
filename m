From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-throttle: don't check whether or not lower limit is
 valid if CONFIG_BLK_DEV_THROTTLING_LOW is off
Date: Wed, 2 Dec 2020 14:10:41 -0500
Message-ID: <X8fmsbgvajlCvvLD@mtj.duckdns.org>
References: <20201126031834.40807-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v5D6PtLHVVQdV/ubjkOzdJ2GbL8TD6flP6rlB6RAW04=;
        b=cuyop+6GEYsJfkfCvrlT56PR6leruYXY5xPg4Fdmi14/OZPEhEcIUgeCsS0pTNj7Eh
         jzkIP1A/NrdAr19D53DRdBUsnOAOhlNewUybMARKFcP77devwmFS1CqYYaN7HC4m0lgi
         DFbVKFSeopvdwV5JccZt++HutFbOhhiVtFp3yMOsECMbScMuv1/v1XE6VDoPwzjAowuL
         75XHn4iGJsiobXi24yrPTzCNOk/Mzrp+2cWJ1wW0OBGhuX7sTcpU6W/a++z4rZypJnV5
         xWMyeP1DfqXvkJB4MZcZsY3WyzipNR0PEe7As0InJw/dJbEJ4S8+5F1Az9sEW9b7Vrnl
         Cwcw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20201126031834.40807-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, zhangxiaoxu5@huawei.com

On Thu, Nov 26, 2020 at 11:18:34AM +0800, Yu Kuai wrote:
> blk_throtl_update_limit_valid() will search for descendants to see if
> 'LIMIT_LOW' of bps/iops and READ/WRITE is nonzero. However, they're always
> zero if CONFIG_BLK_DEV_THROTTLING_LOW is not set, furthermore, a lot of
> time will be wasted to iterate descendants.
> 
> Thus do nothing in blk_throtl_update_limit_valid() in such situation.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
