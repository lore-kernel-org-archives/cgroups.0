From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v3] block, bfq: cleanup 'bfqg->online'
Date: Tue, 07 Feb 2023 10:21:16 -0700
Message-ID: <167579047693.46818.10367166447142980266.b4-ty@kernel.dk>
References: <20230202134913.2364549-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMaLavanXS/g3XR3klgJ+AXxx5vAw+8OAiDcCfQmZ38=;
        b=2hB7T/Tz8d1WAzTpONaDpUxhkaEVNbh0h9B8xkNZvMe43HL03tD7YHvce0HxfrvSHK
         27TQB0k86z1+5j3w7l/y3jAOB44wuDACRwfuKfwiJN/nidqs5p29wXBUM66DXkWXEycp
         cMWJuan9yazhuWeUKcH+IHOSqbxYNqlXD5NKddeMraXgh6GEXjdlHlHpJyW7vDpWXoDQ
         L7leV7jz/f1xn0D1aufsFqCWMrQ/UZpU6CJ5rRTtpdlr5rsBNLqkGF0Fw8pAnEBkHHct
         31HWrimj50t7Wu8Ne4X4ZrZcrspXj4vtQJqA7m7G8Puhuc971lLRbiah8iZFSsg9u6RA
         55Kg==
In-Reply-To: <20230202134913.2364549-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, tj@kernel.org, josef@toxicpanda.com, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com


On Thu, 02 Feb 2023 21:49:13 +0800, Yu Kuai wrote:
> After commit dfd6200a0954 ("blk-cgroup: support to track if policy is
> online"), there is no need to do this again in bfq.
> 
> However, 'pd->online' is not protected by 'bfqd->lock', in order to make
> sure bfq won't see that 'pd->online' is still set after bfq_pd_offline(),
> clear it before bfq_pd_offline() is called. This is fine because other
> polices doesn't use 'pd->online' and bfq_pd_offline() will move active
> bfqq to root cgroup anyway.
> 
> [...]

Applied, thanks!

[1/1] block, bfq: cleanup 'bfqg->online'
      commit: f37bf75ca73d523ebaa7ceb44c45d8ecd05374fe

Best regards,
-- 
Jens Axboe



