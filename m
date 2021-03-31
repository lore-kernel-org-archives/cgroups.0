From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 31 Mar 2021 09:28:05 -0300
Message-ID: <20210331122805.GC1463678@nvidia.com>
References: <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <20210329155526.2ad791a9@jacob-builder>
 <20210330134313.GP2356281@nvidia.com>
 <20210330171041.70f2d7d0@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxbQytUr9+fpQTmbz09WMWQ5YuxnEIGMLAZU/zYwuzY=;
 b=jtbNqQBqs4lspf4bAsJofdQyYdMMpAAoID+L8q3Btti2yolcmrP9OlM8RJG1cL6xEc3Cu6Sgl9pljQCgeA3tjL05QFtWgd8T46myaAzoLiQRmnZzDFyXOPO827cq2knIo8LE++9IowAXzgYOORpnK+x43Fn84vnWghiKTrE8/KyIwuDtXiwxob4xf1Z/qIOvVuTIFEuOQ2NzUoWE/D3DC/KQAvhfqY2ajxsl5e52PoWs4DXajdcD4yaDXIfJBZTQqGmATwRybkDN2Hy4xNT0gRwyLh25rVcNEoqFfZT6LUhBW2YdnWOVZIJ2FRjQeNurbAy8WkP8udSZepoPXKmpkA==
Content-Disposition: inline
In-Reply-To: <20210330171041.70f2d7d0@jacob-builder>
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
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Tue, Mar 30, 2021 at 05:10:41PM -0700, Jacob Pan wrote:
> Hi Jason,
> 
> On Tue, 30 Mar 2021 10:43:13 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > > If two mdevs from the same PF dev are assigned to two VMs, the PASID
> > > table will be shared. IOASID set ensures one VM cannot program another
> > > VM's PASIDs. I assume 'secure context' is per VM when it comes to host
> > > PASID.  
> > 
> > No, the mdev device driver must enforce this directly. It is the one
> > that programms the physical shared HW, it is the one that needs a list
> > of PASID's it is allowed to program *for each mdev*
> > 
> This requires the mdev driver to obtain a list of allowed PASIDs(possibly
> during PASID bind time) prior to do enforcement. IMHO, the PASID enforcement
> points are:
> 1. During WQ configuration (e.g.program MSI)
> 2. During work submission
> 
> For VT-d shared workqueue, there is no way to enforce #2 in mdev driver in
> that the PASID is obtained from PASID MSR from the CPU and submitted w/o
> driver involvement.

I assume that the PASID MSR is privileged and only qemu can program
it? Otherwise this seems like a security problem.

If qemu controls it then the idxd userspace driver in qemu must ensure
it is only ever programmed to an authorized PASID.

> The enforcement for #2 is in the KVM PASID translation table, which
> is per VM.

I don't understand why KVM gets involved in PASID??

Doesn't work submission go either to the mdev driver or through the
secure PASID of #1?

> For our current VFIO mdev model, bind guest page table does not involve
> mdev driver. So this is a gap we must fill, i.e. include a callback from
> mdev driver?

No not a callback, tell the mdev driver with a VFIO IOCTL that it is
authorized to use a specific PASID because the vIOMMU was told to
allow it by the guest kernel. Simple and straightforward.

> > ioasid_set doesn't seem to help at all, certainly not as a concept
> > tied to /dev/ioasid.
> > 
> Yes, we can take the security role off ioasid_set once we have per mdev
> list. However, ioasid_set being a per VM/mm entity also bridge
> communications among kernel subsystems that don't have direct call path.
> e.g. KVM, VDCM and IOMMU.

Everything should revolve around the /dev/ioasid FD. qemu should pass
it to all places that need to know about PASID's in the VM.

We should try to avoid hidden behind the scenes kernel
interconnections between subsystems.


> > So when you 'allow' a mdev to access a PASID you want to say:
> >  Allow Guest PASID A, map it to host PASID B on this /dev/ioasid FD
> > 

> Host and guest PASID value, as well as device info are available through
> iommu_uapi_sva_bind_gpasid(), we just need to feed that info to mdev driver.

You need that IOCTL to exist on the *mdev driver*. It is a VFIO ioctl,
not a iommu or ioasid or sva IOCTL.
 
> > That seems like a good helper library to provide for drivers to use,
> > but it should be a construct entirely contained in the driver.
> why? would it be cleaner if it is in the common code?

No, it is the "mid layer" problematic design.

Having the iommu layer store driver-specific data on behalf of a
driver will just make a mess. Use the natural layering we have and
store driver specific data in the driver structs.

Add a library to help build the datastructure if it necessary.

Jason
