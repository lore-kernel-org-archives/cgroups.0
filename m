From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Tue, 6 Apr 2021 01:27:15 +0000
Message-ID: <MWHPR11MB1886CF7C11ECE0396A0215078C769@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com> <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com> <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA6QPV/w37J7WSqMnBWyoO0Tf+WSH04GhtmSithqTso=;
 b=BCuBjQMclxQVcS4azO2bY77qNQgCjIUjQr2r8yM7oRiNHjcPlGMWLKTPQzMIgp992NoZ5rIkM78ERJhyxABhYrRW6Ge0ndftAurYyUcf0aiRzc/26BrnVY12gDPgUv1apyUrCaZlcMAuBKexFU2vvwhdYx06NkCZstS766Hl9wQ=
In-Reply-To: <20210405234230.GF7405-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> From: Jason Gunthorpe
> Sent: Tuesday, April 6, 2021 7:43 AM
>=20
> On Fri, Apr 02, 2021 at 08:22:28AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > Sent: Tuesday, March 30, 2021 9:29 PM
> > >
> > > >
> > > > First, userspace may use ioasid in a non-SVA scenario where ioasid =
is
> > > > bound to specific security context (e.g. a control vq in vDPA) inst=
ead of
> > > > tying to mm. In this case there is no pgtable binding initiated fro=
m user
> > > > space. Instead, ioasid is allocated from /dev/ioasid and then
> programmed
> > > > to the intended security context through specific passthrough
> framework
> > > > which manages that context.
> > >
> > > This sounds like the exact opposite of what I'd like to see.
> > >
> > > I do not want to see every subsystem gaining APIs to program a
> > > PASID. All of that should be consolidated in *one place*.
> > >
> > > I do not want to see VDPA and VFIO have two nearly identical sets of
> > > APIs to control the PASID.
> > >
> > > Drivers consuming a PASID, like VDPA, should consume the PASID and do
> > > nothing more than authorize the HW to use it.
> > >
> > > quemu should have general code under the viommu driver that drives
> > > /dev/ioasid to create PASID's and manage the IO mapping according to
> > > the guest's needs.
> > >
> > > Drivers like VDPA and VFIO should simply accept that PASID and
> > > configure/authorize their HW to do DMA's with its tag.
> > >
> >
> > I agree with you on consolidating things in one place (especially for t=
he
> > general SVA support). But here I was referring to an usage without
> > pgtable binding (Possibly Jason. W can say more here), where the
> > userspace just wants to allocate PASIDs, program/accept PASIDs to
> > various workqueues (device specific), and then use MAP/UNMAP
> > interface to manage address spaces associated with each PASID.
> > I just wanted to point out that the latter two steps are through
> > VFIO/VDPA specific interfaces.
>=20
> No, don't do that.
>=20
> VFIO and VDPA has no buisness having map/unmap interfaces once we have
> /dev/ioasid. That all belongs in the iosaid side.
>=20
> I know they have those interfaces today, but that doesn't mean we have
> to keep using them for PASID use cases, they should be replaced with a
> 'do dma from this pasid on /dev/ioasid' interface certainly not a
> 'here is a pasid from /dev/ioasid, go ahead and configure it youself'
> interface
>=20
> This is because PASID is *complicated* in the general case! For
> instance all the two level stuff you are talking about must not leak
> into every user!
>=20

Hi, Jason,

I didn't get your last comment how the two level stuff is leaked into every
user. Could you elaborate it a bit?

and here is one example why using existing VFIO/VDPA interface makes
sense. say dev1 (w/ sva) and dev2 (w/o sva) are placed in a single VFIO=20
container. The container is associated to an iommu domain which contains=20
a single 2nd-level page table, shared by both devices (when attached to
the domain). The VFIO MAP operation is applied to the 2nd-level page=20
table thus naturally applied to both devices. Then userspace could use=20
/dev/ioasid to further allocate IOASIDs and bind multiple 1st-level page=20
tables for dev1, nested on the shared 2nd-level page table.=20

If following your suggestion then VFIO must deny VFIO MAP operations
on sva1 (assume userspace should not mix sva1 and sva2 in the same
container and instead use /dev/ioasid to map for sva1)? and even for=20
a sva-capable device there is a window before the guest actually enables=20
sva on that device then VFIO should still accept MAP in that window=20
and then deny it after sva is enabled by the guest? This all sounds
unnecessary complex while there is already a clean way to achieve it...

Thanks
Kevin
