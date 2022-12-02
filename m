From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next] blk-cgroup: Fix some kernel-doc comments
Date: Thu, 01 Dec 2022 18:22:54 -0700
Message-ID: <166994417436.875585.12360362062569377229.b4-ty@kernel.dk>
References: <20221202011713.14834-1-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfArFpI4a8R+b20KyasbiTdOtc7N2bQ1wdu7RJkkhko=;
        b=Cb8jMoLSfDnJGI9Pp33XdZXlJvDDfcMbz3oDrUJLziJarvhGWpFLrKZAAyoLNDVtvx
         jqO7+iWRdzqJYKLL+CyQgt6GEH8V/G2frXfIYxVeR+1FVT5B3jdhcvpTsUvVkUl0N3oD
         8TVFe40JPZgJ0fBFDt3dE7RRExTcSYjq2Qno38tbDtL2tX0VOwDTUgtoOE6hd8w0W9VZ
         n5ELhE8nZFhNtEkn0tPxZhAEjfHMWPsspeJVxt10lkJX4smRqMOpQRfgvF3CMr+YoMk6
         Ityq+JjMXg85AJcC/vWX5CPFwE/KMKTJPXVgvGeQGc1KyaArklIMAo8hRNPezrSGfNfk
         4j2Q==
In-Reply-To: <20221202011713.14834-1-yang.lee@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Cc: josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>


On Fri, 02 Dec 2022 09:17:13 +0800, Yang Li wrote:
> Make the description of @gendisk to @disk in blkcg_schedule_throttle()
> to clear the below warnings:
> 
> block/blk-cgroup.c:1850: warning: Function parameter or member 'disk' not described in 'blkcg_schedule_throttle'
> block/blk-cgroup.c:1850: warning: Excess function parameter 'gendisk' description in 'blkcg_schedule_throttle'
> 
> 
> [...]

Applied, thanks!

[1/1] blk-cgroup: Fix some kernel-doc comments
      commit: 1d6df9d352bb2a3c2ddb32851dfcafb417c47762

Best regards,
-- 
Jens Axboe


