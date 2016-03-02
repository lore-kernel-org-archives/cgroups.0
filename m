From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] block: transfer source bio's cgroup tags to clone via
 bio_associate_blkcg() (was: Re: blkio cgroups controller doesn't work with
 LVM?)
Date: Wed, 2 Mar 2016 14:18:27 -0500
Message-ID: <20160302191827.GC3476@redhat.com>
References: <56CDF283.9010802@windriver.com>
 <56CEB1BC.4000005@kyup.com>
 <20160225145314.GA20699@redhat.com>
 <20160302160649.GB29826@mtj.duckdns.org>
 <20160302175656.GA59991@redhat.com>
 <CAJFSNy6hni1-NWDs0z=Hq223=DfcjsNPoAb7GRAGEPCUXh4Q9w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJFSNy6hni1-NWDs0z=Hq223=DfcjsNPoAb7GRAGEPCUXh4Q9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>

On Wed, Mar 02, 2016 at 08:03:10PM +0200, Nikolay Borisov wrote:
> Thanks for the patch I will likely have time to test this sometime next week.
> But just to be sure - the expected behavior would be that processes
> writing to dm-based devices would experience the fair-shair
> scheduling of CFQ (provided that the physical devices that back those
> DM devices use CFQ), correct?

Nikolay,

I am not sure how well it will work with CFQ of underlying device. It will
get cgroup information right for buffered writes. But cgroup information
for reads and direct writes will come from submitter's context and if dm
layer gets in between, then many a times submitter might be a worker
thread and IO will be attributed to that worker's cgroup (root cgroup).

Give it a try anyway.

Thanks
Vivek
