From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 07/14] block: make QUEUE_SYSFS_BIT_FNS a little more
 useful
Date: Wed, 22 Jul 2020 07:17:44 +0000
Message-ID: <SN4PR0401MB35982D3B04730EA1CA45A25B9B790@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200722062552.212200-1-hch@lst.de>
 <20200722062552.212200-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595402267; x=1626938267;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=CU4Mh6G0qUMYXHrfuwNltXjKo7cJNsxwkf+iqpzg+5PPeO6A8PySc4xX
   WizRF2JFyk864Xe+AEpuTntvHluJB1Tpx/1m3MLyFlXQ5eia5ePzHuNN2
   Gwb1rrVZ5p0xxZifvyL6slJC5h/t32kGvbvUXPhiwkYpXAmx4lrhi1JtF
   3t1jg/yGvwXMgjwg+oD+L8eNVPVOPpdYXXg9FPE5PihPUUTfvhHfAH+2m
   XnTqpx9/XcjjiHV7QytNYJB4HgMkAOG+HhpX049E9m9CHduKnyINKgt0a
   K7biFOejHZs7Piia9VGHSl/Mw3KIF90DrUrkf0W9OKkv5uLd9NHVNmj7/
   Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=K5/9gm/AkZ9wwFW9t5Ed7sD7PdXzwP1H7ZzL2I4V/HOo3cgqQ/SxzN/U/n4FfHAh6LmzQudUR2e84h0IKd4GV8roPape/8a1Zj2HABfmXQYaw5uC2GRuTrLSNXKWnAtyIpYPl4BiB69Pc12rqbC/Hb3aGUeSf+BXjyFBqH+fa6Y=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
