From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 1 Apr 2021 09:12:39 -0300
Message-ID: <20210401121239.GB1463678@nvidia.com>
References: <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SxDW66bzJySId9P/AAnAjijo99XEGeaWorQyE7VnhE=;
 b=ovKIIBBWR753aRzH9COKDHr4d771vCi+CfgK6ryiK9xRjit9rFnvntefNPw8oI8TSWtWGysQUhIBNx7MbeBSW3Ba3/xeDK0ICPL0OKeIihRVHiThxwSGPUJCMYMho/5t64Pm697aIxSKb3nhBIG1NUXEtYD9mGNk0AOgtHQOXnt8iYa0MjxkKbwqq5bXZg2Xqn7uZVPzp7+7hkJ8Y0p2L7tGPR4p80gmZoLCsFY5etwC/lrp63BjkHvhOJTUAbrz58Xn8pJCcnG70ACtUEG5+Wf561cx1DvNEjUwa01MsLR7nqW9+uJxNNSMOdCJ2EQ1w3klbOnrA4GNJoLgSr5mWw==
Content-Disposition: inline
In-Reply-To: <YGW27KFt9eQB9X2z@myrica>
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
To: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang,
 Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Apr 01, 2021 at 02:05:00PM +0200, Jean-Philippe Brucker wrote:
> On Thu, Apr 01, 2021 at 07:04:01AM +0000, Liu, Yi L wrote:
> > > - how about AMD and ARM's vSVA support? Their PASID allocation and page
> > > table
> > >   happens within guest. They only need to bind the guest PASID table to
> > > host.
> 
> In this case each VM has its own IOASID space, and the host IOASID
> allocator doesn't participate. Plus this only makes sense when assigning a
> whole VF to a guest, and VFIO is the tool for this. So I wouldn't shoehorn
> those ops into /dev/ioasid, though we do need a transport for invalidate
> commands.

How does security work? Devices still have to be authorized to use the
PASID and this approach seems like it completely excludes mdev/vdpa
from ever using a PASID, and those are the most logical users.

> > >   Above model seems unable to fit them. (Jean, Eric, Jacob please feel free
> > >   to correct me)
> > > - this per-ioasid SVA operations is not aligned with the native SVA usage
> > >   model. Native SVA bind is per-device.
> 
> Bare-metal SVA doesn't need /dev/ioasid either. 

It depends what you are doing. /dev/ioasid would provide fine grained
control over the memory mapping. It is not strict SVA, but I can see
applications where using a GPU with a pre-configured optimized mapping
could be interesting.

> A program uses a device handle to either ask whether SVA is enabled,
> or to enable it explicitly.  With or without /dev/ioasid, that step
> is required. OpenCL uses the first method - automatically enable
> "fine-grain system SVM" if available, and provide a flag to
> userspace.

SVA can be done with ioasid, we can decide if it makes sense to have
shortcuts in every driver

> So userspace does not need to know about PASID. It's only one method for
> doing SVA (some GPUs are context-switching page tables instead).

Sure, there are lots of approaches. Here we are only talking about
PASID enablement. PASID has more options.
 
> * Page faults, page response. From and to devices, and don't necessarily
>   have a PASID. But needed by vdpa as well, so that's also going through
>   /dev/ioasid?

Only real PASID's should use this interface. All the not-PASID stuff
is on its own.

VPDA should accept a PASID from here and configure&authorize the real
HW to attach the PASID to all DMA's connected to the virtio queues.

Jason
