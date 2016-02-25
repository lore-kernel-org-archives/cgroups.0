From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: blkio cgroups controller doesn't work with LVM?
Date: Thu, 25 Feb 2016 09:53:14 -0500
Message-ID: <20160225145314.GA20699@redhat.com>
References: <56CDF283.9010802@windriver.com>
 <56CEB1BC.4000005@kyup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56CEB1BC.4000005-6AxghH7DbtA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tejun-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Feb 25 2016 at  2:48am -0500,
Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:

> 
> 
> On 02/24/2016 08:12 PM, Chris Friesen wrote:
> > 
> > Hi,
> > 
> > Are there known limitations with the blkio cgroup controller when used
> > with LVM?
> > 
> > I'm using Ubuntu 15.10 with the 4.2 kernel.  I got the same results with
> > CentOS 7.
> > 
> > I set up two groups, /sys/fs/cgroup/blkio/test1 and
> > /sys/fs/cgroup/blkio/test2.  I set the weight for test1 to 500, and the
> > weight for test2 to 1000.
> 
> The weighed mode of blkio works only with CFQ scheduler. And as far as I
> have seen you cannot set CFQ to be the scheduler of DM devices. In this
> case you can use the BLK io throttling mechanism. That's what I've
> encountered in my practice. Though I'd be happy to be proven wrong by
> someone. I believe the following sentence in the blkio controller states
> that:
> "
> First one is proportional weight time based division of disk policy. It
> is implemented in CFQ. Hence this policy takes effect only on leaf nodes
> when CFQ is being used.
> "

Right, LVM created devices are bio-based DM devices in the kernel.
bio-based block devices do _not_ have an IO scheduler.  Their underlying
request-based device does.

I'm not well-versed on the top-level cgroup interface and how it maps to
associated resources that are established in the kernel.  But it could
be that the configuration of blkio cgroup against a bio-based LVM device
needs to be passed through to the underlying request-based device
(e.g. /dev/sda4 in Chris's case)?

I'm also wondering whether the latest cgroup work that Tejun has just
finished (afaik to support buffered IO in the IO controller) will afford
us a more meaningful reason to work to make cgroups' blkio controller
actually work with bio-based devices like LVM's DM devices?

I'm very much open to advice on how to proceed with investigating this
integration work.  Tejun, Vivek, anyone else: if you have advice on next
steps for DM on this front _please_ yell, thanks!

Mike
