From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 1 Apr 2021 08:54:29 -0300
Message-ID: <20210401115429.GY1463678@nvidia.com>
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
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7N5icP71ZD/v1I/EQgOUCK1AgmVSlEGNRoPkTN5V5k=;
 b=rIqHp5jhJY4wEpOXp2JGc4edsmgedQRL8ekFflVLhIvM/lbXg0+HI/JoVx19qsOZq+7v3TCqNAhTpC0Nqw74WTcS3YXIhd3rEYEdcW+napx6eZTyHIHNUoBN20YAwpZz7Ip4RCcqTtqXiWqNATIb1wJd3LiNkQGuF0J8I6+Oam26VQL5sA4iwdpxSc9ZjBJUlvrimRrbIZeljCPm5WhA2TP12K/7eY/qLN5UO6PUJR2Y5aGMcva2vac/ozOlYJc4yBHgohiqUSWznj4XcAeUUoro0xeUoby8O3u1Q72PRLEusMAYgo/cIJl7DmbJ2JP8Mt4/F1MhrSSojA7QX4d28A==
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
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Apr 01, 2021 at 07:04:01AM +0000, Liu, Yi L wrote:

> After reading your reply in https://lore.kernel.org/linux-iommu/20210331123801.GD1463678-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org/#t
> So you mean /dev/ioasid FD is per-VM instead of per-ioasid, so above skeleton
> doesn't suit your idea.

You can do it one PASID per FD or multiple PASID's per FD. Most likely
we will have high numbers of PASID's in a qemu process so I assume
that number of FDs will start to be a contraining factor, thus
multiplexing is reasonable.

It doesn't really change anything about the basic flow.

digging deeply into it either seems like a reasonable choice.

> +-----------------------------+-----------------------------------------------+
> |      userspace              |               kernel space                    |
> +-----------------------------+-----------------------------------------------+
> | ioasid_fd =                 | /dev/ioasid does below:                       |
> | open("/dev/ioasid", O_RDWR);|   struct ioasid_fd_ctx {                      |
> |                             |       struct list_head ioasid_list;           |
> |                             |       ...                                     |
> |                             |   } ifd_ctx; // ifd_ctx is per ioasid_fd      |

Sure, possibly an xarray not a list

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
> |                             |            &ifd_ctx.ioasid_list);
> |

Yes, this should have a kref in it too

> +-----------------------------+-----------------------------------------------+
> | ioctl(device_fd,            | VFIO does below:                              |
> |       DEVICE_ALLOW_IOASID,  | 1) get ioasid_fd, check if ioasid_fd is valid |
> |       ioasid_fd,            | 2) check if ioasid is allocated from ioasid_fd|
> |       ioasid);              | 3) register device/domain info to /dev/ioasid |
> |                             |    tracked in id_data.device_list             |
> |                             | 4) record the ioasid in VFIO's per-device     |
> |                             |    ioasid list for future security check      |

You would provide a function that does steps 1&2 look at eventfd for
instance.

I'm not sure we need to register the device with the ioasid. device
should incr the kref on the ioasid_data at this point.

> +-----------------------------+-----------------------------------------------+
> | ioctl(ioasid_fd,            | /dev/ioasid does below:                       |
> |       BIND_PGTBL,           | 1) find ioasid's id_data                      |
> |       pgtbl_data,           | 2) loop the id_data.device_list and tell iommu|
> |       ioasid);              |    give ioasid access to the devices
> |

This seems backwards, DEVICE_ALLOW_IOASID should tell the iommu to
give the ioasid to the device.

Here the ioctl should be about assigning a memory map from the the current
mm_struct to the pasid

> +-----------------------------+-----------------------------------------------+
> | ioctl(ioasid_fd,            | /dev/ioasid does below:                       |
> |       UNBIND_PGTBL,         | 1) find ioasid's id_data                      |
> |       ioasid);              | 2) loop the id_data.device_list and tell iommu|
> |                             |    clear ioasid access to the devices         |

Also seems backwards. The ioctl here should be 'destroy ioasid' which
wipes out the page table, halts DMA access and parks the PASID until
all users are done.

> +-----------------------------+-----------------------------------------------+
> | ioctl(device_fd,            | VFIO does below:                              |
> |      DEVICE_DISALLOW_IOASID,| 1) check if ioasid is associated in VFIO's    |
> |       ioasid_fd,            |    device ioasid list.                        |
> |       ioasid);              | 2) unregister device/domain info from         |
> |                             |    /dev/ioasid, clear in id_data.device_list  |

This should disconnect the iommu and kref_put the ioasid_data

Remember the layering, only the device_fd knows what the pci_device is
that it is touching, it doesn't make alot of sense to leak that into
the ioasid world that should only be dealing with the page table
mapping.

> +-----------------------------+-----------------------------------------------+
> | ioctl(ioasid_fd,            | /dev/ioasid does below:                       |
> |       FREE, ioasid);        |  list_del(&id_data.next);                     |
> +-----------------------------+-----------------------------------------------+

Don't know if we need a free. The sequence above is backwards, the
page table should be setup, the device authorized, device
de-authorized then page table destroyed. PASID recycles once everyone
is released.

Include a sequence showing how the kvm FD is used to program the
vPASID to pPASID table that ENQCMD uses.

Show how dynamic authorization works based on requests from the
guest's vIOMMU

Jason
