From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 02/14] drbd: remove dead code in device_to_statistics
Date: Tue, 28 Jul 2020 12:14:37 +0000
Message-ID: <DM5PR0401MB3591189756D9F697C2AA7B2A9B730@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200724073313.138789-1-hch@lst.de>
 <20200724073313.138789-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595938479; x=1627474479;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=V54L3OTgPQl10S0ooLSFMa//GuMmXzcqZSE5NjpvqpMKx4WLrvFvfIxg
   580pH5WJkI2WIazOXPNVMTohL5B/AYMUfGRuBKjalcCl8P0h7e5WS/Bk7
   77QdZrsHrxioLwVpLSllSxviYXSz/swBMvNQTAA8o8yIZRlxE4X4EEn+j
   PaRr+dI+mhv0TH2TZGzuQyIZrBio5wGql8iTzKDV5/RBGDf3SDcQkN65y
   4gRLt8vbSfKr1qkuIVPOwn9r/1FSnaIvShahVH1eHHFI3GVTM6vILmfzO
   SOg9C6lCMesszwsUoq1S+i9uxslNSChCQW+4a1N6ylb8X6rpbEqdcl9Fl
   Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=HA2alPriwheUSnfwo/eXbvlTkwo+KYyp5QPbG7lElckKtcNxhE0QwY43ChrDf17Fu97DXtv1bFoIdSs7yx3I2YDWvDzvK82ivU2/7iFwmCIvybfCtYbnoO0XJKRTlAjDiUBR5wWBvnNzCH2QMAHEVhhi1B+QidqFQ4Ox4ODylrA=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
