From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 03/13] bcache: inherit the optimal I/O size
Date: Mon, 21 Sep 2020 16:00:10 +0200
Message-ID: <20200921140010.GA14672@lst.de>
References: <20200921080734.452759-1-hch@lst.de> <20200921080734.452759-4-hch@lst.de> <b547a1b6-ab03-0520-012d-86d112c83d92@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b547a1b6-ab03-0520-012d-86d112c83d92-l3A5Bk7waGM@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>, Justin Sanders <justin-kFqnmIA2sJXQT0dZR+AlfA@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 21, 2020 at 05:54:59PM +0800, Coly Li wrote:
> I am not sure whether virtual bcache device's optimal request size can
> be simply set like this.
> 
> Most of time inherit backing device's optimal request size is fine, but
> there are two exceptions,
> - Read request hits on cache device
> - User sets sequential_cuttoff as 0, all writing may go into cache
> device firstly.
> For the above two conditions, all I/Os goes into cache device, using
> optimal request size of backing device might be improper.
> 
> Just a guess, is it OK to set the optimal request size of the virtual
> bcache device as the least common multiple of cache device's and backing
> device's optimal request sizes ?

Well, if the optimal I/O size is wrong, the read ahead size also is
wrong.  Can we just drop the setting?
