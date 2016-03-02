From: Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH] block: transfer source bio's cgroup tags to clone via
 bio_associate_blkcg()
Date: Wed, 2 Mar 2016 14:34:50 -0600
Message-ID: <56D74E6A.9050708@windriver.com>
References: <56CDF283.9010802@windriver.com> <56CEB1BC.4000005@kyup.com> <20160225145314.GA20699@redhat.com> <20160302160649.GB29826@mtj.duckdns.org> <20160302175656.GA59991@redhat.com> <CAJFSNy6hni1-NWDs0z=Hq223=DfcjsNPoAb7GRAGEPCUXh4Q9w@mail.gmail.com> <20160302191827.GC3476@redhat.com> <CAJFSNy7E9b06JQOdjzKDpz5Ehks4ZZ1disfN2U-RQxJnSwyqZw@mail.gmail.com> <20160302201016.GE3476@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160302201016.GE3476-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>

On 03/02/2016 02:10 PM, Vivek Goyal wrote:
> On Wed, Mar 02, 2016 at 09:59:13PM +0200, Nikolay Borisov wrote:

> We had similar issue with IO priority and it did not work reliably with
> CFQ on underlying device when dm devices were sitting on top.
>
> If we really want to give it a try, I guess we will have to put cgroup
> info of submitter early in bio at the time of bio creation even for all
> kind of IO. Not sure if it is worth the effort.

As it stands, imagine that you have a hypervisor node running many VMs (or 
containers), each of which is assigned a separate logical volume (possibly 
thin-provisioned) as its rootfs.

Ideally we want the disk accesses by those VMs to be "fair" relative to each 
other, and we want to guarantee a certain amount of bandwidth for the host as well.

Without this sort of feature, how can we accomplish that?

> For the case of IO throttling, I think you should put throttling rules on
> the dm device itself. That means as long as filesystem supports the
> cgroups, you should be getting right cgroup information for all kind of
> IO and throttling should work just fine.

IO throttling isn't all that useful, since it requires you to know in advance 
what your IO rate is.  And it doesn't adjust nicely as the number of competing 
entities changes the way that weight-based schemes do.

Chris
