From: "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 28 Apr 2021 07:47:56 +0000
Message-ID: <MWHPR11MB1886C9199AA3F00FF72ACB508C409@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com> <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com> <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com> <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com> <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box> <20210427171212.GD1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPz8Og2u6aLtUq4xQukjUxKU/TryxrPNsjv9pdxRKds=;
 b=jJCG5zvl8P6o5Wzp0UCOaCfnNhAMmHfj2hZoAEa3YDQ7s1oLAHv0dcE2x3wlYUbOnb2TjiobQsTWffLGkd3fw3ENASw7MBLW+n/OkQ4SEK8SfST5NJW2jSLQW6oL+UZcKXcOVol840XjEqfb81zElQzAQWOGLoZAMkmCK4ZqKe8=
In-Reply-To: <20210427171212.GD1370958@nvidia.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>, David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, Auger Eric <eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Jonathan Corbet <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 28, 2021 1:12 AM
>=20
[...]
> One option is VFIO can keep its group FD but nothing else will have
> anthing like it. However I don't much like the idea that VFIO will
> have a special and unique programming model to do that same things
> other subsystem will do. That will make it harder for userspace to
> implement.

Hi, Jason,

I have a question here. Based on discussions so far, it's clearly that the
new ioasid uAPI will differ from existing VFIO uAPI a lot, e.g. ioasid-
centric operations, no group fd, no incompatible domains, etc. Then=20
I wonder how we plan to support legacy VFIO applications in this=20
transition phase. Earlier you ever mentioned the desire of directly
replacing /dev/vfio/vfio with /dev/ioasid and having ioasid to present
both VFIO and new uAPI. Doesn't it imply that we have to copy the=20
VFIO container/group semantics into /dev/ioasid although it's a special=20
programming model only for VFIO?

Alternatively we could keep all the container/group legacy within VFIO
and having /dev/ioasid support only the new uAPI semantics. In this case
VFIO will include a shim iommu backend to connect its legacy uAPI into=20
drivers/ioasid backend functions for backward compatibility. Then VFIO
will also support a new model which only uses its device uAPI to bind
to new ioasid fd w/o using any legacy container/group/iommu uAPI.
Does this sound a plan?=20

Thanks
Kevin
