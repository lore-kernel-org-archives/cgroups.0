From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] blk-throtl: optimize IOPS throttle for large IO
 scenarios
Date: Sat, 14 Aug 2021 19:14:37 -0600
Message-ID: <53196a1f-9fdc-269d-801b-ce1ff2963cb0@kernel.dk>
References: <65869aaad05475797d63b4c3fed4f529febe3c26.1627876014.git.brookxu@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x2b3137Hg3O35wl4KvAg3fkN/4EPjZhVIIFocKDpOzw=;
        b=JNP1gkSDmAye92b824CW/SUEX+EdwwaqZtDqtnkJAUmkDBHjTHWSIsBYNlIXQxvqR1
         XYt2ztX4SxZcsvu1LwvlEZKlL0f84LHRTyNUYRg5hfqTLTt8MDuCIoRdZ/diOGS2zvrV
         vcX4KXpOItr26LiTEAMxsjoDzStZ1sE+BvhUhEblVe92CKn7WnJFf1VDJc8QaH9DMnkc
         wMNYXBeQeE020Q2qe+xZXJYzhou1sIJ2mrWoXjqNSXTDoxtKOhDtH4UmPW98ZFjTbvOS
         L/KLNSVZ72TBI3xSYdZnf3/IcyWwpZeIxzRFXyPSXOHUbEDE5mLyKwm3Gixuy2HUgfVb
         k14w==
In-Reply-To: <65869aaad05475797d63b4c3fed4f529febe3c26.1627876014.git.brookxu@tencent.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: brookxu <brookxu.cn@gmail.com>, tj@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 8/1/21 9:51 PM, brookxu wrote:
> From: Chunguang Xu <brookxu@tencent.com>
> 
> After patch 54efd50 (block: make generic_make_request handle
> arbitrarily sized bios), the IO through io-throttle may be larger,
> and these IOs may be further split into more small IOs. However,
> IOPS throttle does not seem to be aware of this change, which
> makes the calculation of IOPS of large IOs incomplete, resulting
> in disk-side IOPS that does not meet expectations. Maybe we should
> fix this problem.
> 
> We can reproduce it by set max_sectors_kb of disk to 128, set
> blkio.write_iops_throttle to 100, run a dd instance inside blkio
> and use iostat to watch IOPS:
> 
> dd if=/dev/zero of=/dev/sdb bs=1M count=1000 oflag=direct
> 
> As a result, without this change the average IOPS is 1995, with
> this change the IOPS is 98.

Applied for 5.15, thanks.

> v3: Optimize the use of atomic variables.
> v2: Use atomic variables to solve synchronization problems.

Just a note for the future, changelog stuff goes below the ---
line.

-- 
Jens Axboe

