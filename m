From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 01/14] fs: remove the unused SB_I_MULTIROOT flag
Date: Wed, 22 Jul 2020 06:54:53 +0000
Message-ID: <SN4PR0401MB35987802444E56DED8C7962E9B790@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200722062552.212200-1-hch@lst.de>
 <20200722062552.212200-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595400896; x=1626936896;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Mf/HAZi0hlQyHsOJAqRX4fByTFGCVEgXSRxQNGkmG0E=;
  b=YZBnyVelQnCf2VdM/ibzzugOe6YGpyWFlLGCuiuyUoLC3U2dgCd0xxmd
   9gSpSXT7Xv0K4BpiyiHJhUeEFImqV2MXqZ8bjJK80PcbLb0iZ1zrbjeou
   UXijPtUhe5/AQ2IWGOL9eZIra8LPj459k8WrhYV+u6ugMC16t2+62Vp02
   uSgYSskXVTiV+C6s8F97JIpuATGYJicSF1bihUIjGl9khwEHj+hJmq/hI
   VQgKjFIHPCwR28cBZcF6XdAyO4te367xKRCnKGiIZGiIGJxVWe6pupTuP
   DVI2cMdSsVgtqAwGzk8iZrLquPBq+sg9vvvtiZUVGhZoPWz62VHTh5qQa
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mf/HAZi0hlQyHsOJAqRX4fByTFGCVEgXSRxQNGkmG0E=;
 b=QV3tPH/FPauDbK+X0qyj938TZfVsJ3/YspaKqvUsEdMLbFERNXcGvbMk5Yr4rE1QRaW16Slk42OKw6CsTqtpmj4YugRxktCE8CpA6J4ChqzNNm7SkxoCwpS3AWYKrMP07+T7XHWBPlJTo3euNzbkNxPlylW13zYSYe1VeMxXDw0=
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

A little bit of git archeology shows the last user of SB_I_MULTIROOT is gon=
e with=0A=
f2aedb713c28 ("NFS: Add fs_context support.")=0A=
=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
