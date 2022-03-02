From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH -next v2] blk-throttle: Set BIO_THROTTLED when bio has
 been throttled
Date: Wed, 2 Mar 2022 21:51:13 +0800
Message-ID: <Yh92UQ9/bxe6EcWe@T590>
References: <20220301123919.2381579-1-qiulaibin@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646229088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uztNbkycVorcCm23CCSPPERhmYpoYyhrF08z8BpZsMg=;
        b=anb6/UmiHK5LDhBYCBy81XyHLtUE3P4oWlGshTZ6I4k7fW1VWhX+xy2IA569rYnbNldC87
        oW7SieWQyeLXPKQ/7EUxTkPGrMSCYVUzCtyjygWoRHnZhwbWu+AWx2fKCuzMTgZcL0b+1b
        uvnPN3vn6CejiLHQb4vb0fyouApTDIE=
Content-Disposition: inline
In-Reply-To: <20220301123919.2381579-1-qiulaibin@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Laibin Qiu <qiulaibin@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Mar 01, 2022 at 08:39:19PM +0800, Laibin Qiu wrote:
> 1.In current process, all bio will set the BIO_THROTTLED flag
> after __blk_throtl_bio().
> 
> 2.If bio needs to be throttled, it will start the timer and
> stop submit bio directly. Bio will submit in
> blk_throtl_dispatch_work_fn() when the timer expires.But in
> the current process, if bio is throttled. The BIO_THROTTLED
> will be set to bio after timer start. If the bio has been
> completed, it may cause use-after-free blow.
> 
> BUG: KASAN: use-after-free in blk_throtl_bio+0x12f0/0x2c70
> Read of size 2 at addr ffff88801b8902d4 by task fio/26380

After the queue lock is released, the bio can be dispatched & completed,
so it shouldn't be touched after lock release:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

