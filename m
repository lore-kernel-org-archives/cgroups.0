From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/13] bcache: inherit the optimal I/O size
Date: Thu, 24 Sep 2020 11:49:48 -0400
Message-ID: <yq1ft77maz5.fsf@ca-mkp.ca.oracle.com>
References: <20200924065140.726436-1-hch@lst.de>
        <20200924065140.726436-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=vn1696U5CRhKmLmc6mdwCozBnLCLObO7LgftVl1wh2o=;
 b=jGpN8isNZtCM5z7nsb1wBtRcRov8B0bLS4Y8Jgq8H3hJMgkHBgpw+B0j+n0iQtU6oW4a
 QX84oMRfxrda29DxxN+D1WO6Juo95LBcan1pWECxN045bzOeYSFit8QXthhoJDaQRbnU
 seFTga76zsuEvub1vBYax7ppb/U+L6mAumw2Mhgx2mEcIYPYMg5hWrJvCiudE1KCKong
 6dgAASGoNxvU+gi3A53HQylRFymVIzYtV5b4NqtIoeyAAlCFpl+JO5CMpcTFKUHNrPPx
 wq25IEd46NnTfcYJ10+Cju65COp21F54g/3/Y9TEogN0+CpBlb7kUPWjmg4Oti/cRVCh Lw== 
In-Reply-To: <20200924065140.726436-4-hch-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig's message
        of "Thu, 24 Sep 2020 08:51:30 +0200")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>, Justin Sanders <justin-kFqnmIA2sJXQT0dZR+AlfA@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-/sHSiTBGKwq//tTphpj/8g@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>


Christoph,

> Inherit the optimal I/O size setting just like the readahead window,
> as any reason to do larger I/O does not apply to just readahead.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Martin K. Petersen	Oracle Linux Engineering
