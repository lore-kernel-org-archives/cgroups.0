From: Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 06/14] block: lift setting the readahead size into the
 block layer
Date: Wed, 22 Jul 2020 07:13:54 +0000
Message-ID: <SN4PR0401MB3598470B14C754768A2D8F389B790@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200722062552.212200-1-hch@lst.de>
 <20200722062552.212200-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595402055; x=1626938055;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=eDgXJDrRcHBdx/h+ukaTHEZJ1bIcCGUbvV+Qo/Lb7u8=;
  b=goq7SPTtVHeSbOVnRlL+laylnxLxmkk4dDiwJQ20ue23IazJ2QHanXQT
   ZLtEfqq5l2O3uxrCfBFonee43UnUlN0PR3uBfx8XpPkUGSkfdDeztJEiO
   M2Ew1MnJP6z75LMKxammYjTo/GiwOSnZtjvWaiGr8NucYMqp+bhx7LecO
   +ZM+zSEGD1/0w+AODrglYuRcqsETZbjD4rNFXuZcEvSU2gDP6rIyUf+0K
   d7/n0RL4DUzXXG+FyTyL3b1aNy/43uo+O4UINWONDgF4gAr0L74PEzFfg
   OU/CR1lOBFfu6SzddCuEY8gPGlTdT8HmD3BJcnJITVFDYnoNZL4SnlWf/
   Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=poiwM82pTnOPiJnHxVcFkqqb2XVkaMdwQOlgju+7S0g=;
 b=fb6snm4DA8NLZm2oGpMp7J/pm7U2fsnXO6PhYWFCFyVRMrh4KmYwDa9mImLx30Ku8pISeP92XEpKj9pvTA/e5uWUSC75GEKjgviQcA7HLvtTafGxQYc/BTaJeuseq+lE0ne5eq4E+N03ryf9wqb6RSyAR98yw+Q4IWKCPCKmNuY=
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 22/07/2020 08:27, Christoph Hellwig wrote:=0A=
> +	q->backing_dev_info->ra_pages =3D=0A=
> +		max(queue_io_opt(q) * 2 / PAGE_SIZE, VM_READAHEAD_PAGES);=0A=
=0A=
Dumb question, wouldn't a '>> PAGE_SHIFT' be better instead of a potentiall=
y =0A=
costly division?=0A=
=0A=
Or aren't we caring at all as it's a) not in the fast-path and b) compilers=
 =0A=
can optimize it to a shift?=0A=
