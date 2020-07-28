From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 04/14] bdi: initialize ->ra_pages in bdi_init
Date: Tue, 28 Jul 2020 12:15:53 +0000
Message-ID: <DM5PR0401MB35912432EB080E02FB3AF7139B730@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200724073313.138789-1-hch@lst.de>
 <20200724073313.138789-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595938556; x=1627474556;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=qqnuwUkhj5XeGXEZcbHvOV/wszL4groR6zxEFAjxd6NcpQKyRHhst1uE
   fzXscWbdCxfVLIbakzV0r/ThhRG1sFSMgeS0D5YRx3YIEx76dIxSKBSTp
   BHPoW7EcAHdeIhFmL9OGxsy1x3s5JYYCf1e9t9FgXwCIXM5Lmeel8k0DA
   h/1z7wTNwZMseCcUVOCB9NdhpRVBzA5OoRy75mVmDTMAMbTxVe5fjkQRz
   uhHwaUJAY4zrGXsIRvp2DzZzUFdkNwOwel5R4gCWxhbfY5t83H2Si9e1h
   Mim9J+lMl1wKYNKPbsfztVSjUmYLABz7Xs2Ot+0tzWWqln0FxAtPWMcQz
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=tIOK7ueSH5DJwXOqwARPUiTahzpVsXyl/1RWj+14QL3pzTxu4BPLZlr3G/Q+MgEEvAzNVK+zeveMp1mwXv0Ei59sAcPers8B5dGX2+s5p+pp86oFafxyUUcHKhkzE6kspdrE3nojiQHFLRy7ky/yvdvL8crtFTQAQwAM4mxn/X0=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, David Sterba <dsterba@suse.com>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
