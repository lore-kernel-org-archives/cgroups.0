From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 1 Apr 2021 10:42:36 -0300
Message-ID: <20210401134236.GF1463678@nvidia.com>
References: <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fthnHC1tlchbkHLDDg4kmayDrcxe/8FosyLQuPElWAM=;
 b=nwG7uJjRmQr6usWjkeShgT7NF6Q8vmCt8zlhQwF8yYqHidCAE9PFPFAvpmaCsq8BqHBLGPcbWLX0NZpYNwNSbPuw6B4kTcGUAFs4Pa4BtNUcoXRE+37vLBSGgW/yH5AFUZLzD36xPp39MfQTlsweLbf3V1vNPtIUH175VZ9l0oORlldtaiYysHC773NdFfC4hFgevYa2XVLR/AIRG9OfiDJ3CLk7ehfV5mBNepyVIYw9x1i8byvwdGdEglwjEu5btrCa+ajT094KdWrBWq1affAcZwta/n+lpxGovEYJP9bkeN3phYRZe4Yu1XrxhnzlGS/TZZ5JsogJPDLOhZ4TUg==
Content-Disposition: inline
In-Reply-To: <BN6PR11MB4068171CD1D4B823515F7EFBC37B9-1gF2/dm/6VuPGwkGT4HjsJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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

On Thu, Apr 01, 2021 at 01:38:46PM +0000, Liu, Yi L wrote:
> > From: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > Sent: Thursday, April 1, 2021 8:05 PM
> [...]
> > 
> > Also wondering about:
> > 
> > * Querying IOMMU nesting capabilities before binding page tables (which
> >   page table formats are supported?). We were planning to have a VFIO cap,
> >   but I'm guessing we need to go back to the sysfs solution?
> 
> I think it can also be with /dev/ioasid.

Sure, anything to do with page table formats and setting page tables
should go through ioasid.

> > * Invalidation, probably an ioasid_fd ioctl?
> 
> yeah, if we are doing bind/unbind_pagtable via ioasid_fd, then yes,
> invalidation should go this way as well. This is why I worried it may
> fail to meet the requirement from you and Eric.

Yes, all manipulation of page tables, including removing memory ranges, or
setting memory ranges to trigger a page fault behavior should go
through here.

> > * Page faults, page response. From and to devices, and don't necessarily
> >   have a PASID. But needed by vdpa as well, so that's also going through
> >   /dev/ioasid?
> 
> page faults should still be per-device, but the fault event fd may be stored
> in /dev/ioasid. page response would be in /dev/ioasid just like invalidation.

Here you mean non-SVA page faults that are delegated to userspace to handle?

Why would that be per-device?

Can you show the flow you imagine?

Jason
