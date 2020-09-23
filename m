From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/13] bdi: initialize ->ra_pages and ->io_pages in
 bdi_init
Date: Wed, 23 Sep 2020 17:16:06 +0200
Message-ID: <20200923151606.GB16073@lst.de>
References: <20200921080734.452759-1-hch@lst.de> <20200921080734.452759-6-hch@lst.de> <20200922084954.GC16464@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200922084954.GC16464@quack2.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, David Sterba <dsterba@suse.com>

On Tue, Sep 22, 2020 at 10:49:54AM +0200, Jan Kara wrote:
> On Mon 21-09-20 10:07:26, Christoph Hellwig wrote:
> > Set up a readahead size by default, as very few users have a good
> > reason to change it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Acked-by: David Sterba <dsterba@suse.com> [btrfs]
> > Acked-by: Richard Weinberger <richard@nod.at> [ubifs, mtd]
> 
> The patch looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> I'd just prefer if the changelog explicitely mentioned that this patch
> results in enabling readahead for coda, ecryptfs, and orangefs... Just in
> case someone bisects some issue down to this patch :).

Ok, I've updated the changelog.
