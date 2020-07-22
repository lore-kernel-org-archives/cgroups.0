From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 09/14] bdi: remove BDI_CAP_CGROUP_WRITEBACK
Date: Wed, 22 Jul 2020 07:45:24 +0000
Message-ID: <SN4PR0401MB35988BC2003CCDFC7CE8258F9B790@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200722062552.212200-1-hch@lst.de>
 <20200722062552.212200-10-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595403929; x=1626939929;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=2dYsmetetAQjGFOstq75gNTdBHAVPGPd6z19LIgcbAs=;
  b=AX+FqyFP42cvLdAwluqAh6NJ4NC9KumH6E5bwT2Do6gs35PIRX44z/fp
   rHFo2N6mcQ1c9TpzbPJnMdS+/vIJPdezH9ELCuoQbWM294ewrU8AOjrP8
   srit02Vsv9yJozycvqVfww6wx3N7vg96O8YIpaZFpmwUhas0cCikpzLPl
   vnWUkEHDsIkE2QkALziB/UmqluvTEmFinO0589aqYSgjB3I8CtrBASTJd
   NvmFfHrauXPZYvKdzj46zQj1yhGETqXX/v1O6JtW3FAqPnoHkRTA3DD+j
   M6Jjx36GZHmQq2ICEBhny7PJiCjdazGU/sefV3bD6u/70D8ASJ3W4dsBc
   Q==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0K5mJznmfxjwY39VW0JeYpFKeILGV3n8VhABZp5fF0=;
 b=a/9R+n5BrdGnFvHmK72vVSTNqZyTcUh2/W/H5HRXaBYZJJFj6fag2W8sUdt+D1wg8YbLPwkfmtSwkPd6qAfXsxozzx/9GJcww1xDIA9SHpfliZe3w2opM2huZfYgSW77aFyzYlj43Q6qS1FVjdu8ZM81iim5HkVQKJqFQRyTIDc=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

On 22/07/2020 08:27, Christoph Hellwig wrote:=0A=
> it is know to support cgroup writeback, or the bdi comes from the block=
=0A=
knwon  ~^=0A=
=0A=
Apart from that,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
