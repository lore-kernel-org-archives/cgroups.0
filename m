From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 4 May 2021 15:15:37 -0300
Message-ID: <20210504181537.GC1370958@nvidia.com>
References: <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <YIeYJZOdgMN/orl0@yekko.fritz.box>
 <20210427172432.GE1370958@nvidia.com>
 <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
 <20210429002149.GZ1370958@nvidia.com>
 <YIol9p3z8BTWFRh8@yekko>
 <20210503160530.GL1370958@nvidia.com>
 <YJDFj+sAv41JRIo4@yekko>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8y5LBuxvoAdlpVsPJcxB+aQUIOpbP6uh5nSiQXgl/0E=;
 b=JJPbmrj6tt56D+I875gNIus9d4K1FyTxypTHKZz6wNrp0RfaEsE05xFhcikU651qZ6iL+/KhIrneETZ4Vwv0S2R1Omfz2Jd2Z0FNPhOt2xzrOBfBDDzid/SQwiqIpMSwFSswaSVY/9knsYodKTF0Qx/TogWfUAtnYxHBSSh5AO7b7SmNczvxocMlo039hNeGBlSjJSDmCT+Xs5rdQzTfbQiH2iX+nE/V1TomXR74uttya4bxVFHDxfEu38ZDQ2dheoU/TZHJ47sU4BmIkJ2m6mEi+CiVFZAD9s8gXBawmIjwHMQTgyfN70NcVbuLU/xKuZuMoQnZynoL7IBNrpXuWA==
Content-Disposition: inline
In-Reply-To: <YJDFj+sAv41JRIo4@yekko>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, May 04, 2021 at 01:54:55PM +1000, David Gibson wrote:
> On Mon, May 03, 2021 at 01:05:30PM -0300, Jason Gunthorpe wrote:
> > On Thu, Apr 29, 2021 at 01:20:22PM +1000, David Gibson wrote:
> > > > There is a certain appeal to having some
> > > > 'PPC_TCE_CREATE_SPECIAL_IOASID' entry point that has a wack of extra
> > > > information like windows that can be optionally called by the viommu
> > > > driver and it remains well defined and described.
> > > 
> > > Windows really aren't ppc specific.  They're absolutely there on x86
> > > and everything else as well - it's just that people are used to having
> > > a window at 0..<something largish> that you can often get away with
> > > treating it sloppily.
> > 
> > My point is this detailed control seems to go on to more than just
> > windows. As you say the vIOMMU is emulating specific HW that needs to
> > have kernel interfaces to match it exactly.
> 
> It's really not that bad.  The case of emulating the PAPR vIOMMU on
> something else is relatively easy, because all updates to the IO page
> tables go through hypercalls.  So, as long as the backend IOMMU can
> map all the IOVAs that the guest IOMMU can, then qemu's implementation
> of those hypercalls just needs to put an equivalent mapping in the
> backend, which it can do with a generic VFIO_DMA_MAP.

So you also want the PAPR vIOMMU driver to run on, say, an ARM IOMMU?

> vIOMMUs with page tables in guest memory are harder, but only really
> in the usual ways that a vIOMMU of that type is harder (needs cache
> mode or whatever).  At whatever point you need to shadow from the
> guest IO page tables to the host backend, you can again do that with
> generic maps, as long as the backend supports the necessary IOVAs, and
> has an IO page size that's equal to or a submultiple of the vIOMMU
> page size.

But this definitely all becomes HW specific.

For instance I want to have an ARM vIOMMU driver it needs to do some

 ret = ioctl(ioasid_fd, CREATE_NESTED_IOASID, [page table format is ARMvXXX])
 if (ret == -EOPNOTSUPP)
     ret = ioctl(ioasid_fd, CREATE_NORMAL_IOASID, ..)
     // and do completely different and more expensive emulation

I can get a little bit of generality, but at the end of the day the
IOMMU must create a specific HW layout of the nested page table, if it
can't, it can't.

> > I'm remarking that trying to unify every HW IOMMU implementation that
> > ever has/will exist into a generic API complete enough to allow the
> > vIOMMU to be created is likely to result in an API too complicated to
> > understand..
> 
> Maybe not every one, but I think we can get a pretty wide range with a
> reasonable interface.  

It sounds like a reasonable guideline is if the feature is actually
general to all IOMMUs and can be used by qemu as part of a vIOMMU
emulation when compatible vIOMMU HW is not available.

Having 'requested window' support that isn't actually implemented in
every IOMMU is going to mean the PAPR vIOMMU emulation won't work,
defeating the whole point of making things general?

Jason
