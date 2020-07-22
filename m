From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 04/14] bdi: initialize ->ra_pages in bdi_init
Date: Wed, 22 Jul 2020 13:15:43 +0200 (CEST)
Message-ID: <1212963412.160863.1595416543195.JavaMail.zimbra@nod.at>
References: <20200722062552.212200-1-hch@lst.de> <20200722062552.212200-5-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200722062552.212200-5-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: hch <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Minchan Kim <minchan@kernel.org>, linux-mtd <linux-mtd@lists.infradead.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, cgroups@vger.kernel.org

----- Urspr=C3=BCngliche Mail -----
> Set up a readahead size by default, as very few users have a good
> reason to change it.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> block/blk-core.c      | 1 -
> drivers/mtd/mtdcore.c | 1 +
> fs/9p/vfs_super.c     | 4 ++--
> fs/afs/super.c        | 1 -
> fs/btrfs/disk-io.c    | 1 -
> fs/fuse/inode.c       | 1 -
> fs/nfs/super.c        | 9 +--------
> fs/ubifs/super.c      | 1 +

For ubifs and mtd:

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
