From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Thu, 13 May 2021 06:52:43 +0000
Message-ID: <MWHPR11MB18866CDB2F82A2E9285994998C519@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com> <YIeYJZOdgMN/orl0@yekko.fritz.box>
 <20210427172432.GE1370958@nvidia.com> <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
 <20210429002149.GZ1370958@nvidia.com> <YIol9p3z8BTWFRh8@yekko>
 <20210503160530.GL1370958@nvidia.com> <YJDFj+sAv41JRIo4@yekko>
 <20210504181537.GC1370958@nvidia.com> <YJzAsBNF1irJxRGg@yekko>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOxG10YlcjhdLDqR+LeNIuApwba0FwwP6LcqPjTuLGk=;
 b=MVgQ2DzC1AOPcKQ5zPaFn7LetXGCcpepufHDO0+utMNN0i9biBIb1a12iN5P8HXCCzdW7BMIY61cX641dQSsTInDRLLiiGFgk5fvdEUJo73HphYq65nRkylkSNYly6/MOQKE8ODmrCBU4qb7uIpnuP6rlEMOaYrlPthUBrpoPKs=
In-Reply-To: <YJzAsBNF1irJxRGg@yekko>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
> Sent: Thursday, May 13, 2021 2:01 PM
> >
> > But this definitely all becomes HW specific.
> >
> > For instance I want to have an ARM vIOMMU driver it needs to do some
> >
> >  ret =3D ioctl(ioasid_fd, CREATE_NESTED_IOASID, [page table format is
> ARMvXXX])
> >  if (ret =3D=3D -EOPNOTSUPP)
> >      ret =3D ioctl(ioasid_fd, CREATE_NORMAL_IOASID, ..)
> >      // and do completely different and more expensive emulation
> >
> > I can get a little bit of generality, but at the end of the day the
> > IOMMU must create a specific HW layout of the nested page table, if it
> > can't, it can't.
>=20
> Erm.. I don't really know how your IOASID interface works here.  I'm
> thinking about the VFIO interface where maps and unmaps are via
> explicit ioctl()s, which provides an obvious point to do translation
> between page table formats.
>=20

We are working on a draft uAPI proposal based on the discussions in this
thread. expect to send it out next week.=20

Thanks
Kevin
