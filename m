From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 31 Mar 2021 16:46:21 -0700
Message-ID: <20210331164621.5f0b0d63@jacob-builder>
References: <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB18867EC048E3E3FA37F9C38F8C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132740.GB1403691@nvidia.com>
 <BN6PR11MB40688BB2693A657D411E33C8C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331123801.GD1463678@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20210331123801.GD1463678-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jason,

On Wed, 31 Mar 2021 09:38:01 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> > > Get rid of the ioasid set.
> > >
> > > Each driver has its own list of allowed ioasids.  
>  [...]  
> 
> The /dev/ioasid FD replaces this security check. By becoming FD
> centric you don't need additional kernel security objects.
> 
> Any process with access to the /dev/ioasid FD is allowed to control
> those PASID. The seperation between VMs falls naturally from the
> seperation of FDs without creating additional, complicated, security
> infrastrucure in the kernel.
> 
> This is why all APIs must be FD focused, and you need to have a
> logical layering of responsibility.
> 
>  Allocate a /dev/ioasid FD
>  Allocate PASIDs inside the FD
>  Assign memory to the PASIDS
> 
>  Open a device FD, eg from VFIO or VDP
>  Instruct the device FD to authorize the device to access PASID A in
>  an ioasid FD
How do we know user provided PASID A was allocated by the ioasid FD?
Shouldn't we validate user input by tracking which PASIDs are allocated by
which ioasid FD? This is one reason why we have ioasid_set and its xarray.

>    * Prior to being authorized the device will have NO access to any
>      PASID
>    * Presenting BOTH the device FD and the ioasid FD to the kernel
>      is the security check. Any process with both FDs is allowed to
>      make the connection. This is normal Unix FD centric thinking.
> 
> > > Register a ioasid in the driver's list by passing the fd and ioasid #
> > >  
> > 
> > The fd here is a device fd. Am I right?   
> 
> It would be the vfio_device FD, for instance, and a VFIO IOCTL.
> 
> > If yes, your idea is ioasid is allocated via /dev/ioasid and
> > associated with device fd via either VFIO or vDPA ioctl. right?
> > sorry I may be asking silly questions but really need to ensure we
> > are talking in the same page.  
> 
> Yes, this is right
> 
> > > No listening to events. A simple understandable security model.  
> > 
> > For this suggestion, I have a little bit concern if we may have A-B/B-A
> > lock sequence issue since it requires the /dev/ioasid (if it supports)
> > to call back into VFIO/VDPA to check if the ioasid has been registered
> > to device FD and record it in the per-device list. right? Let's have
> > more discussion based on the skeleton sent by Kevin.  
> 
> Callbacks would be backwards.
> 
> User calls vfio with vfio_device fd and dev/ioasid fd
> 
> VFIO extracts some kernel representation of the ioasid from the ioasid
> fd using an API
> 
This lookup API seems to be asking for per ioasid FD storage array. Today,
the ioasid_set is per mm and contains a Xarray. Since each VM, KVM can only
open one ioasid FD, this per FD array would be equivalent to the per mm
ioasid_set, right?

> VFIO does some kernel call to IOMMU/IOASID layer that says 'tell the
> IOMMU that this PCI device is allowed to use this PASID'
> 
Would it be redundant to what iommu_uapi_sva_bind_gpasid() does? I thought
the idea is to use ioasid FD IOCTL to issue IOMMU uAPI calls. Or we can
skip this step for now and wait for the user to do SVA bind.

> VFIO mdev drivers then record that the PASID is allowed in its own
> device specific struct for later checking during other system calls.


Thanks,

Jacob
