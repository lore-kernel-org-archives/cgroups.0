From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/13] aoe: set an optimal I/O size
Date: Thu, 24 Sep 2020 11:51:24 -0400
Message-ID: <yq1a6xfmawt.fsf@ca-mkp.ca.oracle.com>
References: <20200924065140.726436-1-hch@lst.de>
        <20200924065140.726436-5-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=vPj5HUHK1sveLhinkO2rrNMbTgOHpcSG/Qgh39xMlGk=;
 b=iehH+OvnhOP4xunxBiWDwJl2tVgSMeneguI6LEzqTnboYBhn8AWWBseqRFc2zq4/m/54
 UM+ayvNJBXUE5JNyPGLXukWuHVDQ3qORJtdLN6KbwjrxzyKY/4SZ38VTgsp7dAIkY5C6
 /LZP39sv5Pjdf0lTAVJshlT4T1LAnFsUBQZJQjzjVHRjToI6kufzXjzanL70Oz/adSHN
 cDwdxQRR9mh0SKHTJJYf9LtsYKFLHJfwIanK0JUt72ao9w6ZBvcldPmXJdRp2HyjX1/J
 ZEp31Gk93HSQgvp17OAVeX358nlEJN4npJyl3CkR8O3iIQj08lUWyf0+zMdcBbAQV4bx Lw== 
In-Reply-To: <20200924065140.726436-5-hch-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig's message
        of "Thu, 24 Sep 2020 08:51:31 +0200")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>, Justin Sanders <justin-kFqnmIA2sJXQT0dZR+AlfA@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-/sHSiTBGKwq//tTphpj/8g@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>


Christoph,

> aoe forces a larger readahead size, but any reason to do larger I/O is
> not limited to readahead.  Also set the optimal I/O size, and remove
> the local constants in favor of just using SZ_2G.

Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Martin K. Petersen	Oracle Linux Engineering
