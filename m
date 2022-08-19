From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next 0/3] bfq simple cleanups
Date: Fri, 19 Aug 2022 20:56:27 +0000
Message-ID: <166094258743.37480.10341600482798936132.b4-ty@kernel.dk>
References: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=TspGg8RA/kX2lN4CLyM+oSg5D5K9Xh9asKYi5WRBw6w=;
        b=X87kIQd8Sws8VbhM7n5p21HC31jo4SDuDpDg5OwtuAnZa42ul9ZQWg5tqhSmY30pjE
         DozzYKzs9qHc1wBZccv9dp2Hctqi0WadF+WbhNgyX7kYwY6RGLQ6rRONOkZFlqWzv8UI
         CckAUSrWKZpRug5gIYtapbXDR6z+c5vT24DGJPaNHRNfyeYp+W/xT9P8kc9pZIQ8PM5h
         D8YpyFWfd353kmYfGC+UKN5HkEtgYNGl7GzP1iysuqb6SB357D2NpAW5gRPUYDlz6FI4
         Ikr1G1g3LF4OlEPEcXmxn0QLLv9vErFUm9FwCRacf1GiimbxnM19yiff8Y+n06v2bguJ
         jH3g==
In-Reply-To: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, yukuai1@huaweicloud.com
Cc: yi.zhang@huawei.com, linux-kernel@vger.kernel.org, yukuai3@huawei.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org

On Tue, 16 Aug 2022 09:56:28 +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Yu Kuai (3):
>   block: bfq: remove unused functions
>   block, bfq: remove useless checking in bfq_put_queue()
>   block, bfq: remove useless parameter for bfq_add/del_bfqq_busy()
> 
> [...]

Applied, thanks!

[1/3] block, bfq: remove unused functions
      commit: 83501be67dbabc4a19ca7cf0f7406cc200272880
[2/3] block, bfq: remove useless checking in bfq_put_queue()
      commit: bf2c5a1d2aa31faf3cae0158da2a301acfa0c9fd
[3/3] block, bfq: remove useless parameter for bfq_add/del_bfqq_busy()
      commit: f5f9d71bc15eaa72f70cd49aa507b0809a0325ae

Best regards,
-- 
Jens Axboe


