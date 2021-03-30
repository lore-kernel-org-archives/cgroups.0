From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Tue, 30 Mar 2021 02:24:09 +0000
Message-ID: <MWHPR11MB1886F14B4C7C58C99F54FAFF8C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
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
 bh=yifpqWXgVu+yqFKJ1gV498K9qIJTDYZf7ExZs6hCv+0=;
 b=PHPa1wvqAJ+XpXWt6jWOU+7No5y8Cj/H37s+ITAFXpES49f9lUML/v4aQvQ+UBIjXmDpCeto6CFmtKzAq6YPeWAef5QllEk4o6nKG74+G7aS9IZBcRVNUQMDMVL+FrscTqAMN5+wjmbV6OuQDAbKQaHuXeQTE6dSpHkiRrM2gSs=
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
> > In terms of usage for guest SVA, an ioasid_set is mostly tied to a host mm,
> > the use case is as the following:
> 
> From that doc:
> 
>   It is imperative to enforce
>   VM-IOASID ownership such that a malicious guest cannot target DMA
>   traffic outside its own IOASIDs, or free an active IOASID that belongs
>   to another VM.
> 
> Huh?
> 
> Security in a PASID world comes from the IOMMU blocking access to the
> PASID except from approved PCI-ID's. If a VF/PF is assigned to a guest
> then that guest can cause the device to issue any PASID by having
> complete control and the vIOMMU is supposed to tell the real IOMMU
> what PASID's the device is alowed to access.
> 
> If a device is sharing a single PCI function with different security
> contexts (eg vfio mdev) then the device itself is responsible to
> ensure that only the secure interface can program a PASID and a less
> secure context can never self-enroll.
> 
> Here the mdev driver would have to consule with the vIOMMU to ensure
> the mdev device is allowed to access the PASID - is that what this
> set stuff is about?
> 
> If yes, it is backwards. The MDEV is the thing doing the security, the
> MDEV should have the list of allowed PASID's and a single PASID
> created under /dev/ioasid should be loaded into MDEV with some 'Ok you
> can use PASID xyz from FD abc' command.
> 

The 'set' is per-VM. Once the mdev is assigned to a VM, all valid PASID's
in the set of that VM are considered legitimate on this mdev. The mdev
driver will mediate guest operations which program PASID to the backend
context and load the PASID only if it is within the 'set' (i.e. already 
allocated through /dev/ioasid). This prevents a malicious VM from attacking
others. Though it's not mdev which directly maintaining the list of allowed 
PASID's, the effect is the same in concept.

Thanks
Kevin
