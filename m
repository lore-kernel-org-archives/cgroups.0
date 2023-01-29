From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v3 0/3] blk-cgroup: make sure pd_free_fn() is
 called in order
Date: Sun, 29 Jan 2023 15:20:30 -0700
Message-ID: <167503083019.59803.12005563665423303861.b4-ty@kernel.dk>
References: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PaWOdTWb/BaPcMrfWb0OI2BnQ5NRhvslPHB9PaY2czM=;
        b=bSlmnlpDPVJKHl8Ffvd1webJtnqNaWXDEXWAQNGHj+jalLonYk3eGyf9SeIpq1BOg6
         ZP1JHTvOyuYq0rBU6JKuasQzCF0kqyUlIYxZSeWZdCENAa5OxWXBFJhGwuH6Ca4eDC0E
         2oUU0dR+w+fKBn1TVUAGKuMOufVG3GrRU5E9NI3ASKx0DtMyRwwn0aV77msXgVUFMKcy
         O8JTdKE6cAOpKZBKfS+bxtcSsAP8oghB0pcfpfP+qrE6tFjyzcwnDils1ZYhHKHwkP0o
         BQgJXcT9BEenssOUSVckjG6UwLYw1C986N/6o/DgTJVrw2hbV0nSciHCqpFNh2S7mTBu
         XIoQ==
In-Reply-To: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@lst.de, josef@toxicpanda.com, Yu Kuai <yukuai1@huaweicloud.com>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com


On Thu, 19 Jan 2023 19:03:47 +0800, Yu Kuai wrote:
> Changes in v3:
>  - add ack tag from Tejun for patch 1,2
>  - as suggested by Tejun, update commit message and comments in patch 3
> 
> The problem was found in iocost orignally([1]) that ioc can be freed in
> ioc_pd_free(). And later we found that there are more problem in
> iocost([2]).
> 
> [...]

Applied, thanks!

[1/3] blk-cgroup: dropping parent refcount after pd_free_fn() is done
      commit: c7241babf0855d8a6180cd1743ff0ec34de40b4e
[2/3] blk-cgroup: support to track if policy is online
      commit: dfd6200a095440b663099d8d42f1efb0175a1ce3
[3/3] blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()
      commit: f1c006f1c6850c14040f8337753a63119bba39b9

Best regards,
-- 
Jens Axboe



