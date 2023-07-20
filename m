From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-iocost: skip empty flush bio in iocost
Date: Thu, 20 Jul 2023 09:59:37 -1000
Message-ID: <ZLmSKdW5wTx0dAlz@slm.duckdns.org>
References: <20230720121441.1408522-1-chengming.zhou@linux.dev>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689883179; x=1690487979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tpeVGMhDTTLTNxyLLa2NKiBDsv0lT8EhjxwFV8Gr564=;
        b=EDWl9x9JvIOHXr/ppBs9v45am5RKoK6X0M5l44abzq0D1tr8D8PIkNwZeC/PqSi6WH
         YD3n+GNQRZy8Gi+yCC205qQi85U+E1oUyb8+RvY/JE0aMdjfi6epzsirkOam66+9jB/m
         99uSEzozms/v79GnfGNSXzCytVjnuX/RTCZk+xPaDB1GyaEHYuNCzL/WzDXXdwkAXcs5
         f2AiluX6q+j/emZ4IwVLbwa3tT6JqKJCrJX/ESblrMBLO5r/lr4GAKz/OD2fglW8t1le
         bWS6GchQrRTZ2Rzua3+4e5vDWdYHKGfITIh496bFSs13I2xEK3MjSbSkm1NZB5ARk4Tc
         jsQQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230720121441.1408522-1-chengming.zhou@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chengming.zhou@linux.dev
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, zhouchengming@bytedance.com

On Thu, Jul 20, 2023 at 08:14:41PM +0800, chengming.zhou@linux.dev wrote:
> From: Chengming Zhou <zhouchengming@bytedance.com>
> 
> The flush bio may have data, may have no data (empty flush), we couldn't
> calculate cost for empty flush bio. So we'd better just skip it for now.
> 
> Another side effect is that empty flush bio's bio_end_sector() is 0, cause
> iocg->cursor reset to 0, may break the cost calculation of other bios.
> 
> This isn't good enough, since flush bio still consume the device bandwidth,
> but flush request is special, can be merged randomly in the flush state
> machine, we don't know how to calculate cost for it for now.
> 
> Its completion time also has flaws, which may include the pre-flush or
> post-flush completion time, but I don't know if we need to fix that and
> how to fix it.
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

It's unlikely that this will change behaviors in an observable way in most
cases. That said, yeah, ignoring it in terms of cost calculation is likely
the better thing to do.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
