From: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 10 May 2021 09:22:12 -0700
Message-ID: <20210510162212.GB90095@otc-nc-03>
References: <20210505102259.044cafdf@jacob-builder>
 <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder> <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <20210510152502.GA90095@otc-nc-03>
 <20210510153111.GB1002214@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210510153111.GB1002214-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Mon, May 10, 2021 at 12:31:11PM -0300, Jason Gunthorpe wrote:
> On Mon, May 10, 2021 at 08:25:02AM -0700, Raj, Ashok wrote:
> 
> > Global PASID doesn't break anything, but giving that control to vIOMMU
> > doesn't seem right. When we have mixed uses cases like hardware that
> > supports shared wq and SRIOV devices that need PASIDs we need to 
> > comprehend how they will work without having a backend to migrate PASIDs 
> > to new destination.
> 
> Why wouldn't there be a backend? SRIOV live migration is a real thing
> now (see Max's VFIO patches). The PASID space of the entire dedicated
> RID needs to be migratable, which means the destination vIOMMU must be
> able to program its local hardware with the same PASID numbers and any
> kind of global PASID scheme at all will interfere with it.

The way I'm imagining it works is as follows. We have 2 types of platforms.
Let me know if i missed something.

- no shared wq, meaning RID local PASID allocation is all that's needed.
  Say platform type p1
- Shared WQ configurations that require global PASIDs.
  Say platform type p2

vIOMMU might have a capability to indicate if vIOMMU has a PASID allocation
capability. If there is none, guest is free to obtain its own PASID per
RID since they are fully isolated. For p1 type platforms this should work.
Since there is no Qemu interface even required or /dev/iommu for that
instance. Guest kernel can manage it fully per-RID based.

Platform type p2 that has both SIOV (with enqcmd) and SRIOV that requires
PASID. My thought was to reserve say some number of PASID's for per-RID
use. When you request a RID local you get PASID in that range. When you ask
for global, you get in the upper PASID range. 

Say 0-4k is reserved for any RID local allocation. This is also the guest
PASID range.  4k->2^19 are for shared WQ. (I'm not implying the size, but 
just for discussion sake that we need a separation.)

Those vIOMMU's will have a capability that it supports PASID allocation
interface. When you allocate you can say what type of PASID you need
(shared vs local) and Qemu will obtain either within the local range, or in
the shared range. When they are allocated in the shared range, you still
end up using one in guest PASID range, but mapped to a different
host-pasid using the VMCS like PASID redirection per-guest (not-perRID).

Only the shared allocation requires /dev/iommu interface. All allocation in
the guest range is fully in Qemu control.

For supporting migration, the target also needs to have this capability for
migration. 
> 
> > When we have both SRIOV and shared WQ exposed to the same guest, we 
> > do have an issue. The simplest way that I thought was to have a guest 
> > and host PASID separation.  Where the guest has its own PASID  space 
> > and host has its own carved out.  Guest can do what ever it wants within 
> > that allocated space without fear of any collition with any other device. 
> 
> And how do you reliably migrate if the target kernel has a PASID
> already allocated in that range?

For any shared range, remember there is a mapping table. And since those
ranges are always reserved in the new host it isn't a problem. For shared
WQ that requires a PASID remapping to new host PASID, the VMCS remapping
per guest that does gPASID->hPASID does this job. So the guest PASID
remains unchanged. 

Does this make sense? 

Cheers,
Ashok
