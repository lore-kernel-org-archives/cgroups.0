From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 28 Apr 2021 06:58:19 +0000
Message-ID: <MWHPR11MB1886F0818D30329172C420758C409@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com> <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com> <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com> <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com> <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box> <20210427171212.GD1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCkC3H9KVnRyH2B2gFhztpBmeG7E9L+T37fDrS9qaLM=;
 b=CHbkdlKSlIvvUruXzMRuL+HLnxBRrZRcsLsh/LTKcSWWk9U8cp/sK9aN/z7jkcWrJpKh7g53/105s56pbnoTfTjBvqM8CU5NPeaQEyr3Dvg8df5vrtlNA6ZeJj0kdyaqbj7lsKLye9GW0YoK0Cm/PKD5Zf9yUZSdr0hr9NgJFQY=
In-Reply-To: <20210427171212.GD1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Wednesday, April 28, 2021 1:12 AM
>=20
[...]=20
> > As Alex says, if this line fails because of the group restrictions,
> > that's not great because it's not very obvious what's gone wrong.
>=20
> Okay, that is fair, but let's solve that problem directly. For
> instance netlink has been going in the direction of adding a "extack"
> from the kernel which is a descriptive error string. If the failing
> ioctl returned the string:
>=20
>   "cannot join this device to the IOASID because device XXX in the
>    same group #10 is in use"
>=20
> Would you agree it is now obvious what has gone wrong? In fact would
> you agree this is a lot better user experience than what applications
> do today even though they have the group FD?
>=20

Currently all the discussions are around implicit vs. explicit uAPI semanti=
cs
on the group restriction. However if we look beyond group the implicit=20
semantics might be inevitable when dealing with incompatible iommu
domains. An existing example of iommu incompatibility is IOMMU_
CACHE. In the future there could be other incompatibilities such as=20
whether nested translation is supported. In the end the userspace has=20
to do some due diligence on understanding iommu topology and attributes=20
to decide how many VFIO containers or ioasid fds should be created. It=20
does push some burden to userspace but it's difficult to define a group-
like kernel object to enforce such restriction for iommu compatibility.=20
Then the best that the kernel can do is to return an informational error=20
message in case an incompatible device is attached to the existing domain.=
=20
If this is the perceived way to move forward anyway, I feel that removing=20
explicit group FD from uAPI doesn't make userspace worse...

Thanks
Kevin
