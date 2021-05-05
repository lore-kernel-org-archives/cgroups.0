From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 5 May 2021 15:00:23 -0300
Message-ID: <20210505180023.GJ1370958@nvidia.com>
References: <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
 <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210426123817.GQ1370958@nvidia.com>
 <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210504084148.4f61d0b5@jacob-builder>
 <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder>
 <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7t3qOLU0208V35Nz1Weuft1zIeK/D1DjiNEntiBlHlI=;
 b=p6YTqGr4cSwlIiSywQVS2Ya5rd6JeSHLYQnDMfNRQp8Br7vzBzuGgqIORz66AjjrwUthlFcjfBrSiUDC3+JGyUIz7386ERCHIcxkkOdP6Rl51QfN32/2W9CMoo9+ipMxRZrFsJ9yiWgFrnrPaKWnJzvkhLqqgU3CkP+iB56rk00hxGFoUhXQBe27ZUiEUW8INaoP+sbPeZa/AA0ngBv5tTAMJwsoHo78nGiHFAaR6EShTF6B/My1WrUExpFJ+rwEvoqQalO76ZCkPCQC6PuuicY/7lLPFNRKOz18tsxbiFEwDk7OoQVM96WmdCd+nE8XmnZUyYbINWX3mwBoJiCWpw==
Content-Disposition: inline
In-Reply-To: <20210505102259.044cafdf@jacob-builder>
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
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, May 05, 2021 at 10:22:59AM -0700, Jacob Pan wrote:

> Global and pluggable are for slightly separate reasons.
> - We need global PASID on VT-d in that we need to support shared
> workqueues (SWQ). E.g. One SWQ can be wrapped into two mdevs then assigned
> to two VMs. Each VM uses its private guest PASID to submit work but
> each guest PASID must be translated to a global (system-wide) host PASID to
> avoid conflict. Also, since PASID table storage is per PF, if two mdevs of
> the same PF are assigned to different VMs, the PASIDs must be unique.

From a protocol perspective each RID has a unique PASID table, and
RIDs can have overlapping PASIDs.

Since your SWQ is connected to a single RID the requirement that
PASIDs are unique to the RID ensures they are sufficiently unique.

If the IOMMU driver has additional restrictions then it should raise
the PASID table up higher in the hierarchy than at the RID.

I think what you are trying to explain is that the Intel vIOMMU has a
single PASID address space shared globally by the vCPU because ENQCMD
uses the global vGPU translation table.

That is fine, but all this stuff should be inside the Intel vIOMMU
driver not made into a global resource of the entire iommu subsystem.

Systems that work this way just cannot have multiple iommu drivers
competing for PASID.

> - The pluggable allocator is to support the option where the guest PASIDs
> are allocated by the hypervisor. 

And if the hypervisor allocates the PASID then again the specific
vIOMMU itself is concerned with this and it has nothing to do with
global behavior of the iommu subsystem.

> For ARM, since the guest owns the per device PASID table. There is no need
> to allocate PASIDs from the host nor the hypervisor. Without SWQ, there is
> no need for global PASID/SSID either. So PASID being global for ARM is for
> simplicity in case of host PASID/SSID.

It isn't clear how ARM can support PASID and mdev but that is an
unrelated issue..

Jason
