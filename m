From: "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Sat, 8 May 2021 06:08:33 +0000
Message-ID: <MWHPR11MB1886473A749033F404DA08A68C569@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
 <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210426123817.GQ1370958@nvidia.com>
 <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210428090625.5a05dae8@redhat.com>
 <MWHPR11MB1886E0A7897758AA7BE509058C579@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210507110614.7b8e6998@redhat.com> <20210507171050.GV1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yqo3eb9LzAey9MiOlLfk8TglM0+/Z6/LA4tC2Xy7O7w=;
 b=BtDm7BAwl1hfYjwmv4G6k5qPx3u7p7CBpdA6HOyIFqW6qsmHJZBVYb87vMqc2VSRR6dSxd5neyZPc4YcXCLTeKQRwXCEoBmxm/xK+09lLG/2qzCdxQhLe9v0dzuneiMM6kJ7aiQYIf0yi63npLsS4h95UwYp/UmiAnxtu8Pxghs=
In-Reply-To: <20210507171050.GV1370958@nvidia.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Jonathan Corbet <corbet@lwn.net>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Wu, Hao" <hao.wu@intel.com>, David Woodhouse <dwmw2@infradead.org>

> From: Jason Gunthorpe
> Sent: Saturday, May 8, 2021 1:11 AM
>=20
> On Fri, May 07, 2021 at 11:06:14AM -0600, Alex Williamson wrote:
>=20
> > We had tossed around an idea of a super-container with vfio, it's maybe
> > something we'd want to incorporate into this design.  For instance, if
> > memory could be pre-registered with a super container, which would
> > handle the locked memory accounting for that memory, then
> > sub-containers could all handle the IOMMU context of their sets of
> > devices relative to that common memory pool.
>=20
> This is where I suggested to David to use nesting of IOASIDs.
>=20
> Without HW support for nesting a SW nest is really just re-using the
> memory registration information stored in the parent when constructing
> the children
>=20

yes, this sounds a sensible thing to do. it also unifies the user experienc=
e
regardless of whether the underlying hw supports nesting, e.g. when=20
vIOMMU is present Qemu can always use IOASID nesting uAPI. In case
of SW nest then the kernel will merge the two-level translations from two
IOASIDs into one-level shadow page table (unlike today's VFIO which has=20
the userspace to manage shadow-based mapping).=20

but want to remark that nesting IOASIDs alone cannot solve this accounting
problem completely, as long as a process is allowed to have multiple ioasid
FDs (unless there is a mechanism to allow nesting IOASIDs cross FDs). But
this is probably not a big issue. With all the intended usages around the
new interface, I think for most applications one ioasid FD should be suffic=
ient
to meet their requirements (multiple gpa_ioasids, ioasid nesting, etc.).

Thanks
Kevin
