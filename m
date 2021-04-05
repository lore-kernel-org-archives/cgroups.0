From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 5 Apr 2021 20:39:46 -0300
Message-ID: <20210405233946.GE7405@nvidia.com>
References: <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401114648.GX1463678@nvidia.com>
 <BN6PR11MB406858FAC3821B84CCC4D30DC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401131533.GD1463678@nvidia.com>
 <BN6PR11MB4068C1A040FF61B4A9ABBD9BC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134641.GG1463678@nvidia.com>
 <MWHPR11MB1886C0804A0240998C110EE58C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VItadmgX2dxGoxYjA+QX+QYNDBSE3/WVd0dU9S7wdFA=;
 b=FZyRYH7nA6NCglXItm1REQHkMzVXZAFes5fpasMgm8X7DZqw42yngPWgNztmFdDGCkOkz9Gis9oRgzGxIUwL9RzcUAfJNapjIP+HoVsajjL8O2UxBdIQgegoxjY4l1aQ8UY2b15WQY/91+nAmOgahUETosMli7pityI/LXZp+rWEa4xfCJE/Iku35kSdlJdcXPbC8k40j/vYlioK6QRRiXLR2zSU3BmHYGr7lCFWG8ez8riDetCEiIoZtZEz+srHoP7EHkRTniPEdj8N5dKXPjjJJjTDF6EZWDbHYbaFhHwf0Nslb/SfhRDLNIdIgaOQaKPoq40YwQPikadoKARgjQ==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886C0804A0240998C110EE58C7A9-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri, Apr 02, 2021 at 07:58:02AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Thursday, April 1, 2021 9:47 PM
> > 
> > On Thu, Apr 01, 2021 at 01:43:36PM +0000, Liu, Yi L wrote:
> > > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > Sent: Thursday, April 1, 2021 9:16 PM
> > > >
> > > > On Thu, Apr 01, 2021 at 01:10:48PM +0000, Liu, Yi L wrote:
> > > > > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > > > Sent: Thursday, April 1, 2021 7:47 PM
> > > > > [...]
> > > > > > I'm worried Intel views the only use of PASID in a guest is with
> > > > > > ENQCMD, but that is not consistent with the industry. We need to see
> > > > > > normal nested PASID support with assigned PCI VFs.
> > > > >
> > > > > I'm not quire flow here. Intel also allows PASID usage in guest without
> > > > > ENQCMD. e.g. Passthru a PF to guest, and use PASID on it without
> > > > ENQCMD.
> > > >
> > > > Then you need all the parts, the hypervisor calls from the vIOMMU, and
> > > > you can't really use a vPASID.
> > >
> > > This is a diagram shows the vSVA setup.
> > 
> > I'm not talking only about vSVA. Generic PASID support with arbitary
> > mappings.
> > 
> > And how do you deal with the vPASID vs pPASID issue if the system has
> > a mix of physical devices and mdevs?
> > 
> 
> We plan to support two schemes. One is vPASID identity-mapped to
> pPASID then the mixed scenario just works, with the limitation of 
> lacking of live migration support. The other is non-identity-mapped 
> scheme, where live migration is supported but physical devices and 
> mdevs should not be mixed in one VM if both expose SVA capability 
> (requires some filtering check in Qemu). 

That just becomes "block vPASID support if any device that
doesn't use ENQCMD is plugged into the guest"

Which needs a special VFIO capability of some kind so qemu knows to
block it. This really needs to all be layed out together so someone
can understand it :(

Why doesn't the siov cookbook explaining this stuff??

> We hope the /dev/ioasid can support both schemes, with the minimal
> requirement of allowing userspace to tag a vPASID to a pPASID and
> allowing mdev to translate vPASID into pPASID, i.e. not assuming that
> the guest will always use pPASID.

What I'm a unclear of is if /dev/ioasid even needs to care about
vPASID or if vPASID is just a hidden artifact of the KVM connection to
setup the translation table and the vIOMMU driver in qemu.

Since the physical HW never sees the vPASID I'm inclined to think the
latter.

Jason
