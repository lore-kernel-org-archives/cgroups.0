From: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 31 Mar 2021 07:38:36 +0000
Message-ID: <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com> <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com> <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfZzyYOvAgqrnoGy4DGuutNufYd5UpeVnhF9GtZcpq8=;
 b=M2ZqP5AsYo/KWYNJELyXeJQn+IFAqaRuNN1lcfb5V0jsWIbURJR0u3buSyRrqVtC72a8TcJrmHBHumaaH1z9Gf5jelDAouk8kTdbZnPXDeqTpHxppNfx3xiE69+wiiRoE00KM8mOD9Kakp2/K9ZBOVt7F3oiJWNj90NS7l6dm1I=
In-Reply-To: <20210330132830.GO2356281-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang,
 Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jason,

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Tuesday, March 30, 2021 9:29 PM
> 
> On Tue, Mar 30, 2021 at 01:37:05AM +0000, Tian, Kevin wrote:
[...]
> > Hi, Jason,
> >
> > Actually above is a major open while we are refactoring vSVA uAPI toward
> > this direction. We have two concerns about merging /dev/ioasid with
> > /dev/sva, and would like to hear your thought whether they are valid.
> >
> > First, userspace may use ioasid in a non-SVA scenario where ioasid is
> > bound to specific security context (e.g. a control vq in vDPA) instead of
> > tying to mm. In this case there is no pgtable binding initiated from user
> > space. Instead, ioasid is allocated from /dev/ioasid and then programmed
> > to the intended security context through specific passthrough framework
> > which manages that context.
> 
> This sounds like the exact opposite of what I'd like to see.
> 
> I do not want to see every subsystem gaining APIs to program a
> PASID. All of that should be consolidated in *one place*.
> 
> I do not want to see VDPA and VFIO have two nearly identical sets of
> APIs to control the PASID.
> 
> Drivers consuming a PASID, like VDPA, should consume the PASID and do
> nothing more than authorize the HW to use it.
> 
> quemu should have general code under the viommu driver that drives
> /dev/ioasid to create PASID's and manage the IO mapping according to
> the guest's needs.
> 
> Drivers like VDPA and VFIO should simply accept that PASID and
> configure/authorize their HW to do DMA's with its tag.
> 
> > Second, ioasid is managed per process/VM while pgtable binding is a
> > device-wise operation.  The userspace flow looks like below for an integral
> > /dev/ioasid interface:
> >
> > - ioctl(container->fd, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU)
> > - ioasid_fd = open(/dev/ioasid)
> > - ioctl(ioasid_fd, IOASID_GET_USVA_FD, &sva_fd) //an empty context
> > - ioctl(device->fd, VFIO_DEVICE_SET_SVA, &sva_fd); //sva_fd ties to
> device
> > - ioctl(sva_fd, USVA_GET_INFO, &sva_info);
> > - ioctl(ioasid_fd, IOMMU_ALLOC_IOASID, &ioasid);
> > - ioctl(sva_fd, USVA_BIND_PGTBL, &bind_data);
> > - ioctl(sva_fd, USVA_FLUSH_CACHE, &inv_info);
> > - ioctl(sva_fd, USVA_UNBIND_PGTBL, &unbind_data);
> > - ioctl(device->fd, VFIO_DEVICE_UNSET_SVA, &sva_fd);
> > - close(sva_fd)
> > - close(ioasid_fd)
> >
> > Our hesitation here is based on one of your earlier comments that
> > you are not a fan of constructing fd's through ioctl. Are you OK with
> > above flow or have a better idea of handling it?
> 
> My reaction is to squash 'sva' and ioasid fds together, I can't see
> why you'd need two fds to manipulate a PASID.

The reason is /dev/ioasid FD is per-VM since the ioasid allocated to
the VM should be able to be shared by all assigned device for the VM.
But the SVA operations (bind/unbind page table, cache_invalidate) should
be per-device. If squashing the two fds to be one, then requires a device
tag for each vSVA ioctl. I'm not sure if it is good. Per me, it looks
better to have a SVA FD and associated with a device FD so that any ioctl
on it will be in the device level. This also benefits ARM and AMD's vSVA
support since they binds guest PASID table to host instead of binding
guest page tables to specific PASIDs.

Regards,
Yi Liu
