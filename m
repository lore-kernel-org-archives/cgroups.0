From: Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 02/14] drbd: remove dead code in device_to_statistics
Date: Wed, 22 Jul 2020 07:14:55 +0000
Message-ID: <SN4PR0401MB3598CBAC629556AA70E000CF9B790@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200722062552.212200-1-hch@lst.de>
 <20200722062552.212200-3-hch@lst.de>
 <SN4PR0401MB3598495DA5AF46CAF019BDC69B790@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200722070703.GA25590@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595402099; x=1626938099;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=0sTY9vMtHUqxctAYaAW2HR5t5lGYIpvoNy/R9HnUrqI=;
  b=B1slpBwKZ4iFuNw1ZS/JufeRaYwUZhxERxL1vBS2ykB0LuRt2YenGDJi
   F7BJaE5eAJPPVQ9ibwObt/7yufKwox3OEYEaOmcFt0Nv3XXdLYtmCR9AH
   7MQqV6PKU1YQw+sD8DAA+WNbbOH5ySiKrU0XlhExhTrfiudQGu5QibqH9
   aETtkjvgQL4vP3bKQbEWkW4YaReqW2eitDloDdSCWDlDk27yuo/g0GJcj
   TZ7k4kExAdYqmJOIfF+9HpEw4YFkDUlgWxy1qG8t2tlbAYC+ckaUIiozE
   pu460ZmiRT4Ufoi94HYv1HAViVbZAjis8XU+qqi4/YUS6/7UKQhKNRDbZ
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sTY9vMtHUqxctAYaAW2HR5t5lGYIpvoNy/R9HnUrqI=;
 b=q+Kitj/nvxZOwuDcHmNLboHS3yizg/9iwswsbyTYsOqNMv+neZhr8nQhFYtJfHDQ1fGSUtCULvINoox382lnBbr+f4xNb84n3olK1iO2FspP5aS7IbyxkJOQqKt/WBcKXCn2eradsdqvfxGdQnPdrlGvNbYveuBS5U+YdkrG/Bo=
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org" <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 22/07/2020 09:07, Christoph Hellwig wrote:=0A=
> As far as I can tell this is a netlink user ABI.=0A=
> =0A=
=0A=
I guess it has to stay then=0A=
