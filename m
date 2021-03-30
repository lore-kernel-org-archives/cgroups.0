From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Tue, 30 Mar 2021 01:37:05 +0000
Message-ID: <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-6-git-send-email-jacob.jun.pan@linux.intel.com>
 <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com> <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com> <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdkHWlLZVWbmowEFXz5ft+/3LXDayE8Wc7U1U+7L7cI=;
 b=bdK+9ya/HGBnsE+oNNS/y5E/1/NCnEUAwU7ul2Sa6iU2BHR27pOzlibm+aXZqSoGwYWmii3Z1X7ftYZkfOKAE3z8rr/r+zUvj+raSJu3/jjAuCl3GNoC/kKXPDk7xTTQzpA2OeBXqBpXyE3F2dVm5pn8g1Co22G/rZHC6bHaOvU=
In-Reply-To: <20210329163147.GG2356281-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
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
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Tuesday, March 30, 2021 12:32 AM
> 
> On Wed, Mar 24, 2021 at 12:05:28PM -0700, Jacob Pan wrote:
> 
> > > IMHO a use created PASID is either bound to a mm (current) at creation
> > > time, or it will never be bound to a mm and its page table is under
> > > user control via /dev/ioasid.
> > >
> > True for PASID used in native SVA bind. But for binding with a guest mm,
> > PASID is allocated first (VT-d virtual cmd interface Spec 10.4.44), the
> > bind with the host IOMMU when vIOMMU PASID cache is invalidated.
> >
> > Our intention is to have two separate interfaces:
> > 1. /dev/ioasid (allocation/free only)
> > 2. /dev/sva (handles all SVA related activities including page tables)
> 
> I'm not sure I understand why you'd want to have two things. Doesn't
> that just complicate everything?
> 
> Manipulating the ioasid, including filling it with page tables, seems
> an integral inseperable part of the whole interface. Why have two ?

Hi, Jason,

Actually above is a major open while we are refactoring vSVA uAPI toward
this direction. We have two concerns about merging /dev/ioasid with
/dev/sva, and would like to hear your thought whether they are valid.

First, userspace may use ioasid in a non-SVA scenario where ioasid is 
bound to specific security context (e.g. a control vq in vDPA) instead of 
tying to mm. In this case there is no pgtable binding initiated from user
space. Instead, ioasid is allocated from /dev/ioasid and then programmed
to the intended security context through specific passthrough framework
which manages that context.

Second, ioasid is managed per process/VM while pgtable binding is a
device-wise operation.  The userspace flow looks like below for an integral
/dev/ioasid interface:

-----------initialization----------
- ioctl(container->fd, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU)
- ioasid_fd = open(/dev/ioasid)
- ioctl(ioasid_fd, IOASID_GET_USVA_FD, &sva_fd) //an empty context
- ioctl(device->fd, VFIO_DEVICE_SET_SVA, &sva_fd); //sva_fd ties to device
- ioctl(sva_fd, USVA_GET_INFO, &sva_info);
-----------runtime----------------
- ioctl(ioasid_fd, IOMMU_ALLOC_IOASID, &ioasid);
- ioctl(sva_fd, USVA_BIND_PGTBL, &bind_data);
- ioctl(sva_fd, USVA_FLUSH_CACHE, &inv_info);
- ioctl(sva_fd, USVA_UNBIND_PGTBL, &unbind_data);
-----------destroy----------------
- ioctl(device->fd, VFIO_DEVICE_UNSET_SVA, &sva_fd);
- close(sva_fd)
- close(ioasid_fd)

Our hesitation here is based on one of your earlier comments that
you are not a fan of constructing fd's through ioctl. Are you OK with
above flow or have a better idea of handling it?

With separate interfaces then userspace just opens /dev/sva instead 
of getting it through ioasid_fd:

- ioasid_fd = open(/dev/ioasid)
- sva_fd = open(/dev/sva)

Thanks
Kevin
