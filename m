From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-5.4-fixes] blkcg: make blkcg_print_stat() print
 stats only for online blkgs
Date: Wed, 6 Nov 2019 17:08:59 -0700
Message-ID: <1ef277bb-8591-6029-2e9b-319820b3460c@kernel.dk>
References: <20191105160951.GS3622521@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nqDRoSA2IlRCgtZEklSoyPJxix3jduddAsTI1/jyNJM=;
        b=X2Ic0fSApnzTHNdrcWe9ggsXClLt1ZYXt51dLoiznXpJfWYe3WV0JSVtA1y/6Be8bk
         HohaOtxR35Sl1zMaaCuBEU2N7beBAJZ2RGI4bSzq0bz0ir/9PX0PQ4GkHuPfV3Tm1TiA
         8gHEAUPHwZf8+bIjL1S08URkQ/1PEnfN2DsVLfp5tonTKKUgKFExNd3mP7Q9z+dZEdi+
         kQegPZECwkYzCfuFG9PngeOxvXCXj1yp/FIhILtDJqzFKtbqNLiEjUhqqzmiufO0F/Em
         9ORpFhWbqBXvN/KD6ROet7VPkhdoEDubSk9PGlBk5PGcpq0Xcu/jpcL/NGK10FpQBF/j
         9YBg==
In-Reply-To: <20191105160951.GS3622521@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Josef Bacik <jbacik@fb.com>

On 11/5/19 9:09 AM, Tejun Heo wrote:
> blkcg_print_stat() iterates blkgs under RCU and doesn't test whether
> the blkg is online.  This can call into pd_stat_fn() on a pd which is
> still being initialized leading to an oops.
> 
> The heaviest operation - recursively summing up rwstat counters - is
> already done while holding the queue_lock.  Expand queue_lock to cover
> the other operations and skip the blkg if it isn't online yet.  The
> online state is protected by both blkcg and queue locks, so this
> guarantees that only online blkgs are processed.

Applied, thanks Tejun.

-- 
Jens Axboe

