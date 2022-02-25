From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Fri, 25 Feb 2022 16:11:54 +0800
Message-ID: <YhiPSkMyGCRrvYbF@T590>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645776748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IxUmOZZyqoUQWApMFQlH+CPZD7GX9hUMYPLmlYmrURk=;
        b=S7zN7OWYU4zbaeEMYgMq83uGH8OZLULLhPTFb/PcYf+cDN8GNqdysR8H2/EKnGiZwlbtSm
        o2WB9/Y/0ojfG97TVyec24go2ppk8+8UTzEaEXfjh6YCPwG2AZ5vnEMbAuqOMEyd5OGO6d
        J6LVqGnKqi8jCfQfgXWsfXj3PNfxZj8=
Content-Disposition: inline
In-Reply-To: <20220210115637.1074927-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Thu, Feb 10, 2022 at 07:56:37PM +0800, Yu Kuai wrote:
> Throttled bios can't be issued after del_gendisk() is done, thus
> it's better to cancel them immediately rather than waiting for
> throttle is done.
> 
> For example, if user thread is throttled with low bps while it's
> issuing large io, and the device is deleted. The user thread will
> wait for a long time for io to return.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
> Changes in v9:
>  - some minor changes as suggested by Ming.

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

