From: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 1 Apr 2021 14:05:00 +0200
Message-ID: <YGW27KFt9eQB9X2z@myrica>
References: <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=VYLRwOTaWYW2z/hdkbfC5Hb+/bml3aFiLVAb7iH5y5U=;
 b=T5/EZgsNWYvWOQYgR1iqHUswyZyy/ySbnJl+K6AMxf53GW61QFhYWgQJGadYeU9aLg
 bPKC1laCu3/Ih0DCjVXgv1dGJ0uZTBGRg75RCrmrdwxatAAzAR/MajoHaiA8mNXuMiKb
 W98rgPel0JxE3vIjfE5Z/0Ud5sXoegvU55MZUrDfgbWuV+ST3HE9afJFEB49yIGk4vpi
 vIZAVgzScOJBo/yxQvP/GaRKKOto4df7lSqS6tRCj2KDrmxMGLF7Bj1KPg7H5JCjGWCf
 fbWE/CS2GIv8VcBwAmcWsOhOnxQU2234Q4saAAdEl9WUBzi2deDEOuHfMUoJfCvlVreb
 fq3g==
Content-Disposition: inline
In-Reply-To: <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9-1gF2/dm/6VuPGwkGT4HjsJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Apr 01, 2021 at 07:04:01AM +0000, Liu, Yi L wrote:
> > - how about AMD and ARM's vSVA support? Their PASID allocation and page
> > table
> >   happens within guest. They only need to bind the guest PASID table to
> > host.

In this case each VM has its own IOASID space, and the host IOASID
allocator doesn't participate. Plus this only makes sense when assigning a
whole VF to a guest, and VFIO is the tool for this. So I wouldn't shoehorn
those ops into /dev/ioasid, though we do need a transport for invalidate
commands.

> >   Above model seems unable to fit them. (Jean, Eric, Jacob please feel free
> >   to correct me)
> > - this per-ioasid SVA operations is not aligned with the native SVA usage
> >   model. Native SVA bind is per-device.

Bare-metal SVA doesn't need /dev/ioasid either. A program uses a device
handle to either ask whether SVA is enabled, or to enable it explicitly.
With or without /dev/ioasid, that step is required. OpenCL uses the first
method - automatically enable "fine-grain system SVM" if available, and
provide a flag to userspace.

So userspace does not need to know about PASID. It's only one method for
doing SVA (some GPUs are context-switching page tables instead).

> After reading your reply in https://lore.kernel.org/linux-iommu/20210331123801.GD1463678-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org/#t
> So you mean /dev/ioasid FD is per-VM instead of per-ioasid, so above skeleton
> doesn't suit your idea. I draft below skeleton to see if our mind is the
> same. But I still believe there is an open on how to fit ARM and AMD's
> vSVA support in this the per-ioasid SVA operation model. thoughts?
> 
> +-----------------------------+-----------------------------------------------+
> |      userspace              |               kernel space                    |
> +-----------------------------+-----------------------------------------------+
> | ioasid_fd =                 | /dev/ioasid does below:                       |
> | open("/dev/ioasid", O_RDWR);|   struct ioasid_fd_ctx {                      |
> |                             |       struct list_head ioasid_list;           |
> |                             |       ...                                     |
> |                             |   } ifd_ctx; // ifd_ctx is per ioasid_fd      |
> +-----------------------------+-----------------------------------------------+
> | ioctl(ioasid_fd,            | /dev/ioasid does below:                       |
> |       ALLOC, &ioasid);      |   struct ioasid_data {                        |
> |                             |       ioasid_t ioasid;                        |
> |                             |       struct list_head device_list;           |
> |                             |       struct list_head next;                  |
> |                             |       ...                                     |
> |                             |   } id_data; // id_data is per ioasid         |
> |                             |                                               |
> |                             |   list_add(&id_data.next,                     |
> |                             |            &ifd_ctx.ioasid_list);             |
> +-----------------------------+-----------------------------------------------+
> | ioctl(device_fd,            | VFIO does below:                              |
> |       DEVICE_ALLOW_IOASID,  | 1) get ioasid_fd, check if ioasid_fd is valid |
> |       ioasid_fd,            | 2) check if ioasid is allocated from ioasid_fd|
> |       ioasid);              | 3) register device/domain info to /dev/ioasid |
> |                             |    tracked in id_data.device_list             |
> |                             | 4) record the ioasid in VFIO's per-device     |
> |                             |    ioasid list for future security check      |
> +-----------------------------+-----------------------------------------------+
> | ioctl(ioasid_fd,            | /dev/ioasid does below:                       |
> |       BIND_PGTBL,           | 1) find ioasid's id_data                      |
> |       pgtbl_data,           | 2) loop the id_data.device_list and tell iommu|
> |       ioasid);              |    give ioasid access to the devices          |
> +-----------------------------+-----------------------------------------------+
> | ioctl(ioasid_fd,            | /dev/ioasid does below:                       |
> |       UNBIND_PGTBL,         | 1) find ioasid's id_data                      |
> |       ioasid);              | 2) loop the id_data.device_list and tell iommu|
> |                             |    clear ioasid access to the devices         |
> +-----------------------------+-----------------------------------------------+
> | ioctl(device_fd,            | VFIO does below:                              |
> |      DEVICE_DISALLOW_IOASID,| 1) check if ioasid is associated in VFIO's    |
> |       ioasid_fd,            |    device ioasid list.                        |
> |       ioasid);              | 2) unregister device/domain info from         |
> |                             |    /dev/ioasid, clear in id_data.device_list  |
> +-----------------------------+-----------------------------------------------+
> | ioctl(ioasid_fd,            | /dev/ioasid does below:                       |
> |       FREE, ioasid);        |  list_del(&id_data.next);                     |
> +-----------------------------+-----------------------------------------------+


Also wondering about:

* Querying IOMMU nesting capabilities before binding page tables (which
  page table formats are supported?). We were planning to have a VFIO cap,
  but I'm guessing we need to go back to the sysfs solution?

* Invalidation, probably an ioasid_fd ioctl?

* Page faults, page response. From and to devices, and don't necessarily
  have a PASID. But needed by vdpa as well, so that's also going through
  /dev/ioasid?

Thanks,
Jean
