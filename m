From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: block: transfer source bio's cgroup tags to clone via
 bio_associate_blkcg()
Date: Mon, 14 Mar 2016 15:49:12 -0400
Message-ID: <20160314194912.GA6975@redhat.com>
References: <56CDF283.9010802@windriver.com>
 <56CEB1BC.4000005@kyup.com>
 <20160225145314.GA20699@redhat.com>
 <20160302160649.GB29826@mtj.duckdns.org>
 <20160302175656.GA59991@redhat.com>
 <56E6D3D3.4070104@kyup.com>
 <56E6D95B.3030904@siteground.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E6D95B.3030904-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Mar 14 2016 at 11:31am -0400,
Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org> wrote:

> 
> 
> On 03/14/2016 05:08 PM, Nikolay Borisov wrote:
> > 
> > 
> > On 03/02/2016 07:56 PM, Mike Snitzer wrote:
> >> On Wed, Mar 02 2016 at 11:06P -0500,
> >> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >>
> >>> Hello,
> >>>
> >>> On Thu, Feb 25, 2016 at 09:53:14AM -0500, Mike Snitzer wrote:
> >>>> Right, LVM created devices are bio-based DM devices in the kernel.
> >>>> bio-based block devices do _not_ have an IO scheduler.  Their underlying
> >>>> request-based device does.
> >>>
> >>> dm devices are not the actual resource source, so I don't think it'd
> >>> work too well to put io controllers on them (can't really do things
> >>> like proportional control without owning the queue).
> >>>
> >>>> I'm not well-versed on the top-level cgroup interface and how it maps to
> >>>> associated resources that are established in the kernel.  But it could
> >>>> be that the configuration of blkio cgroup against a bio-based LVM device
> >>>> needs to be passed through to the underlying request-based device
> >>>> (e.g. /dev/sda4 in Chris's case)?
> >>>>
> >>>> I'm also wondering whether the latest cgroup work that Tejun has just
> >>>> finished (afaik to support buffered IO in the IO controller) will afford
> >>>> us a more meaningful reason to work to make cgroups' blkio controller
> >>>> actually work with bio-based devices like LVM's DM devices?
> >>>>
> >>>> I'm very much open to advice on how to proceed with investigating this
> >>>> integration work.  Tejun, Vivek, anyone else: if you have advice on next
> >>>> steps for DM on this front _please_ yell, thanks!
> >>>
> >>> I think the only thing necessary is dm transferring bio cgroup tags to
> >>> the bio's that it ends up passing down the stack.  Please take a look
> >>> at fs/btrfs/extent_io.c::btrfs_bio_clone() for an example.  We
> >>> probably should introduce a wrapper for this so that each site doesn't
> >>> need to ifdef it.
> >>>
> >>> Thanks.
> >>
> >> OK, I think this should do it.  Nikolay and/or others can you test this
> >> patch using blkio cgroups controller with LVM devices and report back?
> >>
> >> From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> Date: Wed, 2 Mar 2016 12:37:39 -0500
> >> Subject: [PATCH] block: transfer source bio's cgroup tags to clone via bio_associate_blkcg()
> >>
> >> Move btrfs_bio_clone()'s support for transferring a source bio's cgroup
> >> tags to a clone into both bio_clone_bioset() and __bio_clone_fast().
> >> The former is used by btrfs (MD and blk-core also use it via bio_split).
> >> The latter is used by both DM and bcache.
> >>
> >> This should enable the blkio cgroups controller to work with all
> >> stacking bio-based block devices.
> >>
> >> Reported-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
> >> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> Signed-off-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> ---
> >>  block/bio.c          | 10 ++++++++++
> >>  fs/btrfs/extent_io.c |  6 ------
> >>  2 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > 
> > So I had a chance to test the settings here is what I got when running 
> > 2 container, using LVM-thin for their root device and having applied 
> > your patch: 
> > 
> > When the 2 containers are using the same blkio.weight values (500) I 
> > get the following from running DD simultaneously on the 2 containers: 
> > 
> > [root@c1501 ~]# dd if=test.img of=test2.img bs=1M count=3000 oflag=direct
> > 3000+0 records in
> > 3000+0 records out
> > 3145728000 bytes (3.1 GB) copied, 165.171 s, 19.0 MB/s
> > 
> > [root@c1500 ~]# dd if=test.img of=test2.img bs=1M count=3000 oflag=direct
> > 3000+0 records in
> > 3000+0 records out
> > 3145728000 bytes (3.1 GB) copied, 166.165 s, 18.9 MB/s
> > 
> > Also iostat showed the 2 volumes using almost the same amount of 
> > IO (around 20mb r/w). I then increase the weight for c1501 to 1000 i.e. 
> > twice the bandwidth that c1500 has, so I would expect its dd to complete
> > twice as fast: 
> > 
> > [root@c1501 ~]# dd if=test.img of=test2.img bs=1M count=3000 oflag=direct
> > 3000+0 records in
> > 3000+0 records out
> > 3145728000 bytes (3.1 GB) copied, 150.892 s, 20.8 MB/s
> > 
> > 
> > [root@c1500 ~]# dd if=test.img of=test2.img bs=1M count=3000 oflag=direct
> > 3000+0 records in
> > 3000+0 records out
> > 3145728000 bytes (3.1 GB) copied, 157.167 s, 20.0 MB/s
> > 
> > Now repeating the same tests but this time using the page-cache 
> > (echo 3 > /proc/sys/vm/drop_caches) was executed before each test run: 
> > 
> > With equal weights (500):
> > [root@c1501 ~]# dd if=test.img of=test2.img bs=1M count=3000
> > 3000+0 records in
> > 3000+0 records out
> > 3145728000 bytes (3.1 GB) copied, 114.923 s, 27.4 MB/s
> > 
> > [root@c1500 ~]# dd if=test.img of=test2.img bs=1M count=3000
> > 3000+0 records in
> > 3000+0 records out
> > 3145728000 bytes (3.1 GB) copied, 120.245 s, 26.2 MB/s
> > 
> > With (c1501's weight equal to twice that of c1500 (1000)):
> > 
> > [root@c1501 ~]# dd if=test.img of=test2.img bs=1M count=3000
> > 3000+0 records in
> > 3000+0 records out
> > 3145728000 bytes (3.1 GB) copied, 99.0181 s, 31.8 MB/s
> > 
> > [root@c1500 ~]# dd if=test.img of=test2.img bs=1M count=3000
> > 3000+0 records in
> > 3000+0 records out
> > 3145728000 bytes (3.1 GB) copied, 122.872 s, 25.6 MB/s
> 
> And another test which makes it obvious that your patch works:
> 
> [root@c1501 ~]# dd if=test.img of=test2.img bs=1M count=6000
> 6000+0 records in
> 6000+0 records out
> 6291456000 bytes (6.3 GB) copied, 210.466 s, 29.9 MB/s
> 
> [root@c1500 ~]# dd if=test.img of=test2.img bs=1M count=3000
> 3000+0 records in
> 3000+0 records out
> 3145728000 bytes (3.1 GB) copied, 201.118 s, 15.6 MB/s
> 
> 
> So a file that is twice the size of another one (6vs3 g) is copied for
> almost the same amount of time with 2x the bandwidth.

Great.

Jens, can you pick up the patch in question ("[PATCH] block: transfer
source bio's cgroup tags to clone via bio_associate_blkcg()") that I
posted in this thread?
