From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] blk-throttle: cleanup tg_update_disptime()
Date: Tue, 23 Aug 2022 08:29:47 -1000
Message-ID: <YwUcm4CimyyOFlP9@slm.duckdns.org>
References: <20220823013810.406075-1-yukuai1@huaweicloud.com>
 <20220823013810.406075-4-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=M2hrrnjzGGDhp1wkMOokst/GRD85/gv0Qg6iilAzV1k=;
        b=OjUPGn/imFgBiDsB0U79V5mA/4F1MBgRH/FFpHAH17+hJjJ9TU77qiyIqRVdvYoWEs
         d5YvATv2F4Gau8mbSWpVGGTnT2B7um/7W8T1oy1/jGX5eeZuWP/+DoZvBBvHgjp9BFf4
         +mALYB5AniEaU/VKxwQTokaQ53CRRjVBzF3fgZrnHd61mlTngp77CF5APCB2Dk4mBOXQ
         TXMVGfenVSXmsecWVzJadWfzXedN4zCGOf1mW4D2jBh2rQDmxnnaZ1uV9AlGuzUDa2UX
         mNBjF0dBUhYpv7QyWYm5sACexkkec0CoP8EEWNoKyW6M+0Bbox0mwhXHWhpFCcF+yi9F
         p1eg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220823013810.406075-4-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Tue, Aug 23, 2022 at 09:38:09AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> tg_update_disptime() only need to adjust postion for 'tg' in
> 'parent_sq', there is no need to call throtl_enqueue/dequeue_tg(),
> since they will set/clear flag THROTL_TG_PENDING and increase/decrease
> nr_pending, which is useless. By the way, clear the flag/decrease
> nr_pending while there are still throttled bios is not good for debugging.
> 
> There are no functional changes.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
