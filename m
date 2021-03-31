From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 31 Mar 2021 09:34:57 -0700
Message-ID: <20210331093457.753512d4@jacob-builder>
References: <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <20210329155526.2ad791a9@jacob-builder>
 <20210330134313.GP2356281@nvidia.com>
 <20210330171041.70f2d7d0@jacob-builder>
 <20210331122805.GC1463678@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20210331122805.GC1463678-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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

On Wed, 31 Mar 2021 09:28:05 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, Mar 30, 2021 at 05:10:41PM -0700, Jacob Pan wrote:
>  [...]  
>  [...]  
>  [...]  
> > This requires the mdev driver to obtain a list of allowed
> > PASIDs(possibly during PASID bind time) prior to do enforcement. IMHO,
> > the PASID enforcement points are:
> > 1. During WQ configuration (e.g.program MSI)
> > 2. During work submission
> > 
> > For VT-d shared workqueue, there is no way to enforce #2 in mdev driver
> > in that the PASID is obtained from PASID MSR from the CPU and submitted
> > w/o driver involvement.  
> 
> I assume that the PASID MSR is privileged and only qemu can program
> it? Otherwise this seems like a security problem.
> 
yes.

> If qemu controls it then the idxd userspace driver in qemu must ensure
> it is only ever programmed to an authorized PASID.
> 
it is ensured for #1.

> > The enforcement for #2 is in the KVM PASID translation table, which
> > is per VM.  
> 
> I don't understand why KVM gets involved in PASID??
> 
Here is an excerpt from the SIOV spec.
https://software.intel.com/content/www/us/en/develop/download/intel-scalable-io-virtualization-technical-specification.html

"3.3 PASID translation
To support PASID isolation for Shared Work Queues used by VMs, the CPU must
provide a way for the PASID to be communicated to the device in the DMWr
transaction. On Intel CPUs, the CPU provides a PASID translation table in
the vCPUs virtual machine control structures. During ENQCMD/ENQCMDS
instruction execution in a VM, the PASID translation table is used by the
CPU to replace the guest PASID in the work descriptor with a host PASID
before the descriptor is sent to the device.3.3 PASID translation"

> Doesn't work submission go either to the mdev driver or through the
> secure PASID of #1?
> 
No, once a PASID is bound with IOMMU, KVM, and the mdev, work submission is
all done in HW.
But I don't think this will change for either uAPI design.

> > For our current VFIO mdev model, bind guest page table does not involve
> > mdev driver. So this is a gap we must fill, i.e. include a callback from
> > mdev driver?  
> 
> No not a callback, tell the mdev driver with a VFIO IOCTL that it is
> authorized to use a specific PASID because the vIOMMU was told to
> allow it by the guest kernel. Simple and straightforward.
> 
Make sense.

> > > ioasid_set doesn't seem to help at all, certainly not as a concept
> > > tied to /dev/ioasid.
> > >   
> > Yes, we can take the security role off ioasid_set once we have per mdev
> > list. However, ioasid_set being a per VM/mm entity also bridge
> > communications among kernel subsystems that don't have direct call path.
> > e.g. KVM, VDCM and IOMMU.  
> 
> Everything should revolve around the /dev/ioasid FD. qemu should pass
> it to all places that need to know about PASID's in the VM.
> 
I guess we need to extend KVM interface to support PASIDs. Our original
intention was to avoid introducing new interfaces.

> We should try to avoid hidden behind the scenes kernel
> interconnections between subsystems.
> 
Can we? in case of exception. Since all these IOCTLs are coming from the
unreliable user space, we must deal all exceptions.

For example, when user closes /dev/ioasid FD before (or w/o) unbind IOCTL
for VFIO, KVM, kernel must do cleanup and coordinate among subsystems.
In this patchset, we have a per mm(ioasid_set) notifier to inform mdev, KVM
to clean up and drop its refcount. Do you have any suggestion on this?

> 
> > > So when you 'allow' a mdev to access a PASID you want to say:
> > >  Allow Guest PASID A, map it to host PASID B on this /dev/ioasid FD
> > >   
> 
> > Host and guest PASID value, as well as device info are available through
> > iommu_uapi_sva_bind_gpasid(), we just need to feed that info to mdev
> > driver.  
> 
> You need that IOCTL to exist on the *mdev driver*. It is a VFIO ioctl,
> not a iommu or ioasid or sva IOCTL.
>
OK. A separate IOCTL and separate step.

> > > That seems like a good helper library to provide for drivers to use,
> > > but it should be a construct entirely contained in the driver.  
> > why? would it be cleaner if it is in the common code?  
> 
> No, it is the "mid layer" problematic design.
> 
> Having the iommu layer store driver-specific data on behalf of a
> driver will just make a mess. Use the natural layering we have and
> store driver specific data in the driver structs.
> 
> Add a library to help build the datastructure if it necessary.
> 
Let me try to paraphrase, you are suggesting common helper code and data
format but still driver specific storage of the mapping, correct?

Will try this out, seems cleaner.

> Jason


Thanks,

Jacob
