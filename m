From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-throttle: fix UAF by deleteing timer in
 blk_throtl_exit()
Date: Tue, 7 Sep 2021 08:37:06 -0600
Message-ID: <1f962850-06d6-f50b-2c2f-e6d5bfd3823a@kernel.dk>
References: <20210907121242.2885564-1-lijinlin3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/S6NVKS+rAl9aR4n3SE5uAuU4aZe4mciq8781mBYsjY=;
        b=VOSgUj1wc8knZeRVbNf3FAbpUzXJwSywrL5pYnfp/MjmVmoTrq28kVxU5DqwyIILlZ
         DT2SMXaXjzmzG4AZ7rXZwgKHeXg8KqB4S3W/w36ws2XAxAswl50Xo3REg9dt+BN3TdLW
         lmBD1A+fLx4oLlSeJVpuaGEhe/i+1snel97IOVR21KRTIlS3aFXdtIaNnIxXygIZbgXV
         cmC9VAeQ7K4sFJwKTadlgI46iF7/Uk2OrUEcLBQDiUGlQJbAu2htDS0OpSjh9tCcX0Y/
         YnCYlMXiUrsklhsGY+zQCX5/Z4Odevd6KG+8Eq5B0+D8gagDAARC/GOuTv9KYRdH0Hjx
         kzRQ==
In-Reply-To: <20210907121242.2885564-1-lijinlin3@huawei.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Jinlin <lijinlin3@huawei.com>, tj@kernel.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, louhongxiang@huawei.com

On 9/7/21 6:12 AM, Li Jinlin wrote:
> From: Li Jinlin <lijinlin3@huawei.com>
> 
> The pending timer has been set up in blk_throtl_init(). However, the
> timer is not deleted in blk_throtl_exit(). This means that the timer
> handler may still be running after freeing the timer, which would
> result in a use-after-free.
> 
> Fix by calling del_timer_sync() to delete the timer in blk_throtl_exit().

Applied, thanks.

-- 
Jens Axboe

