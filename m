From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 02/14] drbd: remove dead code in device_to_statistics
Date: Wed, 22 Jul 2020 07:03:21 +0000
Message-ID: <SN4PR0401MB3598495DA5AF46CAF019BDC69B790@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200722062552.212200-1-hch@lst.de>
 <20200722062552.212200-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595401408; x=1626937408;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ZqCO4R8P2m+FkHvzzK+0WLPWNYU1gTTyLCkQh9L/ClY=;
  b=FV9iWlFrsaGdJQ+IfJO3N6bQq0NfcCJ3eGSNHy3bLlmecJ3reGShP4x8
   A7JDOEXxOtlae+OmccsRPACCcBcAI2p1xKQlSz7q7NKxmc7Xg6TiVDnhg
   IFSIphJJDOqLLqPIGjjJo4InUHsls+8MtbPTmjAz+SdHo26JTS5GTOvPs
   hWyrc6kk9Y9C2Mu4At9IZkod/+3svYq90FrvxwoeUYLmsaLAq/6qxCrSF
   gsEeyJATwXjAv7RU//UkLkJxURCE8AkSujMhrYUBVb6c6eR4jwxeqsq9K
   WBvL/bg9TXOl0qaayCiRMA73ed1Cj4zSA7t4LyOKFdAd0fYr4NjulnhMM
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yNciJ0MaHm33mYwu8p1ho4mWYWj3E5JhuQT3rAgcYw=;
 b=riN3AATdn2VdnUvTtx+Jxsa8oOVx2L47gR+4ErUs73lb/BQkjxGpdrh3G5/19MNGVR5G3IVbBiEUPge+wCVtYtBmNkGYpjsth1C6XV423KU8zY3ZrxAJiKesB3ytaQpnlI1qITX/MR66s1WobqyWp/TJciC7t/XRpAnnQCV9+SQ=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

On 22/07/2020 08:28, Christoph Hellwig wrote:=0A=
> Ever since the switch to blk-mq, a lower device not use by VM=0A=
                                           in-use/used? ~^=0A=
=0A=
Also this looks like the last user of 'dev_lower_blocked' so it could=0A=
be removed from device_statistics if it's not an ABI (not sure with this=0A=
netlink stuff).=0A=
