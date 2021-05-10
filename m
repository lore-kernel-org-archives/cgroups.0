From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 10 May 2021 12:31:11 -0300
Message-ID: <20210510153111.GB1002214@nvidia.com>
References: <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder>
 <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder> <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <20210510152502.GA90095@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udVIqNaDkwT7Wnxrtq81jU6gH6RKKDUZxI8YbxXrVN8=;
 b=mFsEy5JkekTI80bM85PZUHzWs0zmPmwB/1P3jBfkRBIAW2Stna8fGSwcuqgBI2+CeWBATW8yKdloJnDqvrkcx2AF01IQ2ZuvO6dykVuRETBDh0SxDUtIcjcOXXqXiPsMtLGdlV4UN2aHapnBZBJMAMANKQO4dMJL6+QaeOyNhj7+F7+5U+P1CaHz01fQS27A9nOw74FlIgx2lsicNIwSb3UlXkFV4O9iCRb7hohjLbgCQKrksl/2cl9uigF8OJl8bQYwChjbetw8LL51jr1BLXfr6vl3ya+MeEuREXqDVN60sV2QgSbNkLhH/4NQJczJ4PXm1UgfVN6/ELBTo7jlkA==
Content-Disposition: inline
In-Reply-To: <20210510152502.GA90095@otc-nc-03>
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
To: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Mon, May 10, 2021 at 08:25:02AM -0700, Raj, Ashok wrote:

> Global PASID doesn't break anything, but giving that control to vIOMMU
> doesn't seem right. When we have mixed uses cases like hardware that
> supports shared wq and SRIOV devices that need PASIDs we need to 
> comprehend how they will work without having a backend to migrate PASIDs 
> to new destination.

Why wouldn't there be a backend? SRIOV live migration is a real thing
now (see Max's VFIO patches). The PASID space of the entire dedicated
RID needs to be migratable, which means the destination vIOMMU must be
able to program its local hardware with the same PASID numbers and any
kind of global PASID scheme at all will interfere with it.

> When we have both SRIOV and shared WQ exposed to the same guest, we 
> do have an issue. The simplest way that I thought was to have a guest 
> and host PASID separation.  Where the guest has its own PASID  space 
> and host has its own carved out.  Guest can do what ever it wants within 
> that allocated space without fear of any collition with any other device. 

And how do you reliably migrate if the target kernel has a PASID
already allocated in that range?

ENQCMD must not assume it is the only thing in the platform. It needs
to be compartmentalized to specific participating RIDs and made
explicit because it has a bad special requirement for cross-device
PASIDs

Jason 
