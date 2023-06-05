From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-iocost: use spin_lock_irqsave in
 adjust_inuse_and_calc_cost
Date: Mon, 05 Jun 2023 12:09:00 -0600
Message-ID: <168598854044.127564.8532399641861277056.b4-ty@kernel.dk>
References: <20230527091904.3001833-1-linan666@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685988542; x=1688580542;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SbhZgeRfrMzo8RZUjiv5Kr8KvV2/iK/o9SdLtbvSVL4=;
        b=M12TBi/qdCVHqFYGFxUaq8Xsf9tqgm2Saa+5o3o1AI1a3KbqNFyMgmbcVKqIov05Ci
         uMu1xJio3U6fVN1G/jl2PUsd6FfTM2VoZDOwX7lR25xQYp21IAoM8ZUY/ZFgfbyD0/sV
         1KfXLD/Y35e9+smYan7Kr0Rem30tgZYv9c1pkZmEhNS3G64FQ4tbzn+Z96fOlAH7oCKE
         70Mug7V/5btfozq7bpQdOHu/l9UdwCtFocNQzW7AxzrKfoRhhwBlyuGyqmjY35AoVCsP
         1bBlhI363MBzD9H2yKJRzFRGAoewe0XkRBxhBpjKASyBecCg93NxosUIBRL4RHua0PUg
         e6fQ==
In-Reply-To: <20230527091904.3001833-1-linan666@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, linan666@huaweicloud.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linan122@huawei.com, yukuai3@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com


On Sat, 27 May 2023 17:19:04 +0800, linan666@huaweicloud.com wrote:
> adjust_inuse_and_calc_cost() use spin_lock_irq() and IRQ will be enabled
> when unlock. DEADLOCK might happen if we have held other locks and disabled
> IRQ before invoking it.
> 
> Fix it by using spin_lock_irqsave() instead, which can keep IRQ state
> consistent with before when unlock.
> 
> [...]

Applied, thanks!

[1/1] blk-iocost: use spin_lock_irqsave in adjust_inuse_and_calc_cost
      commit: 8d211554679d0b23702bd32ba04aeac0c1c4f660

Best regards,
-- 
Jens Axboe



