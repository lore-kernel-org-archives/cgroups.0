From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: remove dead bdi congestion leftovers
Date: Wed, 1 Jul 2020 12:38:13 -0400
Message-ID: <20200701163813.GA5046@mtj.thefacebook.com>
References: <20200701090622.3354860-1-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tnWfjqu9qwTdD4KnQK/3+SjWTBx9SJibvmRRCZ2MKpw=;
        b=U026WByv7++7/w1+Nu+RBzmT42CWmL089oP2jZPE4GfX8trhuMpatdvHRasGwxl1tp
         esIRMJhHnW5uCzGbrrP5CE9k4nW7c65rE4KRI9NkWii4E6mEPbKGBXdTFeEP0b5/X8j1
         RKDZhhs7eEWkZ9yrTYjSzyRQuzgfxSGkKewuCj72VWynBsVS+2Ska24TaCYNSUtYNx0h
         tkr380dMygtpbEq4afb+a4dCf6bAwClROx8TUXDVt1XYAVILF8ZQdXine5RK1wrhdCLx
         lurHJt08cKi6hQMnrm0IC1VIZZ5Da6Y0NgMH3p1I2KbSxRTE3WPzEilFi6RtD7avMeW2
         +K0w==
Content-Disposition: inline
In-Reply-To: <20200701090622.3354860-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 01, 2020 at 11:06:18AM +0200, Christoph Hellwig wrote:
> Hi Jens,
> 
> we have a lot of bdi congestion related code that is left around without
> any use.  This series removes it in preparation of sorting out the bdi
> lifetime rules properly.

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks a lot for killing the dead code.

-- 
tejun
