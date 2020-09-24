From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/13] md: update the optimal I/O size on reshape
Date: Thu, 24 Sep 2020 11:53:29 -0400
Message-ID: <yq14knnmary.fsf@ca-mkp.ca.oracle.com>
References: <20200924065140.726436-1-hch@lst.de>
        <20200924065140.726436-7-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=UMrMiRKAEPKCu9R5h0OHmuj7H7bYXllgz/FgByZzp54=;
 b=T23KGyNF55FmeyEYsQIu8ZzQNzqjPTGYsLmWI3bkv0r1GL5atH3ncE7JDgQd4HihRJzp
 QcXkEtynE/j4e7hdpiRmuuN9Wfa4O5VtR4laQ3ogMVmsknED5KP7+keU7mxoZufVXf1p
 vupa7e47pocKxfg5d/WdxS4i4zOD96hQpjigPNoOtDtZoVSc1E2jaQgTWxLPyvyuljab
 8viY6PkrX30EnaiWLFiWM6plVeDJdSxcphzm3dSP+sICJGE6YZNKiRoGninjfOdUhCHl
 ZiUOJy3a3UUEoX+OaO4U+4UF5Mrbzz4A351PGKMWyUj25dUz/2aKHnUle95g3uMZhOJv eQ== 
In-Reply-To: <20200924065140.726436-7-hch-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig's message
        of "Thu, 24 Sep 2020 08:51:33 +0200")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>, Justin Sanders <justin-kFqnmIA2sJXQT0dZR+AlfA@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-/sHSiTBGKwq//tTphpj/8g@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Christoph,

> The raid5 and raid10 drivers currently update the read-ahead size, but
> not the optimal I/O size on reshape.  To prepare for deriving the
> read-ahead size from the optimal I/O size make sure it is updated as
> well.

Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Martin K. Petersen	Oracle Linux Engineering
