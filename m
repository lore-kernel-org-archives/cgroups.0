From: Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 11/14] mm: use SWP_SYNCHRONOUS_IO more intelligently
Date: Tue, 28 Jul 2020 12:28:03 +0000
Message-ID: <DM5PR0401MB3591B4A5B0E425635B36F91F9B730@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200724073313.138789-1-hch@lst.de>
 <20200724073313.138789-12-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595939286; x=1627475286;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=qjOA8RTZVb+X0iac4xC+obbBOFt0cOWqOhApliMuxMLtsknbcjNlCR8b
   tM3gpqyVfubqVIPYSiuk5k2iqpnkcGws5rrz4Ek+boDLXCkh8fR26dGSW
   iaYOkHP8KWMAdT2hbcEEtOQbNdtPXWHYLNoZc0pv8NkPrDnq+xLfk8NdD
   uyjKCyi4M/1OAiUoT/DtNd1NB8PZwQXUBUO5eNGqjm0E7UNfIqhsenQDO
   jG0Fyr9LfFgqLHyobT12VgtiGqWCs8Exq531I9VEHYja36l/4b8ClkG1i
   PldVpFUq64usntm0sgOfuArmOCc8SR2yXXPWpLWfnsvs+iu+61NX8pHaA
   A==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=jOtw0/6rR7XvwFQtRyb6KYDcvRrJqYeZdpYuR8pcdLBAjiVLr2+0KVEiyY1+ErHdSKTnOTBHC6SQgUs1vq3X8HUeQfYDCPxDpxnPPMUuo16VHzfwCy5YLuw2tv4rpUEWPzeNdsAoSV2uJVmToVg6jvjejQBQ1Bskux5LqjnCXSM=
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn-Sjgp3cTcYWE@public.gmane.org>=0A=
