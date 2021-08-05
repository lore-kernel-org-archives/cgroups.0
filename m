From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] blk-iolatency: error out if blk_get_queue() failed in
 iolatency_set_limit()
Date: Thu, 5 Aug 2021 11:18:29 -0600
Message-ID: <cb9833b1-be92-1b52-86cb-a45a85b18c00@kernel.dk>
References: <20210805124645.543797-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TKSj5MEKQ1gY7W+Z56fm3tBU4l2c5F1+7f+LZW3AUsU=;
        b=zivu60W0yaKjYq5/hhB/huyMwFYdeelDeUjyL0qp3DD+0K7L/go4Z3nDl0GQRtFyKe
         qSffhuvA506oDOgV0MKV0n41Jw8Syhq6XEecfm1IbdfBP0KzK4IWHtg0AOT2wi6ty7ks
         r/YKE9peMteV//iWCIyEXvjfEQc/jOT15hwK2NWoIOlacGShn9+xkUWzJcmivGd1OYlr
         vYEvYjtgN2iVuP1QbzVGlHV1k3NspAppkSSujeiJLeTZdbu5hyyvSOEbrYz5Vt9wFZGH
         O5nIWgLxYXJ/D3yrdoWibTH4/G1yj58wW+ieQ47QA7drwpspMScYTkZhZpJttXBNfmgS
         d3dw==
In-Reply-To: <20210805124645.543797-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bo.liu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 8/5/21 6:46 AM, Yu Kuai wrote:
> If queue is dying while iolatency_set_limit() is in progress,
> blk_get_queue() won't increment the refcount of the queue. However,
> blk_put_queue() will still decrement the refcount later, which will
> cause the refcout to be unbalanced.
> 
> Thus error out in such case to fix the problem.

Applied, thanks.

-- 
Jens Axboe

