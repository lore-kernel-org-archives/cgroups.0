From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] blk-throttle: Fix io statistics for cgroup v1
Date: Tue, 9 May 2023 05:41:11 -1000
Message-ID: <ZFppl9jJNqM_GCzS@slm.duckdns.org>
References: <20230507170631.89607-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683646873; x=1686238873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xoUKheuGGoabhTr4uxkvUyDn3oFM2xkZ0jYUH3Rrng4=;
        b=Ow/qrEULGpmS7Za4OSRrLz2ncagpT+asShIr6m0nwant11xFKyXBYpO+RwQf/W1mFu
         +NuKlfWc6F9T4yG/FCmVwB5ot7NGpmeLXck1fRW6X9+XMWYA2A1gHdjnQsxUQo56c5DJ
         J4oJBFuhlH4gf7g+c8fWNLF1NkO1pFxdsWN+21zuDPsBBuPAthKw9sZ1KkkczZB4TMWQ
         1qVOjubqM22LbqJFkW0IMkes2JgbA6O+F73KA8W7r788B/qIawJKANWGmTGhuqD3gp2J
         P8FoTbiMzDUziR3gxWvUjhCUYbL8F1zJM2WjCj/FCEuhwBVEMSiT8hdHi53i8Umq9ZGG
         OAbA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230507170631.89607-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org

On Mon, May 08, 2023 at 01:06:31AM +0800, Jinke Han wrote:
> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
> blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
> the only stable io stats interface of cgroup v1, and these statistics
> are done in the blk-throttle code. But the current code only counts the
> bios that are actually throttled. When the user does not add the throttle
> limit, the io stats for cgroup v1 has nothing. I fix it according to the
> statistical method of v2, and made it count all ios accurately.
> 
> Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")
> Tested-by: Andrea Righi <andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
