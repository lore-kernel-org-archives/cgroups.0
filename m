From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 1 Apr 2021 08:46:48 -0300
Message-ID: <20210401114648.GX1463678@nvidia.com>
References: <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QB7ETdOOSqNiwN0jeb2a8uAGrb0Crvt+uIkVaGv4B/g=;
 b=iPfpRV6LrLzrf5O/1m9biJLk5b3xUOR8KcqzPKhAFyra/baTxbPBO/0Kc4FB4veUdsq1yVW12xIbp6vQ/BzQ/8L0jTNql+s6h/IxwVZMW0E+x13nxwYrD0B13Wll2lQ2kPnb77zgwB7wb8j3I976TJ41A4fms0xMvs7ykQtJcdhiRDicRyDHSwIJ6WkAOvztq0dx09g7gWTWyxbQGSCO8oAdi8yJI+Vmp6kCDLW7iYlEGOi8pbeLfV8VBNaMbL6Yl8pGRmhCR9/N+qTkTNg0qXqUWVvgV5wzlaAH9rrfuFJlZNk5+nr66vhCw3zNQ9sr66wMS5WFppRNQMz8BqVY/w==
Content-Disposition: inline
In-Reply-To: <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9-1gF2/dm/6VuPGwkGT4HjsJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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
To: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Apr 01, 2021 at 04:38:44AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Wednesday, March 31, 2021 8:41 PM
> > 
> > On Wed, Mar 31, 2021 at 07:38:36AM +0000, Liu, Yi L wrote:
> > 
> > > The reason is /dev/ioasid FD is per-VM since the ioasid allocated to
> > > the VM should be able to be shared by all assigned device for the VM.
> > > But the SVA operations (bind/unbind page table, cache_invalidate) should
> > > be per-device.
> > 
> > It is not *per-device* it is *per-ioasid*
> >
> > And as /dev/ioasid is an interface for controlling multiple ioasid's
> > there is no issue to also multiplex the page table manipulation for
> > multiple ioasids as well.
> > 
> > What you should do next is sketch out in some RFC the exactl ioctls
> > each FD would have and show how the parts I outlined would work and
> > point out any remaining gaps.
> > 
> > The device FD is something like the vfio_device FD from VFIO, it has
> > *nothing* to do with PASID beyond having a single ioctl to authorize
> > the device to use the PASID. All control of the PASID is in
> > /dev/ioasid.
> 
> good to see this reply. Your idea is much clearer to me now. If I'm getting
> you correctly. I think the skeleton is something like below:
> 
> 1) userspace opens a /dev/ioasid, meanwhile there will be an ioasid
>    allocated and a per-ioasid context which can be used to do bind page
>    table and cache invalidate, an ioasid FD returned to userspace.
> 2) userspace passes the ioasid FD to VFIO, let it associated with a device
>    FD (like vfio_device FD).
> 3) userspace binds page table on the ioasid FD with the page table info.
> 4) userspace unbinds the page table on the ioasid FD
> 5) userspace de-associates the ioasid FD and device FD
> 
> Does above suit your outline?

Seems so

> If yes, I still have below concern and wish to see your opinion.
> - the ioasid FD and device association will happen at runtime instead of
>   just happen in the setup phase.

Of course, this is required for security. The vIOMMU must perform the
device association when the guest requires it. Otherwise a guest
cannot isolate a PASID to a single process/device pair.

I'm worried Intel views the only use of PASID in a guest is with
ENQCMD, but that is not consistent with the industry. We need to see
normal nested PASID support with assigned PCI VFs.

> - how about AMD and ARM's vSVA support? Their PASID allocation and page table
>   happens within guest. They only need to bind the guest PASID table to host.
>   Above model seems unable to fit them. (Jean, Eric, Jacob please feel free
>   to correct me)

No, everything needs the device association step or it is not
secure. 

You can give a PASID to a guest and allow it to manipulate it's memory
map directly, nested under the guest's CPU page tables.

However the guest cannot authorize a PCI BDF to utilize that PASID
without going through some kind of step in the hypervisor. A Guest
should not be able to authorize a PASID for a BDF it doesn't have
access to - only the hypervisor can enforce this.

This all must also fit into the mdev model where only the
device-specific mdev driver can do the device specific PASID
authorization. A hypercall is essential, or we need to stop pretending
mdev is a good idea.

I'm sure there will be some small differences, and you should clearly
explain the entire uAPI surface so that soneone from AMD and ARM can
review it.

> - this per-ioasid SVA operations is not aligned with the native SVA usage
>   model. Native SVA bind is per-device.

Seems like that is an error in native SVA.

SVA is a particular mode of the PASID's memory mapping table, it has
nothing to do with a device.

Jason
