From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: remove dead bdi congestion leftovers
Date: Thu, 9 Jul 2020 16:01:45 +0200
Message-ID: <20200709140145.GA3068@lst.de>
References: <20200701090622.3354860-1-hch@lst.de> <b5d6df17-68af-d535-79e4-f95e16dd5632@kernel.dk> <20200709053233.GA3243@lst.de> <82e2785d-2091-1986-0014-3b7cea7cd0d8@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <82e2785d-2091-1986-0014-3b7cea7cd0d8-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 09, 2020 at 07:58:58AM -0600, Jens Axboe wrote:
> On 7/8/20 11:32 PM, Christoph Hellwig wrote:
> > On Wed, Jul 08, 2020 at 05:14:29PM -0600, Jens Axboe wrote:
> >> On 7/1/20 3:06 AM, Christoph Hellwig wrote:
> >>> Hi Jens,
> >>>
> >>> we have a lot of bdi congestion related code that is left around without
> >>> any use.  This series removes it in preparation of sorting out the bdi
> >>> lifetime rules properly.
> >>
> >> Please run series like this through a full compilation, for both this one
> >> and the previous series I had to fix up issues like this:
> >>
> >> drivers/md/bcache/request.c: In function ‘bch_cached_dev_request_init’:
> >> drivers/md/bcache/request.c:1233:18: warning: unused variable ‘g’ [-Wunused-variable]
> >>  1233 |  struct gendisk *g = dc->disk.disk;
> >>       |                  ^
> >> drivers/md/bcache/request.c: In function ‘bch_flash_dev_request_init’:
> >> drivers/md/bcache/request.c:1320:18: warning: unused variable ‘g’ [-Wunused-variable]
> >>  1320 |  struct gendisk *g = d->disk;
> >>       |                  ^
> >>
> >> Did the same here, applied it.
> > 
> > And just like the previous one I did, and the compiler did not complain.
> > There must be something about certain gcc versions not warning about
> > variables that are initialized but not otherwise used.
> 
> Are you using gcc-10? It sucks for that. gcc-9 seems to reliably hit
> these cases for me, not sure why gcc-10 doesn't. And the ones quoted
> above are about as trivial as they can get.

gcc-9.3 from Debian -testing.  And yes, I'm really surprised it didn't
find those.
