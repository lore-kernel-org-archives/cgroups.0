From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 block/for-next] blk-iocost: fix divide-by-zero in
 transfer_surpluses()
Date: Fri, 11 Sep 2020 16:43:18 -0600
Message-ID: <59987f54-47fc-766f-0667-5a90daca0b1a@kernel.dk>
References: <20200911170746.GG4295@mtj.thefacebook.com>
 <ff46ca79-433e-3279-a8eb-35156639be7b@kernel.dk>
 <20200911224049.GA865564@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V4dnIXk3uASFKmAsRylpgs6PaxAQ2I8kA/uiE395NMo=;
        b=xKBpO0c7GRfYDlEvLIcuNo7cRQKOSRBWiJnlgrExH6GawCClKntMGl+YgUGmo44diD
         hVelwgwdl8uGB6WpaSdNINPmC+FAW+U5a8iu9cXUDZ64bb7PgTxsVdn0EVVo5jzk8sTL
         p0ethGOksPgsdk/nQTW+OAR+zST8OuXiaWDh856pqqP+RQsPxz/U2veX7DhRRRUDpikB
         2fmlhmtzOOSamIyWoTaqagyl76oQZuf5XRaDm/gsI3gppuiS5MvVp4YHjMRpBEOlTw4k
         +DEkeaQNS2WeLJ6OLV9t1UFRRxPRfSv6ZFwnnulpSP8Yy3TOCl+kyeJLFvQUXrKrFfae
         d78A==
In-Reply-To: <20200911224049.GA865564@mtj.thefacebook.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org

On 9/11/20 4:40 PM, Tejun Heo wrote:
> Conceptually, root_iocg->hweight_donating must be less than WEIGHT_ONE but
> all hweight calculations round up and thus it may end up >= WEIGHT_ONE
> triggering divide-by-zero and other issues. Bound the value to avoid
> surprises.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Fixes: e08d02aa5fc9 ("blk-iocost: implement Andy's method for donation weight updates")
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Jens, I was flipping between doing max_t(, 1) over the whole divider and
> doing min_t(, WEIGHT_ONE - 1) for hweight_donating. I thought that I as
> testing after the last change but it obviously wasn't and the previous patch
> doesn't compile due to missing type argument. Can you please apply this
> patch instead? I can send an incremental patch if that'd be better. My
> apologies.

Sure, I replaced it. BTW, you had two signed-off-by's in there.

-- 
Jens Axboe

