From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 1/2] blk-stat: fix QUEUE_FLAG_STATS clear
Date: Thu, 13 Apr 2023 06:49:42 -0600
Message-ID: <168139018203.8989.17731261770336366712.b4-ty@kernel.dk>
References: <20230413062805.2081970-1-chengming.zhou@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681390183; x=1683982183;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=chPnl8Mv5KXZq4yhNcjhEego6Gn/IkEJkBYC5Nsft1o=;
        b=n9n/9LPPtKwIJ41ocSYVaM7cPpKBO3Qcmc9Dot62ShK5jStwhmJ6In8nvzUsWRrBDO
         BSXX4+OeuR2licrgEGhWJ82EXMvWg2ao9QoAnss8Lv3tL86cmYZe6hrTvrpXDzyPeoCm
         DHI1C8UT8Y7ehTZP+Mw+bpgD+44Trf1ENcyQ0xRGi6miLfBQTB/SbiN43gj0IeqoGvjb
         dSLTH44Eh4efnjmvwU50c+PHRlt5MW4+S/1g2+8Zw45DANXQRm8M2uvniAL9kdnw/+iM
         d1g6Ek7N2QypGMFGVkRH2l0mcDCWIa4PhivcNL82TWTtRhGqNflTKkDKSRhCOZOmKC4b
         eItg==
In-Reply-To: <20230413062805.2081970-1-chengming.zhou@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, chengming.zhou@linux.dev
Cc: josef@toxicpanda.com, osandov@fb.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>, stable@vger.kernel.org


On Thu, 13 Apr 2023 14:28:04 +0800, chengming.zhou@linux.dev wrote:
> We need to set QUEUE_FLAG_STATS for two cases:
> 1. blk_stat_enable_accounting()
> 2. blk_stat_add_callback()
> 
> So we should clear it only when ((q->stats->accounting == 0) &&
> list_empty(&q->stats->callbacks)).
> 
> [...]

Applied, thanks!

[1/2] blk-stat: fix QUEUE_FLAG_STATS clear
      commit: 20de765f6d9da0c47b756429c60b41063b990a10
[2/2] blk-throttle: only enable blk-stat when BLK_DEV_THROTTLING_LOW
      commit: 8e15dfbd9ae21e518979e3823e335073e725f445

Best regards,
-- 
Jens Axboe



