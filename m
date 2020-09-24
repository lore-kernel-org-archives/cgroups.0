From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 07/13] block: lift setting the readahead size into the
 block layer
Date: Thu, 24 Sep 2020 11:57:14 -0400
Message-ID: <yq1y2kzkw1h.fsf@ca-mkp.ca.oracle.com>
References: <20200924065140.726436-1-hch@lst.de>
        <20200924065140.726436-8-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=coGfpNEvHw1Ww6VMM3AUAr95WYwBGdMfGxQAq7Ut3Eo=;
 b=td1+RxKdoLOO2t63uF4zlGVrGlzNX/kncvf9CRu1+Q/Z185II6vOPY7OYVmR00lwbBvB
 oI39qsaxEsXuhrFRnhPNYadRAzid4vpFVH1DnNrCOUVZGKGLshblg06fbzYwGPztgdZo
 Z/fUTCgCP16jQ550PJt+VWDuquf6GdVURF+vw2dk3HUNxhFcamf3ZH2BVw0ZfMpJ+5yZ
 mxpIgUdAVm3QXDHsXihsvYimVL4XmoOEGm2cGgSqGvu3D9jELBR6iVkzSAWn9+LAYCfl
 ZfTFRr7HESquQPnKqBx6g1RyXHnWraO8Kxaud9pk648QpJJgQ9L9MM7dy9P+I69dS8p3 Iw== 
In-Reply-To: <20200924065140.726436-8-hch-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig's message
        of "Thu, 24 Sep 2020 08:51:34 +0200")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>, Justin Sanders <justin-kFqnmIA2sJXQT0dZR+AlfA@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-/sHSiTBGKwq//tTphpj/8g@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Christoph,

> Drivers shouldn't really mess with the readahead size, as that is a VM
> concept.  Instead set it based on the optimal I/O size by lifting the
> algorithm from the md driver when registering the disk.  Also set
> bdi->io_pages there as well by applying the same scheme based on
> max_sectors.  To ensure the limits work well for stacking drivers a
> new helper is added to update the readahead limits from the block
> limits, which is also called from disk_stack_limits.

Looks good!

Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Martin K. Petersen	Oracle Linux Engineering
