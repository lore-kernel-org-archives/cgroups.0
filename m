From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/14] block: lift setting the readahead size
 into the block layer
Date: Wed, 2 Sep 2020 17:11:44 +0200
Message-ID: <20200902151144.GA1738@lst.de>
References: <20200726150333.305527-1-hch@lst.de>
	<20200726150333.305527-7-hch@lst.de>
	<20200826220737.GA25613@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200826220737.GA25613@redhat.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, martin.petersen@oracle.com, Hans de Goede <hdegoede@redhat.com>, Song Liu <song@kernel.org>, Richard Weinberger <richard@nod.at>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Minchan Kim <minchan@kernel.org>, dm-devel@redhat.com, linux-mtd@lists.infradead.org, linux-mm@kvack.org, drbd-dev@tron.linbit.com, cgroups@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Aug 26, 2020 at 06:07:38PM -0400, Mike Snitzer wrote:
> On Sun, Jul 26 2020 at 11:03am -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Drivers shouldn't really mess with the readahead size, as that is a VM
> > concept.  Instead set it based on the optimal I/O size by lifting the
> > algorithm from the md driver when registering the disk.  Also set
> > bdi->io_pages there as well by applying the same scheme based on
> > max_sectors.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  block/blk-settings.c         |  5 ++---
> >  block/blk-sysfs.c            |  1 -
> >  block/genhd.c                | 13 +++++++++++--
> >  drivers/block/aoe/aoeblk.c   |  2 --
> >  drivers/block/drbd/drbd_nl.c | 12 +-----------
> >  drivers/md/bcache/super.c    |  4 ----
> >  drivers/md/dm-table.c        |  3 ---
> >  drivers/md/raid0.c           | 16 ----------------
> >  drivers/md/raid10.c          | 24 +-----------------------
> >  drivers/md/raid5.c           | 13 +------------
> >  10 files changed, 16 insertions(+), 77 deletions(-)
> 
> 
> In general these changes need a solid audit relative to stacking
> drivers.  That is, the limits stacking methods (blk_stack_limits)
> vs lower level allocation methods (__device_add_disk).
> 
> You optimized for lowlevel __device_add_disk establishing the bdi's
> ra_pages and io_pages.  That is at the beginning of disk allocation,
> well before any build up of stacking driver's queue_io_opt() -- which
> was previously done in disk_stack_limits or driver specific methods
> (e.g. dm_table_set_restrictions) that are called _after_ all the limits
> stacking occurs.
> 
> By inverting the setting of the bdi's ra_pages and io_pages to be done
> so early in __device_add_disk it'll break properly setting these values
> for at least DM afaict.

ra_pages never got inherited by stacking drivers, check it by modifying
it on an underlying device and then creating a trivial dm or md one.
And I think that is a good thing - in general we shouldn't really mess
with this thing from drivers if we can avoid it.  I've kept the legacy
aoe and md parity raid cases, out of which the first looks pretty weird
and the md one at least remotely sensible.

->io_pages is still inherited in disk_stack_limits, just like before
so no change either.
