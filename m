From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] block: transfer source bio's cgroup tags to clone via
 bio_associate_blkcg() (was: Re: blkio cgroups controller doesn't work with
 LVM?)
Date: Wed, 2 Mar 2016 15:45:25 -0500
Message-ID: <20160302204525.GF3476@redhat.com>
References: <56CDF283.9010802@windriver.com>
 <56CEB1BC.4000005@kyup.com>
 <20160225145314.GA20699@redhat.com>
 <20160302160649.GB29826@mtj.duckdns.org>
 <20160302175656.GA59991@redhat.com>
 <CAJFSNy6hni1-NWDs0z=Hq223=DfcjsNPoAb7GRAGEPCUXh4Q9w@mail.gmail.com>
 <20160302191827.GC3476@redhat.com>
 <CAJFSNy7E9b06JQOdjzKDpz5Ehks4ZZ1disfN2U-RQxJnSwyqZw@mail.gmail.com>
 <20160302201016.GE3476@redhat.com>
 <CAJFSNy6MUGr8E3RNw6hFiskcaG4m8EGdqMkQXVh1LGq-yZCjBg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJFSNy6MUGr8E3RNw6hFiskcaG4m8EGdqMkQXVh1LGq-yZCjBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>

On Wed, Mar 02, 2016 at 10:19:38PM +0200, Nikolay Borisov wrote:
> On Wednesday, March 2, 2016, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Wed, Mar 02, 2016 at 09:59:13PM +0200, Nikolay Borisov wrote:
> > > On Wednesday, March 2, 2016, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > <javascript:;>> wrote:
> > >
> > > > On Wed, Mar 02, 2016 at 08:03:10PM +0200, Nikolay Borisov wrote:
> > > > > Thanks for the patch I will likely have time to test this sometime
> > next
> > > > week.
> > > > > But just to be sure - the expected behavior would be that processes
> > > > > writing to dm-based devices would experience the fair-shair
> > > > > scheduling of CFQ (provided that the physical devices that back those
> > > > > DM devices use CFQ), correct?
> > > >
> > > > Nikolay,
> > > >
> > > > I am not sure how well it will work with CFQ of underlying device. It
> > will
> > > > get cgroup information right for buffered writes. But cgroup
> > information
> > >
> > >
> > >  Right, what's your definition of  buffered writes?
> >
> > Writes which go through page cache.
> >
> > > My mental model is that
> > > when a process submits a write request to a dm device , the bio is going
> > to
> > > be put on a devi e workqueue which would then  be serviced by a
> > background
> > > worker thread and later the submitter notified. Do you refer to this
> > whole
> > > gamut of operations as buffered writes?
> >
> > No, once the bio is submitted to dm device it could be a buffered write or
> > a direct write.
> >
> > >
> > > for reads and direct writes will come from submitter's context and if dm
> > > > layer gets in between, then many a times submitter might be a worker
> > > > thread and IO will be attributed to that worker's cgroup (root cgroup).
> > >
> > >
> > > Be that as it may, proivded that the worker thread is in the  'correct'
> > > cgroup,  then the appropriate babdwidth policies should apply, no?
> >
> > Worker thread will most likely be in root cgroup. So if a worker thread
> > is submitting bio, it will be attributed to root cgroup.
> >
> > We had similar issue with IO priority and it did not work reliably with
> > CFQ on underlying device when dm devices were sitting on top.
> >
> > If we really want to give it a try, I guess we will have to put cgroup
> > info of submitter early in bio at the time of bio creation even for all
> > kind of IO. Not sure if it is worth the effort.
> >
> > For the case of IO throttling, I think you should put throttling rules on
> > the dm device itself. That means as long as filesystem supports the
> > cgroups, you should be getting right cgroup information for all kind of
> > IO and throttling should work just fine.
> 
> 
> Throttling does work even now,  but the use case I had in mind was
> proportional
> distribution of IO. Imagine 50  or so dm devices, hosting IO intensive
> workloads. In
> this situation, I'd  be interested each of them getting proportional IO
> based on the weights
> set in the blkcg controller for each respective cgroup for every workload.
> 

I see what you are trying to do. Carry the cgroup information from top to
bottom of IO stack for all kind of IO.

I guess we also need to call  bio_associate_current() when dm accepts
bio from the submitter.

Thanks
Vivek
