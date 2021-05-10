From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 10 May 2021 09:37:29 -0300
Message-ID: <20210510123729.GA1002214@nvidia.com>
References: <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder>
 <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder>
 <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder> <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmSBoeltOk61etEly/jceX2euJwTSIY+oVLf7nd2Jk4=;
 b=aImgd/qtrhpLbMoyieGcNkmxq2JfYWqPbmTZiwijZ4cZfEIUrUqSMADYAvgv+dICrQ2ifIG+HDEiSfJQ5pomE6vy9WWGGJFiWNpng9Ag4MBm2i0JNqEg0a3mDjEf5pyiEQkkrZ2xWyK1CbhnobaNFeqDZjC4ULenoDnssfCt3sFOG/Q7ycPJ1yRmog3CX92k1IPxhJDk0DFXkAQ9yqow/6EdDNgv7h8c2C2FvuGppqLTquppEKrlqJ3tO3bcQfhULySkN5KJ/xsODPzg+e0wVo8XA759lKdXWL7xT9olPdrmc0751r4QVA8Y2LIGm/hSXIwIVTo+YaR+wZs5h6W18w==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188698FBEE62AF1313E0F7AC8C569-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Sat, May 08, 2021 at 09:56:59AM +0000, Tian, Kevin wrote:
> > From: Raj, Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Sent: Friday, May 7, 2021 12:33 AM
> > 
> > > Basically it means when the guest's top level IOASID is created for
> > > nesting that IOASID claims all PASID's on the RID and excludes any
> > > PASID IOASIDs from existing on the RID now or in future.
> > 
> > The way to look at it this is as follows:
> > 
> > For platforms that do not have a need to support shared work queue model
> > support for ENQCMD or similar, PASID space is naturally per RID. There is no
> > complication with this. Every RID has the full range of PASID's and no need
> > for host to track which PASIDs are allocated now or in future in the guest.
> > 
> > For platforms that support ENQCMD, it is required to mandate PASIDs are
> > global across the entire system. Maybe its better to call them gPASID for
> > guest and hPASID for host. Short reason being gPASID->hPASID is a guest
> > wide mapping for ENQCMD and not a per-RID based mapping. (We covered
> > that
> > in earlier responses)
> > 
> > In our current implementation we actually don't separate this space, and
> > gPASID == hPASID. The iommu driver enforces that by using the custom
> > allocator and the architected interface that allows all guest vIOMMU
> > allocations to be proxied to host. Nothing but a glorified hypercall like
> > interface. In fact some OS's do use hypercall to get a hPASID vs using
> > the vCMD style interface.
> > 
> 
> After more thinking about the new interface, I feel gPASID==hPASID 
> actually causes some confusion in uAPI design. In concept an ioasid
> is not active until it's attached to a device, because it's just an ID
> if w/o a device. So supposedly an ioasid should reject all user commands
> before attach. However an guest likely asks for a new gPASID before
> attaching it to devices and vIOMMU. if gPASID==hPASID then Qemu 
> must request /dev/ioasid to allocate a hw_id for an ioasid which hasn't 
> been attached to any device, with the assumption on kernel knowledge 
> that this hw_id is from an global allocator w/o dependency on any 
> device. This doesn't sound a clean design, not to say it also conflicts 
> with live migration.

Everything must be explicit. The situation David pointed to of
qemu emulating a vIOMMU while running on a host with a different
platform/physical IOMMU must be considered.

If the vIOMMU needs specific behavior it must use /dev/iommu to ask
for it specifically and not just make wild assumptions about how the
platform works.

> gPASID!=hPASID has a problem when assigning a physical device which 
> supports both shared work queue (ENQCMD with PASID in MSR) 
> and dedicated work queue (PASID in device register) to a guest
> process which is associated to a gPASID. Say the host kernel has setup
> the hPASID entry with nested translation though /dev/ioasid. For 
> shared work queue the CPU is configured to translate gPASID in MSR 
> into **hPASID** before the payload goes out to the wire. However 
> for dedicated work queue the device MMIO register is directly mapped 
> to and programmed by the guest, thus containing a **gPASID** value
> implying DMA requests through this interface will hit IOMMU faults
> due to invalid gPASID entry. Having gPASID==hPASID is a simple 
> workaround here. mdev doesn't have this problem because the
> PASID register is in emulated control-path thus can be translated
> to hPASID manually by mdev driver.

This all must be explicit too.

If a PASID is allocated and it is going to be used with ENQCMD then
everything needs to know it is actually quite different than a PASID
that was allocated to be used with a normal SRIOV device, for
instance.

The former case can accept that the guest PASID is virtualized, while
the lattter can not.

This is also why PASID per RID has to be an option. When I assign a
full SRIOV function to the guest then that entire RID space needs to
also be assigned to the guest. Upon migration I need to take all the
physical PASIDs and rebuild them in another hypervisor exactly as is.

If you force all RIDs into a global PASID pool then normal SRIOV
migration w/PASID becomes impossible. ie ENQCMD breaks everything else
that should work.

This is why you need to sort all this out and why it feels like some
of the specs here have been mis-designed.

I'm not sure carving out ranges is really workable for migration.

I think the real answer is to carve out entire RIDs as being in the
global pool or not. Then the ENQCMD HW can be bundled together and
everything else can live in the natural PASID per RID world.

Jason
