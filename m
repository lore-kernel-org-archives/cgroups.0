From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] blk-throttle: enable io throttle for root in
 cgroup v2
Date: Tue, 1 Feb 2022 07:20:32 -1000
Message-ID: <Yflr4FzUTWsiLTC/@slm.duckdns.org>
References: <20220114093000.3323470-1-yukuai3@huawei.com>
 <YfGE9L4i7DtNTo08@slm.duckdns.org>
 <235b0757-d322-2b6e-3ab6-ecc8c82f8f1e@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P/OM7TjxmbJXWO65CCc5u6gW1j1hf5TT48SuvRQUGM4=;
        b=Th2pE7IdvVAvL27K0Qf/WfMwKXepCYHz0caGuE/hHj2a/Cnls+2LvQk4pd0hPSsVmc
         /P6uhuhZiLl+17CpwiopYhBR/qCtJBVssgTbQdYnIISNQERS2GZ14qq/Hg7eUUCaN674
         VCwtBPI4DwClaYXcyxJN+XKveP7T7CfMg5ljyW3+GK7dyKLOmA8hFBXrPEcKThr76/Z1
         McM98ys2DJwA4II8akyGsTpeN9bHmMtE68PaVABB+oTwu+4yN2ONkyGt3QHviGejnNXf
         7GgXGq04oayAGMEjV9a1B4yP0UFh2KbtUdz2IDGrTo7ZtGrKniUuXyFMvj/ITBpXNTId
         pHiQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <235b0757-d322-2b6e-3ab6-ecc8c82f8f1e-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello,

On Thu, Jan 27, 2022 at 10:36:38AM +0800, yukuai (C) wrote:
> In our case, the disk is provided by server, and such disk can be shared
> by multipul clients. Thus for the client side, the server is a higher
> level parent.
> 
> Theoretically, limit the io from server for each client is feasible,
> however, the main reason we don't want to do this is the following
> shortcoming:
> 
> client can still send io to server unlimited, we can just limit the
> amount of io that can complete from server, which might cause too much
> pressure on the server side.

I don't quite follow the "send io to server unlimited" part. Doesn't that
get limited by available number of requests? ie. if the server throttles,
the in-flight requests will take longer to complete which exhausts the
available requests and thus slows down the client. That's how it's supposed
to work on the local machine too.

Thanks.

-- 
tejun
