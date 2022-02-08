From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] blk-throttle: enable io throttle for root in
 cgroup v2
Date: Tue, 8 Feb 2022 08:49:11 -1000
Message-ID: <YgK7J8TFyFvp/rv1@slm.duckdns.org>
References: <20220114093000.3323470-1-yukuai3@huawei.com>
 <YfGE9L4i7DtNTo08@slm.duckdns.org>
 <235b0757-d322-2b6e-3ab6-ecc8c82f8f1e@huawei.com>
 <Yflr4FzUTWsiLTC/@slm.duckdns.org>
 <32b6949d-60b1-82ce-ae44-1cf089a78276@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HzqJzWy6/gVejSAN5h5m+QbHqL8I+Ih3BBbS9yeEwMQ=;
        b=N4MKN8A1dy9x/0fQ3O5ZkWlr8CY4zUnafoD5iZJ2GzR2vHrPtZ9c3Augj8QVTK/AOB
         6/Q0T9TxM0VSWHm37lP2a4E0TiBrzrW1EhYPumJszYBdF7eUpgZwahZdkzXGgG8+uijN
         EmyFn0npWdJy1OTjwf8aZ/+9k7emBiOHVNUqPcClPbMfn2VqEkoBj+u0tEthGor79MHU
         Q+YzcmqT/YYt5W56qTcPGLmXCR1cUCzJMQ48WnZQUTxPcgO02slV04kbISsKtoFvVS58
         LCwvTK7xcTi0/LT7PubbSs8+5waC1a9C1PTTqMm+3ZHp1Zz7rUdlBA27X4l7qSY3SA+s
         X3fw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32b6949d-60b1-82ce-ae44-1cf089a78276-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello,

On Tue, Feb 08, 2022 at 09:38:33AM +0800, yukuai (C) wrote:
> 3) If we limit iops to 8 for each client from server, client should work
> fine, however, server can receive 64 x 8 = 512 io at most at the same
> time, which might cause too much pressure on the server.(maybe bps is
> more appropriate to explain the high pressure).

I don't follow this part. Why can't the server control however it wanna
control?

Thanks.

-- 
tejun
