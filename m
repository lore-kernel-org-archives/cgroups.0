From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4] blk-ioprio: Introduce promote-to-rt policy
Date: Tue, 06 Jun 2023 22:27:02 -0600
Message-ID: <168611202214.121141.17298993524876974749.b4-ty@kernel.dk>
References: <20230428074404.280532-1-houtao@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686112025; x=1688704025;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPSKz7WcmWYDoiWla/HjpfomHebC25lLZctCV/vLH4k=;
        b=YoflSz/WWxi5+uAGhkj3VOsHqFcBqNc2/nJq9qn0WwAt7+Jb+cNtwE/5wehV4e5iNw
         LjjKvgxxNAG2mjKSNdnhAogPK/DpK2l79V51b3G70hzwnsyGpAl4RrhLwcv3tJ9EDtTX
         vVyjcp9QiLM9j3NjPKw4mX51UiG2kxTthhPf1vSOoiLxBP7Z5S70RCo4rIddBPIKcOCD
         WrHV3kpK94KzFZ9ysDcqNaRe55bIxZC83YS8eiTw4bTv3rXdUcoG4vQY5M+7yfIm3Ysc
         rGcl9SfpUW26IMk3MddsmlZHEzf2u3GAR9oUy1X3y7c21uche6LUoeCWj6EjRoJllgRk
         zQSg==
In-Reply-To: <20230428074404.280532-1-houtao@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-block@vger.kernel.org, Hou Tao <houtao@huaweicloud.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>, Bagas Sanjaya <bagasdotme@gmail.com>, Chaitanya Kulkarni <kch@nvidia.com>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com


On Fri, 28 Apr 2023 15:44:04 +0800, Hou Tao wrote:
> Since commit a78418e6a04c ("block: Always initialize bio IO priority on
> submit"), bio->bi_ioprio will never be IOPRIO_CLASS_NONE when calling
> blkcg_set_ioprio(), so there will be no way to promote the io-priority
> of one cgroup to IOPRIO_CLASS_RT, because bi_ioprio will always be
> greater than or equals to IOPRIO_CLASS_RT.
> 
> It seems possible to call blkcg_set_ioprio() first then try to
> initialize bi_ioprio later in bio_set_ioprio(), but this doesn't work
> for bio in which bi_ioprio is already initialized (e.g., direct-io), so
> introduce a new promote-to-rt policy to promote the iopriority of bio to
> IOPRIO_CLASS_RT if the ioprio is not already RT.
> 
> [...]

Applied, thanks!

[1/1] blk-ioprio: Introduce promote-to-rt policy
      commit: ddf63516d8d37528dc6834c7f19b55084e956068

Best regards,
-- 
Jens Axboe



