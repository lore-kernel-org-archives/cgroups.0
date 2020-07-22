From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 08/14] block: add helper macros for queue sysfs entries
Date: Wed, 22 Jul 2020 07:20:18 +0000
Message-ID: <SN4PR0401MB3598294D373946F23B521D0E9B790@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200722062552.212200-1-hch@lst.de>
 <20200722062552.212200-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595402421; x=1626938421;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=U27WCAy9zaAs2WpMTz5Jje4K6BBxzqY/xNd71Rc+jMSz84eYh2hEL6G1
   CdbLjgMfCYBzHGhEqOpJ9fs2wiVJv7oFF5VqG83SxSUvc50gznb0Y3pgh
   z8QjQR//V9sF92vWniIZp3Zrg8BPBlwkCYgVo8CT6kCuff8ROz3GxTaQb
   SRVwIpavnYh45iM5vQE0El771nB1T2Y+mryW2gMGp8vvfKKSLYCn6awBN
   LJbAksFUUVyq4m/bpcZMl6anWBweXDBxCrdztz+xNXJjHbX32iYrwfpxP
   9U2GPcaHWASzR6kDHsC+q+5UQaX+JEZtp2hQiWwbysmG0N903c3LxNPPn
   Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=w79m+DE0Oyhzvqtk/pHHEEuIOG0gT8Xc6tBM1l9FGRNCARQmr6Ckn3qPabYQnlmHJz5hlYWvkMprtfBvRmbws8BsL1mCcVdjZWHth1PH7bARfQtBjLR8JjsRPiwKz2eJWfy6EoP2jIDDR1DYFPQAt5DP8Te9Wz8SUyWchlV3QVM=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
