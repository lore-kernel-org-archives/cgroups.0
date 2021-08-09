From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 2/5] block: pass a gendisk to blk_queue_update_readahead
Date: Mon, 9 Aug 2021 14:35:12 +0000
Message-ID: <PH0PR04MB741611133411D89D85F101029BF69@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210809141744.1203023-1-hch@lst.de>
 <20210809141744.1203023-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628519755; x=1660055755;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=BRMYlI9m1tfzQ20/njsrGJq+u5Krv1bxbma2/fdZYQWGaJ6LOrhgp89g
   PJhoJVORDTmXNFjQF61d7RT6AZkmRUP0JI/sgukXDcdA7fdpW3kRhcicd
   FGzDVtv/8gQMOyVdm+AK3hBHRbXbw4KLnDSOiwFOqTTnK6Vf6/rrd0e2B
   bAQsjpN+k1CuLDbxpleG7LhR3WfZkWR8xdZ0msOQwlE0z3N59uMDHBRmg
   2YjhnFPnvtmPR1SR92W4HLGZpdw/d0RrI3mJhj0dOjJwSmjBcZVJCkCp+
   MT8voivdp3fulq6jUo1NqxIZcsriAAJ2r16uF7RAQSUL75sgHBKtyMmHv
   w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=vUZK4k0Q6Y52VxJ72rg+espbxmwThyVD5bG7FyfrzKR/DrngogL695MMgEg/64ybkIaApLp6aJrMYBKDZTFJAVVlyd5YkTNzjKr3gTg0MQH/7z1ns+aWkRQQUDi1KS4Aa4QmVm9692GVMDjTEAFHNJ7w3WRTo/FyDCySxJ3rL1A=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
