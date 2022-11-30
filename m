From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH -next v2 1/9] blk-iocost: cleanup ioc_qos_write() and
 ioc_cost_model_write()
Date: Wed, 30 Nov 2022 07:55:46 -0800
Message-ID: <Y4d9AjL6BMbVSoUG@infradead.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-2-linan122@huawei.com>
 <Y4d801NjwwT0voKA@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rtn/WXCw0wV01K8XKJePt3vHFYfBvU4R/AXIM98Ihms=; b=yy2TohvPNBWn7ruaJrvJfv1ER8
        c0+MmIgJ9iTduM3PrmJ7tMWyiH2RLQ9ghj0MuDl4zW86cCDoGwPfQn0XN1E4DPKfdWef28YgT5B2o
        TcYI4KPhL24HRpqiqLrMfPtKoqZqu/izKuxYY+3SwBwfHxZNGnwDLczaDg3epW0Trs61x/pHosxWF
        m524O23xHwHZt0xA+IqftNKK0n1BWYd6m2RIr9AIpXfOZ+kOvOw/FABKYSPtxNq+uy4TXAsg2hFs4
        z17t24bY4u6mCpQrHQJeJyQLf8ygi9YlMtaPrqLqpV44Z5flNOXgXwNU1rWBgzRppEyRhfFL7h5m1
        ap77dYLg==;
Content-Disposition: inline
In-Reply-To: <Y4d801NjwwT0voKA-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Nov 30, 2022 at 07:54:59AM -0800, Christoph Hellwig wrote:
> > +	ret = nbytes;
> 
> ret is an int which bytes is a size_t.  So we at least need a ssize_t
> instead for ret, and even that assumes nbytes never overflows a ssize_t.

A better way might be to initialize ret to 0 at declaration time and
then do

	if (ret)
		return ret;
	return nbytes;
