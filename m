From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RFC: sort out get_gendisk abuses
Date: Wed, 30 Sep 2020 12:17:42 -0400
Message-ID: <20200930161742.GF4441@mtj.duckdns.org>
References: <20200925161447.1486883-1-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W/Hkl9GFIJfxfeMpU//nmP4ISzumsOYvRtgWyW3bzsw=;
        b=Zu7583FLPnLVk2W7IwechryeUFMKXKRxYi4bjyon/ez2PDMjPBGoc6aa+yX8MxHF/y
         3RIPLiYOlIJfH6j8sXrnQusWZ9Q3bbhIG3+qO5bXXPWkRv/x6y7WegTM/ZD8uABw2Rno
         XfMCyau5o1G8eUlk3M0LmyRKActBQkotAm9D1VqTqTo3M0uBmFgOUuW6xPkW0XnJvFZT
         j3nIrng7UNU9LahUWLhownPwtqlVSwZKiKWyxGoj5mvoHIB2Pge3jrqUCoLQqpRbXXMu
         srw1PsL5fTzTMxrL8RXGq1Q9Zx58OEHZufZfJqZjT8FkOiSl767ULIUDx6h0VUSENXDA
         KMiw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200925161447.1486883-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Minho Ban <mhban-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Christoph.

On Fri, Sep 25, 2020 at 06:14:45PM +0200, Christoph Hellwig wrote:
> this series tries to remove two abuses of the get_gendisk API.
> The first one is fairly straigt forward and switched the blk-cgroup
> configuration API to properly open the block device, but I'd love to see
> it reviewed and tested by the cgroup maintainers, as I don't really know
> how this code is actually used.

I'm a bit worried that requiring fully opening the device for configuration
can lead to surprising behaviors. A now-unlikely but still possible case
would be trying to configure IO parameters for a device w/ removeable media.
All that the user is trying to do is configuring a bunch of parameters but
the kernel would try to spin up the media and fail configuration and so on.

The use case of needing to access the associated data structures without
fully activating the IO device seems valid to me. Whether that interface is
blkdev_get() or something better abstracted, I don't really care.

Thanks.

-- 
tejun
