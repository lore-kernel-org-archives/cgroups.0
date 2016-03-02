From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] block: transfer source bio's cgroup tags to clone via
 bio_associate_blkcg()
Date: Wed, 2 Mar 2016 16:19:20 -0500
Message-ID: <20160302211920.GH3476@redhat.com>
References: <56CEB1BC.4000005@kyup.com>
 <20160225145314.GA20699@redhat.com>
 <20160302160649.GB29826@mtj.duckdns.org>
 <20160302175656.GA59991@redhat.com>
 <CAJFSNy6hni1-NWDs0z=Hq223=DfcjsNPoAb7GRAGEPCUXh4Q9w@mail.gmail.com>
 <20160302191827.GC3476@redhat.com>
 <CAJFSNy7E9b06JQOdjzKDpz5Ehks4ZZ1disfN2U-RQxJnSwyqZw@mail.gmail.com>
 <20160302201016.GE3476@redhat.com>
 <56D74E6A.9050708@windriver.com>
 <20160302210405.GG3476@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160302210405.GG3476-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>

On Wed, Mar 02, 2016 at 04:04:05PM -0500, Vivek Goyal wrote:
> On Wed, Mar 02, 2016 at 02:34:50PM -0600, Chris Friesen wrote:
> > On 03/02/2016 02:10 PM, Vivek Goyal wrote:
> > >On Wed, Mar 02, 2016 at 09:59:13PM +0200, Nikolay Borisov wrote:
> > 
> > >We had similar issue with IO priority and it did not work reliably with
> > >CFQ on underlying device when dm devices were sitting on top.
> > >
> > >If we really want to give it a try, I guess we will have to put cgroup
> > >info of submitter early in bio at the time of bio creation even for all
> > >kind of IO. Not sure if it is worth the effort.
> > 
> > As it stands, imagine that you have a hypervisor node running many VMs (or
> > containers), each of which is assigned a separate logical volume (possibly
> > thin-provisioned) as its rootfs.
> > 
> > Ideally we want the disk accesses by those VMs to be "fair" relative to each
> > other, and we want to guarantee a certain amount of bandwidth for the host
> > as well.
> > 
> > Without this sort of feature, how can we accomplish that?
> 
> As of now, you can't. I will try adding bio_associate_current() and see
> if that along with Mike's patches gets you what you are looking for.
> 

Can you try following also along with Mike's patch of carrying cgroup
info over the clones.

Mike, is it right place in dm layer to hook into. I think this will take
care of bio based targets.

Even after this I think there are still two issues.

- bio_associate_current() assumes that submitter already has an io context
  otherwise does nothing. So in this case if container/VM process does not
  have io context, nothing will happen.

- We will also need mechanism to carry io context information when we 
  clone bio. Otherwise we will get the cgroup of the original process
  and io context of the dm thread (kind of odd).


---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

Index: rhvgoyal-linux/drivers/md/dm.c
===================================================================
--- rhvgoyal-linux.orig/drivers/md/dm.c	2016-03-02 19:19:12.301000000 +0000
+++ rhvgoyal-linux/drivers/md/dm.c	2016-03-02 21:11:01.357000000 +0000
@@ -1769,6 +1769,7 @@ static blk_qc_t dm_make_request(struct r
 
 	generic_start_io_acct(rw, bio_sectors(bio), &dm_disk(md)->part0);
 
+	bio_associate_current(bio);
 	/* if we're suspended, we have to queue this io for later */
 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
 		dm_put_live_table(md, srcu_idx);
Thanks
Vivek
