From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 04/14] bdi: initialize ->ra_pages in bdi_init
Date: Tue, 21 Jul 2020 07:00:47 +0200
Message-ID: <20200721050047.GA9707@lst.de>
References: <20200720075148.172156-1-hch@lst.de>
	<20200720075148.172156-5-hch@lst.de>
	<CAFLxGvxNHGEOrj6nKTtDeiU+Rx4xv_6asjSQYcFWXhk5m=1cBA@mail.gmail.com>
	<20200720120734.GA29061@lst.de>
	<2827a5dbd94bc5c2c1706a6074d9a9a32a590feb.camel@gmail.com>
	<CAFLxGvyxtYnJ5UdD18uNA97zQaDB8-Wv8MHQn2g9GYD74v7cTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFLxGvyxtYnJ5UdD18uNA97zQaDB8-Wv8MHQn2g9GYD74v7cTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

On Mon, Jul 20, 2020 at 11:27:57PM +0200, Richard Weinberger wrote:
> On Mon, Jul 20, 2020 at 2:37 PM Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Mon, 2020-07-20 at 14:07 +0200, Christoph Hellwig wrote:
> > > What about jffs2 and blk2mtd raw block devices?
> 
> I don't worry much about blk2mtd.
> 
> > If my memory serves me correctly JFFS2 did not mind readahead.
> 
> This covers my knowledge too.
> I fear enabling readahead on JFFS2 will cause performance issues, this
> filesystem
> is mostly used on small and slow NOR devices.

I'm going to wait for Hans for feedback on vboxsf, but in doubt I'll
ust add a prep patch or fold for this one to explicit set ra_pages to 0
with a comment then.
