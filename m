From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Fri, 7 May 2021 08:09:00 +0000
Message-ID: <MWHPR11MB18868EB21E0D8085D65ED7988C579@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com> <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com> <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com> <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box> <20210427171212.GD1370958@nvidia.com>
 <MWHPR11MB1886F0818D30329172C420758C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210504171246.GZ1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKlAyCWuOOlsywhJS5J8wOLBZVb4WXOd8E5/iTO+3p4=;
 b=WJqzF6PNdll3Gza4Bk+UCeyOVAPCqjDQs2lQvq0r14ncY1xk5bNhiNKBfzZraXg4rZggx5zGCu/sjwLH/4J2IRETQJB8BRpgl0nQS9e3F0SBjtsUsRLVu8jLIpt24hJObUdb9yaMRzrQFL3SWzitDIota/42ZARSqrhcMypd22I=
In-Reply-To: <20210504171246.GZ1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Wednesday, May 5, 2021 1:13 AM
>=20
> On Wed, Apr 28, 2021 at 06:58:19AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > Sent: Wednesday, April 28, 2021 1:12 AM
> > >
> > [...]
> > > > As Alex says, if this line fails because of the group restrictions,
> > > > that's not great because it's not very obvious what's gone wrong.
> > >
> > > Okay, that is fair, but let's solve that problem directly. For
> > > instance netlink has been going in the direction of adding a "extack"
> > > from the kernel which is a descriptive error string. If the failing
> > > ioctl returned the string:
> > >
> > >   "cannot join this device to the IOASID because device XXX in the
> > >    same group #10 is in use"
> > >
> > > Would you agree it is now obvious what has gone wrong? In fact would
> > > you agree this is a lot better user experience than what applications
> > > do today even though they have the group FD?
> > >
> >
> > Currently all the discussions are around implicit vs. explicit uAPI sem=
antics
> > on the group restriction. However if we look beyond group the implicit
> > semantics might be inevitable when dealing with incompatible iommu
> > domains. An existing example of iommu incompatibility is IOMMU_
> > CACHE.
>=20
> I still think we need to get rid of these incompatibilities
> somehow. Having multiple HW incompatible IOASID in the same platform
> is just bad all around.
>=20
> When modeling in userspace IOMMU_CACHE sounds like it is a property of
> each individual IOASID, not an attribute that requires a new domain.

sure. the iommu domain is an kernel-internal concept. The userspace=20
should focus everything on IOASID.

>=20
> People that want to create cache bypass IOASID's should just ask for
> that that directly.
>=20

Yes, in earlier discussion we agreed on a scheme that ioasid module
will return an error to userspace indicating incompatibility detected
when binding a device to ioasid then the userspace should create=20
a new IOASID for this device. This has to be done 'explicitly'.=20

When I used it as the example for 'implicit semantics" is that the kernel=20
won't create another group-like object to contain devices with compatible=20
attributes and 'explicitly' manage it in uAPI like group_fd. If we anyway
rely on the userspace to have more intelligence on those hardware
restrictions, it's little sense to only explicitly handle group_fd in uAPI.

Thanks
Kevin
