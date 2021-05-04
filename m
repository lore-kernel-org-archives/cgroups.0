From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 4 May 2021 09:22:55 -0700
Message-ID: <20210504092255.76c387f8@jacob-builder>
References: <20210421175203.GN1370958@nvidia.com>
        <20210421133312.15307c44@redhat.com>
        <20210421230301.GP1370958@nvidia.com>
        <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210422121020.GT1370958@nvidia.com>
        <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210423114944.GF1370958@nvidia.com>
        <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210426123817.GQ1370958@nvidia.com>
        <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210428204606.GX1370958@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210428204606.GX1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jacob.jun.p

Hi Jason,

On Wed, 28 Apr 2021 17:46:06 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> > > I think the name IOASID is fine for the uAPI, the kernel version can
> > > be called ioasid_id or something.  
> > 
> > ioasid is already an id and then ioasid_id just adds confusion. Another
> > point is that ioasid is currently used to represent both PCI PASID and
> > ARM substream ID in the kernel. It implies that if we want to separate
> > ioasid and pasid in the uAPI the 'pasid' also needs to be replaced with
> > another general term usable for substream ID. Are we making the
> > terms too confusing here?  
> 
> This is why I also am not so sure about exposing the PASID in the API
> because it is ultimately a HW specific item.
> 
> As I said to David, one avenue is to have some generic uAPI that is
> very general and keep all this deeply detailed stuff, that really only
> matters for qemu, as part of a more HW specific vIOMMU driver
> interface.
I think it is not just for QEMU. I am assuming you meant PASID is
needed for guest driver to program assigned but not mediated devices.

User space drivers may also need to get the real HW PASID to program it on
to the HW. So this uAPI need to provide some lookup functionality. Perhaps
the kernel generic version can be called ioasid_hw_id?

So we have the following per my understanding:
- IOASID: a userspace logical number which identifies a page table, this can
be a first level (GVA-GPA), or a second level (GPA->HPA) page table.
- PASID: strictly defined in PCIe term
- Substream ID: strictly defined in ARM SMMUv3 spec.
- IOASID_HW_ID: a generic ID backed by PASID, Substream ID, or any other
		 HW IDs used to tag DMA

Is that right?

Thanks,

Jacob
