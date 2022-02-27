From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Sun, 27 Feb 2022 09:16:54 -0800
Message-ID: <YhuyBgZSS6m/Mwu6@infradead.org>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1+1W3bcZcWwdxZGt68XLVQsJDzEEa3DPMfJ+40hI5ZE=; b=Qmk+ArWtToMpl/lfeapZnRuA+i
        PrpP0ngA7XYmy9Gc6kV2P9n12jrrsV7XUBTZPhKniH/NRJt3xiLUsoQSQ+Ft50Cdcl6W0AOwA+Md5
        dC1WO3nZbABs3yFH5hL2CshbLWPfMlFmLXZqG78tLsnQ2fxKSF/2Ox84afzZCXbdfWT4VW8xUIkQI
        t/m/r7ViW2IaqOCXCC7ZY6Y7CUGw6J831FxUykxsBiYnBFwNAr0OzK+kqsTxY69VgvQ0hwZHWdsW7
        W6qFUCswdr+I2WSzWlPThBAJ9S1pEht19lBh0nZGUPujtoVBKBtTMr6mBKnDLxkby0ZjFP7t8BMmz
        IxzPFXzA==;
Content-Disposition: inline
In-Reply-To: <20220210115637.1074927-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Thu, Feb 10, 2022 at 07:56:37PM +0800, Yu Kuai wrote:
> Throttled bios can't be issued after del_gendisk() is done, thus
> it's better to cancel them immediately rather than waiting for
> throttle is done.
> 
> For example, if user thread is throttled with low bps while it's
> issuing large io, and the device is deleted. The user thread will
> wait for a long time for io to return.

FYI, this crashed left rigt and center when running xfstests with
traces pointing to throtl_pending_timer_fn.
