From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/3] blk-throttle cleanups
Date: Mon, 12 Sep 2022 00:20:28 -0600
Message-ID: <166296362850.59359.17771579764308484678.b4-ty@kernel.dk>
References: <20220827101637.1775111-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=eJpetYLvd8t1fhFVDnNO/2TqAinXp5zIfJwgDELUxmI=;
        b=Z2APGz+u9boMJ5/zapRBac1k/AOu3vzAVNEoUMY0mA6x93A9ywX16FjQP+ZEKQYlTo
         TX7I/pZJCOr/+SD/8Xa3O4r2g3IyvOOpO145ErP5/HdiqwvAWRAPyk4qnHLPvNuC1pUF
         nVEp+kkhaOfxCobHa51iKtN3YNxJyEudBtoy0SVeHB1gQ+Tr0SGc3T/FN5UEOS/JIkvE
         U9/l7Ir06H7U/Orv35Hl81uTYhdXo2UKgtpPVBw2nmkVHxxu4wGR0vcIbers5MUSFrOV
         s+S1B6xc3SHPjaZEHqR06KaLau5MWan28zlADfUjdRoV6YLYTTTgCBrVH8cJyeakwTt3
         W5SQ==
In-Reply-To: <20220827101637.1775111-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, Yu Kuai <yukuai1@huaweicloud.com>
Cc: cgroups@vger.kernel.org, yi.zhang@huawei.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com

On Sat, 27 Aug 2022 18:16:34 +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Changes in v2:
>  - add tag
>  - remove patch 4
> 
> There are no functional changes.
> 
> [...]

Applied, thanks!

[1/3] blk-throttle: use 'READ/WRITE' instead of '0/1'
      commit: 7e9c5c54d440bd6402ffdba4dc4f3df5bfe64ea4
[2/3] blk-throttle: calling throtl_dequeue/enqueue_tg in pairs
      commit: 8c25ed0cb9d2e349ebebfeacf7ce1ae015afe54d
[3/3] blk-throttle: cleanup tg_update_disptime()
      commit: c013710e1a7eba8e33da9380a068fe1cec017226

Best regards,
-- 
Jens Axboe


