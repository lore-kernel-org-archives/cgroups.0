From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/8] Some improvements for blk throttle
Date: Thu, 8 Oct 2020 08:02:06 -0600
Message-ID: <b54c6741-10dc-2768-bc37-f1965672f039@kernel.dk>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+v0FBMBQHdikeISvOs9/H6RdJVjsvgJipGvlxdEATrw=;
        b=OtjKLWoNFnJwBG+iIBsnfGAFJ4zdt7leYN6+IZMnSqbHnvoXh5fOLZV1t5S4zHKUK+
         KlLNhwQDcsdOJ+V6LCgAsTRNBvCb+hz8mhghFlo0yiw4O2KRm4ZtDM9yfQnRV0uSBSer
         C9/7OPQObbekrl9Gh4aVoZUyL5YHShCtmwpHSrZO3WnByHNC2KioGmRAmwwGQnvmB2VT
         zZjChPKRCnH8sXBxdxwX+sVzpfg5961ZI6KZIqRSaKXhs2v0NxRWX9XSl4VdF3M1eOP6
         09lAFvYNw26lHxgYb/xSqunH/NmCfM9e73cUCb7zv4dadb8bBohqNr3EeFusZoM46jjQ
         DEPA==
In-Reply-To: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Baolin Wang <baolin.wang@linux.alibaba.com>, tj@kernel.org
Cc: baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/7/20 9:52 PM, Baolin Wang wrote:
> Hi,
> 
> This patch set did some improvements for blk throttle, please
> help to review. Thanks.
> 
> Changes from v1:
>  - Add another 4 new patches in this patch set.
> 
> Baolin Wang (8):
>   blk-throttle: Remove a meaningless parameter for
>     throtl_downgrade_state()
>   blk-throttle: Avoid getting the current time if tg->last_finish_time
>     is 0
>   blk-throttle: Avoid tracking latency if low limit is invalid
>   blk-throttle: Fix IO hang for a corner case
>   blk-throttle: Move the list operation after list validation
>   blk-throttle: Move service tree validation out of the
>     throtl_rb_first()
>   blk-throttle: Open code __throtl_de/enqueue_tg()
>   blk-throttle: Re-use the throtl_set_slice_end()
> 
>  block/blk-throttle.c | 69 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 35 insertions(+), 34 deletions(-)

LGTM, applied, thanks.

-- 
Jens Axboe

