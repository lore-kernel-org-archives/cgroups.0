From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] blk-throttle: Fix io statistics for cgroup v1
Date: Sun, 25 Jun 2023 08:01:22 -0600
Message-ID: <168770168286.14597.14477909506148885094.b4-ty@kernel.dk>
References: <20230507170631.89607-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687701684; x=1690293684;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81hUfeigYJdMFcea0oHNmqYrI7BM6QQbtVqGrjtpVcw=;
        b=omJ60U9Qa+EzsyrYGCEYVm7rpu9bSuvkuuFwvdy+o9XQXcz6Gn3wNKLQoPwPsKHU/T
         LLEcea6iFpOYaYujaAt6zQv2cjHlvilSbazMzJSb2CPn2Pd+FS+Z/jkXf/aZGYkmCeVp
         R4Ox3wKFBv73f8gYU1G+ATs/2DFRCnDjCGHvJ+fAhIh1JER2+kOFZTQILWhlWkjyhhMD
         uqR+oPbHY+cTdQW0Oz3aeMuZGTHDjhCadDMaQEhQgKaCq/MyUyo0Jrh5cPAvN5a5uXJl
         NorS5USW7yLstX0sh3xaEPnAso4GSPACcMW7/zF73tdc331xKHrHks1xVMLafI9kzziR
         ykuQ==
In-Reply-To: <20230507170631.89607-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, Jinke Han <hanjinke.666@bytedance.com>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, andrea.righi@canonical.com, Muchun Song <muchun.song@linux.dev>


On Mon, 08 May 2023 01:06:31 +0800, Jinke Han wrote:
> After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
> blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
> the only stable io stats interface of cgroup v1, and these statistics
> are done in the blk-throttle code. But the current code only counts the
> bios that are actually throttled. When the user does not add the throttle
> limit, the io stats for cgroup v1 has nothing. I fix it according to the
> statistical method of v2, and made it count all ios accurately.
> 
> [...]

Applied, thanks!

[1/1] blk-throttle: Fix io statistics for cgroup v1
      commit: ad7c3b41e86b59943a903d23c7b037d820e6270c

Best regards,
-- 
Jens Axboe



