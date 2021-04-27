From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 27 Apr 2021 14:12:12 -0300
Message-ID: <20210427171212.GD1370958@nvidia.com>
References: <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5ay4zJDSzBfgShQVaw/dIX2szXKUzgVWHX1srUfNus=;
 b=l7N3W0P1zgoY0V5sk3MZROfPlsXfodgsYR1q+Qm/FDfxN23MA9ITKH3W9aMepSTcfnRsvNYYiDrZgFaUi70KuFu2AC2ApMcfKKnWEXFqJ3nji+X/obxI5B4C3/sLFThgrq0Q00TvRZ2WEgFm3m+Cs07GfDKrUC368IJ/0DNlVwXNsr3MQDMkC07gDqan2+u6kQHpJG8qEqBwBDlKfueLp6Y/FJRociM9iC/qNTa7fjKaSvUIgXjn6cXS+t8LT92ZzGqhSv5T5krJ7nHnB5g6danC1O17g2P5FH7VkCCgQD22iPf794YC5j7cQMtKVDI0sDePWXPyYGfDQJJ5iqKoGA==
Content-Disposition: inline
In-Reply-To: <YIecXkaEGNgICePO-l+x2Y8Cxqc4e6aEkudXLsA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Apr 27, 2021 at 03:08:46PM +1000, David Gibson wrote:
> > Starting from a BDF the general pseudo code is:
> >  device_name = first_directory_of("/sys/bus/pci/devices/BDF/vfio/")
> >  device_fd = open("/dev/vfio/"+device_name)
> >  ioasidfd = open("/dev/ioasid")
> >  ioctl(device_fd, JOIN_IOASID_FD, ioasidfd)
> 
> This line is the problem.
> 
> [Historical aside: Alex's early drafts for the VFIO interface looked
> quite similar to this.  Ben Herrenschmidt and myself persuaded him it
> was a bad idea, and groups were developed instead.  I still think it's
> a bad idea, and not just for POWER]

Spawning the VFIO device FD from the group FD is incredibly gross from
a kernel design perspective. Since that was done the struct
vfio_device missed out on a sysfs presence and doesn't have the
typical 'struct device' member or dedicated char device you'd expect a
FD based subsystem to have.

This basically traded normal usage of the driver core for something
that doesn't serve a technical usage. Given we are now nearly 10 years
later and see that real widely deployed applications are not doing
anything special with the group FD it makes me question the wisdom of
this choice.

> As Alex says, if this line fails because of the group restrictions,
> that's not great because it's not very obvious what's gone wrong.  

Okay, that is fair, but let's solve that problem directly. For
instance netlink has been going in the direction of adding a "extack"
from the kernel which is a descriptive error string. If the failing
ioctl returned the string:

  "cannot join this device to the IOASID because device XXX in the
   same group #10 is in use"

Would you agree it is now obvious what has gone wrong? In fact would
you agree this is a lot better user experience than what applications
do today even though they have the group FD?

> But IMO, the success path on a multi-device group is kind of worse:
> you've now made made a meaningful and visible change to the setup of
> devices which are not mentioned in this line *at all*.  

I don't think spawning a single device_fd from the guoup clearly says
there are repercussions outside that immediate, single, device.

That comes from understanding what the ioctls are doing, and reading
the documentation. The same applies to some non-group FD world.

> Yes, it makes set up more of a pain, but it's necessary complexity to
> actually understand what's going on here.

There is a real technical problem here - the VFIO group is the thing
that spawns the device_fd and that is incompatible with the idea to
centralize the group security logic in drivers/iommu/ and share it
with multiple subsystems.

We also don't have an obvious clean way to incorporate a group FD into
other subsystems (nor would I want to).

One option is VFIO can keep its group FD but nothing else will have
anthing like it. However I don't much like the idea that VFIO will
have a special and unique programming model to do that same things
other subsystem will do. That will make it harder for userspace to
implement.

But again, lets see what the draft ioasid proposal looks like and
maybe someone will see a different solution.

Jason
