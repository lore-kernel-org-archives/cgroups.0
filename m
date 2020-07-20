From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/14] bdi: initialize ->ra_pages in bdi_init
Date: Mon, 20 Jul 2020 14:07:34 +0200
Message-ID: <20200720120734.GA29061@lst.de>
References: <20200720075148.172156-1-hch@lst.de> <20200720075148.172156-5-hch@lst.de> <CAFLxGvxNHGEOrj6nKTtDeiU+Rx4xv_6asjSQYcFWXhk5m=1cBA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFLxGvxNHGEOrj6nKTtDeiU+Rx4xv_6asjSQYcFWXhk5m=1cBA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>

On Mon, Jul 20, 2020 at 01:58:22PM +0200, Richard Weinberger wrote:
> Hello Chrstoph,
> 
> On Mon, Jul 20, 2020 at 9:53 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Set up a readahead size by default.  This changes behavior for mtd,
> > ubifs, and vboxsf to actually enabled readahead, the lack of which
> > very much looks like an oversight.
> 
> UBIFS doesn't enable readahead on purpose, please see:
> http://www.linux-mtd.infradead.org/doc/ubifs.html#L_readahead

What about jffs2 and blk2mtd raw block devices?
