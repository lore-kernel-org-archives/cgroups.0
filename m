From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 31 Mar 2021 09:38:01 -0300
Message-ID: <20210331123801.GD1463678@nvidia.com>
References: <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB18867EC048E3E3FA37F9C38F8C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132740.GB1403691@nvidia.com>
 <BN6PR11MB40688BB2693A657D411E33C8C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1qBHeqbqDUWGAnx/XsR6oQqvBRfPdQZlzErc5vGx/g=;
 b=EEixU/TW1BAfC4fPy8y/dFDD7KOs2wyTr1dSF2b1Q8mD0321Jx4F7LjCh56WCHSEGbdBpCKyWPUOAF6kfv4FiBBqkfftwrBEMb1U1HmLkT0uchXq2tNgQfqSJggscwASeCzHD/+FdhwX9ZPNMTRlrytrLbo5BNLYPzToRYo54DNphiWv2AYWSRH6fv2B4uS1CAJTzZClc182y+HMOvbLCwXF90Fb340OfKHsoRJciUa7uGXeQdgQ5U3Uo8mankXRUV1LRsZB3nDKidefINo0GZlCV2qKjoztyVuBmjTFLku7rAvBSldoDHdn663dy2T/mAWa+DjBQ2a517XwqSmXoA==
Content-Disposition: inline
In-Reply-To: <BN6PR11MB40688BB2693A657D411E33C8C37C9-1gF2/dm/6VuPGwkGT4HjsJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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

On Wed, Mar 31, 2021 at 07:41:40AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Tuesday, March 30, 2021 9:28 PM
> > 
> > On Tue, Mar 30, 2021 at 04:14:58AM +0000, Tian, Kevin wrote:
> > 
> > > One correction. The mdev should still construct the list of allowed PASID's
> > as
> > > you said (by listening to IOASID_BIND/UNBIND event), in addition to the
> > ioasid
> > > set maintained per VM (updated when a PASID is allocated/freed). The
> > per-VM
> > > set is required for inter-VM isolation (verified when a pgtable is bound to
> > the
> > > mdev/PASID), while the mdev's own list is necessary for intra-VM isolation
> > when
> > > multiple mdevs are assigned to the same VM (verified before loading a
> > PASID
> > > to the mdev). This series just handles the general part i.e. per-VM ioasid
> > set and
> > > leaves the mdev's own list to be managed by specific mdev driver which
> > listens
> > > to various IOASID events).
> > 
> > This is better, but I don't understand why we need such a convoluted
> > design.
> > 
> > Get rid of the ioasid set.
> >
> > Each driver has its own list of allowed ioasids.
> 
> First, I agree with you it's necessary to have a per-device allowed ioasid
> list. But besides it, I think we still need to ensure the ioasid used by a
> VM is really allocated to this VM. A VM should not use an ioasid allocated
> to another VM. right? Actually, this is the major intention for introducing
> ioasid_set.

The /dev/ioasid FD replaces this security check. By becoming FD
centric you don't need additional kernel security objects.

Any process with access to the /dev/ioasid FD is allowed to control
those PASID. The seperation between VMs falls naturally from the
seperation of FDs without creating additional, complicated, security
infrastrucure in the kernel.

This is why all APIs must be FD focused, and you need to have a
logical layering of responsibility.

 Allocate a /dev/ioasid FD
 Allocate PASIDs inside the FD
 Assign memory to the PASIDS

 Open a device FD, eg from VFIO or VDP
 Instruct the device FD to authorize the device to access PASID A in
 an ioasid FD
   * Prior to being authorized the device will have NO access to any
     PASID
   * Presenting BOTH the device FD and the ioasid FD to the kernel
     is the security check. Any process with both FDs is allowed to
     make the connection. This is normal Unix FD centric thinking.

> > Register a ioasid in the driver's list by passing the fd and ioasid #
> 
> The fd here is a device fd. Am I right? 

It would be the vfio_device FD, for instance, and a VFIO IOCTL.

> If yes, your idea is ioasid is allocated via /dev/ioasid and
> associated with device fd via either VFIO or vDPA ioctl. right?
> sorry I may be asking silly questions but really need to ensure we
> are talking in the same page.

Yes, this is right

> > No listening to events. A simple understandable security model.
> 
> For this suggestion, I have a little bit concern if we may have A-B/B-A
> lock sequence issue since it requires the /dev/ioasid (if it supports)
> to call back into VFIO/VDPA to check if the ioasid has been registered to
> device FD and record it in the per-device list. right? Let's have more
> discussion based on the skeleton sent by Kevin.

Callbacks would be backwards.

User calls vfio with vfio_device fd and dev/ioasid fd

VFIO extracts some kernel representation of the ioasid from the ioasid
fd using an API

VFIO does some kernel call to IOMMU/IOASID layer that says 'tell the
IOMMU that this PCI device is allowed to use this PASID'

VFIO mdev drivers then record that the PASID is allowed in its own
device specific struct for later checking during other system calls.

No lock inversions. No callbacks. Why do we need callbacks?? Simplify.

Jason
