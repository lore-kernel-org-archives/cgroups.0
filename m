From: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] PM/hibernate: remove the bogus call to get_gendisk in software_resume
Date: Fri, 2 Oct 2020 16:11:30 +0200
Message-ID: <CAJZ5v0hN7S0Tg8UTQCTLSsZw-n+9pHQBjvscWcBC4gpA5jPCuQ@mail.gmail.com>
References: <20200925161447.1486883-1-hch@lst.de> <20200925161447.1486883-3-hch@lst.de>
 <CAJZ5v0h8TbOZ=seE8+OqFKTRxOYK25aTXDam7Lez0VR5qnkM3Q@mail.gmail.com> <20201002065015.GA9691@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201002065015.GA9691-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Minho Ban <mhban-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux PM <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Oct 2, 2020 at 8:50 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> On Wed, Sep 30, 2020 at 05:45:27PM +0200, Rafael J. Wysocki wrote:
> > On Fri, Sep 25, 2020 at 6:15 PM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> > >
> > > get_gendisk grabs a reference on the disk and file operation, so this
> > > code will leak both of them while having absolutely no use for the
> > > gendisk itself.
> > >
> > > This effectively reverts commit 2df83fa4bce421f
> > > ("PM / Hibernate: Use get_gendisk to verify partition if resume_file is integer format")
> > >
> > > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> >
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Can you pick it up through the PM tree?  The big rework in this area
> I have planned won't land before 5.11 anyway.

Will do, thanks!
