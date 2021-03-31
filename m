From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 30 Mar 2021 17:10:41 -0700
Message-ID: <20210330171041.70f2d7d0@jacob-builder>
References: <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <20210329155526.2ad791a9@jacob-builder>
 <20210330134313.GP2356281@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20210330134313.GP2356281-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jason,

On Tue, 30 Mar 2021 10:43:13 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> > If two mdevs from the same PF dev are assigned to two VMs, the PASID
> > table will be shared. IOASID set ensures one VM cannot program another
> > VM's PASIDs. I assume 'secure context' is per VM when it comes to host
> > PASID.  
> 
> No, the mdev device driver must enforce this directly. It is the one
> that programms the physical shared HW, it is the one that needs a list
> of PASID's it is allowed to program *for each mdev*
> 
This requires the mdev driver to obtain a list of allowed PASIDs(possibly
during PASID bind time) prior to do enforcement. IMHO, the PASID enforcement
points are:
1. During WQ configuration (e.g.program MSI)
2. During work submission

For VT-d shared workqueue, there is no way to enforce #2 in mdev driver in
that the PASID is obtained from PASID MSR from the CPU and submitted w/o
driver involvement. The enforcement for #2 is in the KVM PASID translation
table, which is per VM.

For our current VFIO mdev model, bind guest page table does not involve
mdev driver. So this is a gap we must fill, i.e. include a callback from
mdev driver?

> ioasid_set doesn't seem to help at all, certainly not as a concept
> tied to /dev/ioasid.
> 
Yes, we can take the security role off ioasid_set once we have per mdev
list. However, ioasid_set being a per VM/mm entity also bridge
communications among kernel subsystems that don't have direct call path.
e.g. KVM, VDCM and IOMMU.

> > No. the mdev driver consults with IOASID core When the guest programs a
> > guest PASID on to he mdev. VDCM driver does a lookup:
> > host_pasid = ioasid_find_by_spid(ioasid_set, guest_pasid);  
> 
> This is the wrong layering. Tell the mdev device directly what it is
> allowed to do. Do not pollute the ioasid core with security stuff.
> 
> > > I'd say you shoul have a single /dev/ioasid per VM and KVM should
> > > attach to that - it should get all the global events/etc that are not
> > > device specific.
> > >   
> > You mean a single /dev/ioasid FD per VM and KVM? I think that is what we
> > are doing in this set. A VM process can only open /dev/ioasid once, then
> > use the FD for allocation and pass the PASID for bind page table etc.  
> 
> Yes, I think that is reasonable.
> 
> Tag all the IOCTL's with the IOASID number.
>  
> > > Not sure what guest-host PASID means, these have to be 1:1 for device
> > > assignment to work - why would use something else for mdev?
> > >   
> > We have G-H PASID translation. They don't have to be 1:1.
> > IOASID Set Private ID (SPID) is intended as a generic solution for
> > guest PASID. Could you review the secion Section: IOASID Set Private ID
> > (SPID) in the doc patch?  
> 
> Again this only works for MDEV? How would you do translation for a
> real PF/VF?
> 
Right, we will need some mediation for PF/VF.

> So when you 'allow' a mdev to access a PASID you want to say:
>  Allow Guest PASID A, map it to host PASID B on this /dev/ioasid FD
> 
> ?
> 
Host and guest PASID value, as well as device info are available through
iommu_uapi_sva_bind_gpasid(), we just need to feed that info to mdev driver.

> That seems like a good helper library to provide for drivers to use,
> but it should be a construct entirely contained in the driver.
why? would it be cleaner if it is in the common code?

Thanks,

Jacob
