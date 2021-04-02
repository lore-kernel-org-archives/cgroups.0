From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Fri, 2 Apr 2021 07:58:02 +0000
Message-ID: <MWHPR11MB1886C0804A0240998C110EE58C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401114648.GX1463678@nvidia.com>
 <BN6PR11MB406858FAC3821B84CCC4D30DC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401131533.GD1463678@nvidia.com>
 <BN6PR11MB4068C1A040FF61B4A9ABBD9BC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134641.GG1463678@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWeTTys4ZZr6EAedqZXjJE18StmzLqZyNClmd4mJuic=;
 b=L2gICMo2IRqqXvoh/GtEHsIP9pQE9L0nkkdbUh9mefeDpSQX8zug4d1Oi/hqkwwpoziUi5RjkWUpzBe3oaUqaYMln//C68AYLHVsauRQlb0ZffvwWok8C4BqW5rQrxGX2vXCBBe0MfSwWyJSHT9/OW5NztkOqEi/ag6BwzKFmWs=
In-Reply-To: <20210401134641.GG1463678-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Thursday, April 1, 2021 9:47 PM
>=20
> On Thu, Apr 01, 2021 at 01:43:36PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > Sent: Thursday, April 1, 2021 9:16 PM
> > >
> > > On Thu, Apr 01, 2021 at 01:10:48PM +0000, Liu, Yi L wrote:
> > > > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > > Sent: Thursday, April 1, 2021 7:47 PM
> > > > [...]
> > > > > I'm worried Intel views the only use of PASID in a guest is with
> > > > > ENQCMD, but that is not consistent with the industry. We need to =
see
> > > > > normal nested PASID support with assigned PCI VFs.
> > > >
> > > > I'm not quire flow here. Intel also allows PASID usage in guest wit=
hout
> > > > ENQCMD. e.g. Passthru a PF to guest, and use PASID on it without
> > > ENQCMD.
> > >
> > > Then you need all the parts, the hypervisor calls from the vIOMMU, an=
d
> > > you can't really use a vPASID.
> >
> > This is a diagram shows the vSVA setup.
>=20
> I'm not talking only about vSVA. Generic PASID support with arbitary
> mappings.
>=20
> And how do you deal with the vPASID vs pPASID issue if the system has
> a mix of physical devices and mdevs?
>=20

We plan to support two schemes. One is vPASID identity-mapped to
pPASID then the mixed scenario just works, with the limitation of=20
lacking of live migration support. The other is non-identity-mapped=20
scheme, where live migration is supported but physical devices and=20
mdevs should not be mixed in one VM if both expose SVA capability=20
(requires some filtering check in Qemu). Although we have some=20
idea relaxing this restriction in the non-identity scheme, it requires=20
more thinking given how the vSVA uAPI is being refactored.

In both cases the virtual VT-d will report a virtual capability to the gues=
t,
indicating that the guest must request PASID through a vcmd register
instead of creating its own namespace. The vIOMMU returns a vPASID=20
to the guest upon request. The vPASID could be directly mapped to a=20
pPASID or allocated from a new namespace based on user configuration.

We hope the /dev/ioasid can support both schemes, with the minimal
requirement of allowing userspace to tag a vPASID to a pPASID and
allowing mdev to translate vPASID into pPASID, i.e. not assuming that
the guest will always use pPASID.

Thanks
Kevin
