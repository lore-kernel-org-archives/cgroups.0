From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3] blk-throtl: optimize IOPS throttle for large IO
 scenarios
Date: Mon, 9 Aug 2021 12:39:20 -1000
Message-ID: <YRGumHUfK5sJc4A/@mtj.duckdns.org>
References: <65869aaad05475797d63b4c3fed4f529febe3c26.1627876014.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+JExG4XECleL3z2Pr60SpUDE5nO3vODyjR9bd8Nc6kY=;
        b=EPq7r4vY5ue8A5iT753KqHjWSDHd03tLblaNLm/9jVWiWmyDqcrRYISFIKWpeS7f6M
         lK7en01wJBobFejcm4bXg/dPl+gkHFzVEZX4yMgHkQBDccJm5P4E3DOaQh9ehgCmKM9/
         GRBPR03vn7t/BavtMLfomKuotxZUt5ucD3RNYD/xLQzg19QQK6KjXRi+ShwIZQYf1FGF
         fJfQp0pFU4N+oKCiSMLLlxse2TrSItSRxiPuxcAd3gza7L1KhGGjfDS/bX/wO18Uu2ve
         T8CFLd9ALTvMOqkXjbraKedriHdXEqN4tDMnPidTiJad0NDo0nTN9IxcCaAY+db9y4nd
         Ezvw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <65869aaad05475797d63b4c3fed4f529febe3c26.1627876014.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn@gmail.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Aug 02, 2021 at 11:51:56AM +0800, brookxu wrote:
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
> 
> v3: Optimize the use of atomic variables.
> v2: Use atomic variables to solve synchronization problems.
> 
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
