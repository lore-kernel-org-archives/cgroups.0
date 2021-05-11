From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 11 May 2021 11:38:40 -0300
Message-ID: <20210511143840.GL1002214@nvidia.com>
References: <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder>
 <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder>
 <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <MWHPR11MB1886E22D03B14EE0D5725CE08C539@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OMfWZvNL8XVN0Eq8qQEaCJm25NFuVDltqXLJAjUpac=;
 b=dqzdeesY1x+1S0AGDzq8F043OdtnVXKnYP13vLzlFfeRlbi2131bKz8yz43m3we4AIcXowxauy9JFy8NVJOdNTBo8fUkzZcwnn8K++uew6S+FBtcqwAPzObxUB2ZYj8ptlu0zztzH6NQYPYUTleh2YJW7zMWwylLAh2mFaGHIcDmnQkQkqsXuo8LS9thNUOWcIPNiHZIaHsJe5IkQq1ZArTBUqguhhvsI3ayPG7fk3f+tRt014luP7dCcczAc1jXCKRK1hWMopXSPyOl5pgP8i0f1gms3d0fkCTng0KKLIcCSaByh0UEHdYJWywgiOxZraEYdFIBjSg4dkms8rZeBw==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886E22D03B14EE0D5725CE08C539-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Tue, May 11, 2021 at 09:10:03AM +0000, Tian, Kevin wrote:

> 3) SRIOV, ENQCMD (Intel):
> 	- "PASID global" with host-allocated PASIDs;
> 	- PASID table managed by host (in HPA space);
> 	- all RIDs bound to this ioasid_fd use the global pool;
> 	- however, exposing global PASID into guest breaks migration;
> 	- hybrid scheme: split local PASID range and global PASID range;
> 	- force guest to use only local PASID range (through vIOMMU);
> 	- for ENQCMD, configure CPU to translate local->global;
> 	- for non-ENQCMD, setup both local/global pasid entries;
> 	- uAPI for range split and CPU pasid mapping:
> 
>     // set to "PASID global"
>     ioctl(ioasid_fd, IOASID_SET_HWID_MODE, IOASID_HWID_GLOBAL);
> 
>     // split local/global range, applying to all RIDs in this fd
>     // Example: local [0, 1024), global [1024, max)
>     // local PASID range is managed by guest and migrated as VM state
>     // global PASIDs are re-allocated and mapped to local PASIDs post migration
>     ioctl(ioasid_fd, IOASID_HWID_SET_GLOBAL_MIN, 1024);

I'm still not sold that ranges are the best idea here, it just adds
more state that has to match during migration. Keeping the
global/local split per RID seems much cleaner to me

This is also why I don't really like having the global/local be global
to the ioasid either. It would be better to specify global/local as
part of each VFIO_ATTACH_IOASID so each device is moved to the correct
allocator.

> When considering SIOV/mdev there is no change to above uAPI sequence. 
> It's n/a for 1) as SIOV requires PASID table in HPA space, nor does it
> cause any change to 3) regarding to the split range scheme. The only
>  conceptual change is in 2), where although it's still "PASID per RID" the 
> PASIDs must be managed by host because the parent driver also allocates 
> PASIDs from per-RID space to mark mdev (RID+PASID). But this difference 
> doesn't change the uAPI flow - just treat user-provisioned PASID as 'virtual' 
> and then allocate a 'real' PASID at IOASID_SET_HWID. Later always use the 
> real one when programming PASID entry (IOASID_BIND_PGTABLE) or device 
> PASID register (converted in the mediation path).

It does need some user visible difference because SIOV/mdev is not
migratable. Only the kernel can select a PASID, userspace (and hence
the guest) shouldn't have the option to force a specific PASID as the
PASID space is shared across the entire RID to all VMs using the mdev.

I don't see any alternative to telling every part if the PASID is
going to be used by ENQCMD or not, too many important decisions rest
on this detail.

Jason
