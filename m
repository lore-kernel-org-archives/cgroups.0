From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v9 0/4] blk-throttle bugfix
Date: Mon, 12 Sep 2022 00:20:25 -0600
Message-ID: <166296362587.59201.9043385966296424992.b4-ty@kernel.dk>
References: <20220829022240.3348319-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=Gh72+xybfCA8FBwxhnWF+Al39bZjJMaBK2yiRuBCeS0=;
        b=ZbDpMDinqj0thb/noDlUyZWiHuLMFOSxFm4xtMxlegMHeucMybV0Bq4YkVDOFDaC8Y
         Ig7lTcfYLpfdmB6KrCDXgHuo7w6jW/lDu6dfuMXl/arg2UgI67ylm7DsBY8bei3B91E3
         lanC0MoI0VIS0S0/JD3wHTJapZ9RfGrVZd5fPg792BsJ+JHG2nJ6dfFZNhTxEzGU/gd/
         bFJHLBqL4K7K7/Rr6vf9itetdYsV+wfSqjStu4ATfyiA5iD1y3RdobOL7oFMktEbOcMp
         HmqVEiPtbPT9qSMv1bctXIt3YML7J/9qD4jNZ34tjfXsRuWakajnoIbO56Tymmmunvgy
         9ahQ==
In-Reply-To: <20220829022240.3348319-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mkoutny@suse.com, tj@kernel.org, ming.lei@redhat.com, Yu Kuai <yukuai1@huaweicloud.com>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, yukuai3@huawei.com, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Mon, 29 Aug 2022 10:22:36 +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Changes in v9:
>  - renaming the flag BIO_THROTTLED to BIO_BPS_THROTTLED, and always
>  apply iops limit in path 1;
>  - add tag for patch 4
> Changes in v8:
>  - use a new solution in patch 1
>  - move cleanups to a separate patchset
>  - rename bytes/io_skipped to carryover_bytes/ios in patch 4
> Changes in v7:
>  - add patch 5 to improve handling of re-entered bio for bps limit
>  - as suggested by Tejun, add some comments
>  - sdd some Acked tag by Tejun
> Changes in v6:
>  - rename parameter in patch 3
>  - add comments and reviewed tag for patch 4
> Changes in v5:
>  - add comments in patch 4
>  - clear bytes/io_skipped in throtl_start_new_slice_with_credit() in
>  patch 4
>  - and cleanup patches 5-8
> Changes in v4:
>  - add reviewed-by tag for patch 1
>  - add patch 2,3
>  - use a different way to fix io hung in patch 4
> Changes in v3:
>  - fix a check in patch 1
>  - fix link err in patch 2 on 32-bit platform
>  - handle overflow in patch 2
> Changes in v2:
>  - use a new solution suggested by Ming
>  - change the title of patch 1
>  - add patch 2
> 
> [...]

Applied, thanks!

[1/4] blk-throttle: fix that io throttle can only work for single bio
      commit: 320fb0f91e55ba248d4bad106b408e59099cfa89
[2/4] blk-throttle: prevent overflow while calculating wait time
      commit: 8d6bbaada2e0a65f9012ac4c2506460160e7237a
[3/4] blk-throttle: factor out code to calculate ios/bytes_allowed
      commit: 681cd46fff8cd81e387747c7850f2e730d3e0b74
[4/4] blk-throttle: fix io hung due to configuration updates
      commit: a880ae93e5b5bb5d8d5500077a391e3f5ec7715c

Best regards,
-- 
Jens Axboe


