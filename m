From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 1 Apr 2021 13:03:37 -0300
Message-ID: <20210401160337.GJ1463678@nvidia.com>
References: <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FzW2BYP3ezifTSicTa4DSrM25NdyzyyIuxKnyri/X1I=;
 b=cfICuL1ll+qfpY/WKb7rUzig5uRYwC+DwFsMrEWm4UJaN75y6zvmmDzAlLtz55gDlHWu4dYpyv1bezVSERorqn/JhLQs9rnnHd7QXY0bjLOD8r/HDBuLSsY4TpxvtrzgNKg5eG2QBcPcwIZgjzLv7mLH3zzazBxs9B8GOacSsrBDHxJQ2YiQTY6JYBAuN+9BHN1GwccQLJyolxFvTzojDCHzD43Dx/YFaJHRP29PkDZKv5ovmoYAC7LYVpyI+s4KBefZzUoGjIn6bO2Ru7P0S9QmZYRkq6+1Jx6FoJsR0EvGwrdblUqDMseaeNl6bIV6FmiQ4PzwYjqoLZQ3N/F6Fg==
Content-Disposition: inline
In-Reply-To: <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9-1gF2/dm/6VuPGwkGT4HjsJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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

On Thu, Apr 01, 2021 at 02:08:17PM +0000, Liu, Yi L wrote:

> DMA page faults are delivered to root-complex via page request message and
> it is per-device according to PCIe spec. Page request handling flow is:
> 
> 1) iommu driver receives a page request from device
> 2) iommu driver parses the page request message. Get the RID,PASID, faulted
>    page and requested permissions etc.
> 3) iommu driver triggers fault handler registered by device driver with
>    iommu_report_device_fault()

This seems confused.

The PASID should define how to handle the page fault, not the driver.

I don't remember any device specific actions in ATS, so what is the
driver supposed to do?

> 4) device driver's fault handler signals an event FD to notify userspace to
>    fetch the information about the page fault. If it's VM case, inject the
>    page fault to VM and let guest to solve it.

If the PASID is set to 'report page fault to userspace' then some
event should come out of /dev/ioasid, or be reported to a linked
eventfd, or whatever.

If the PASID is set to 'SVM' then the fault should be passed to
handle_mm_fault

And so on.

Userspace chooses what happens based on how they configure the PASID
through /dev/ioasid.

Why would a device driver get involved here?

> Eric has sent below series for the page fault reporting for VM with passthru
> device.
> https://lore.kernel.org/kvm/20210223210625.604517-5-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

It certainly should not be in vfio pci. Everything using a PASID needs
this infrastructure, VDPA, mdev, PCI, CXL, etc.

Jason
