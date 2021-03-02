From: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 00/18] IOASID extensions for guest SVA
Date: Tue, 2 Mar 2021 12:58:05 +0000
Message-ID: <BN6PR11MB406867D75E42A34F8C2555E5C3999@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EABkFu3+j2V5WDiRXC0f/ppojwIHN02YS+GxyGKV6cA=;
 b=g4PqHbpWP7IXc99b0R9W0Z1WhQHIi2+YAUkgcVUkGtCFzKClYU3fxEUCHYpSw24P1EGD338fqVmBQZW9gUpMoYZCPc+PwQ87ERBUUUsAy5dZjug0917o9Fi2xl/fpEL/OZ7Z72jLjTgDR2h1aQpoWuJdmfVKZdYnOnbTuwoJomQ=
In-Reply-To: <1614463286-97618-1-git-send-email-jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Sent: Sunday, February 28, 2021 6:01 AM
>
> I/O Address Space ID (IOASID) core code was introduced in v5.5 as a generic
> kernel allocator service for both PCIe Process Address Space ID (PASID) and
> ARM SMMU's Substream ID. IOASIDs are used to associate DMA requests
> with
> virtual address spaces, including both host and guest.
> 
> In addition to providing basic ID allocation, ioasid_set was defined as a
> token that is shared by a group of IOASIDs. This set token can be used
> for permission checking, but lack some features to address the following
> needs by guest Shared Virtual Address (SVA).
> - Manage IOASIDs by group, group ownership, quota, etc.
> - State synchronization among IOASID users (e.g. IOMMU driver, KVM,
> device
> drivers)
> - Non-identity guest-host IOASID mapping
> - Lifecycle management
> 
> This patchset introduces the following extensions as solutions to the
> problems above.
> - Redefine and extend IOASID set such that IOASIDs can be managed by
> groups/pools.
> - Add notifications for IOASID state synchronization
> - Extend reference counting for life cycle alignment among multiple users
> - Support ioasid_set private IDs, which can be used as guest IOASIDs
> - Add a new cgroup controller for resource distribution
> 
> Please refer to Documentation/admin-guide/cgroup-v1/ioasids.rst and
> Documentation/driver-api/ioasid.rst in the enclosed patches for more
> details.
> 
> Based on discussions on LKML[1], a direction change was made in v4 such
> that
> the user interfaces for IOASID allocation are extracted from VFIO
> subsystem. The proposed IOASID subsystem now consists of three
> components:
> 1. IOASID core[01-14]: provides APIs for allocation, pool management,
>   notifications, and refcounting.
> 2. IOASID cgroup controller[RFC 15-17]: manage resource distribution[2].
> 3. IOASID user[RFC 18]:  provides user allocation interface via /dev/ioasid
> 
> This patchset only included VT-d driver as users of some of the new APIs.
> VFIO and KVM patches are coming up to fully utilize the APIs introduced
> here.
>
> [1] https://lore.kernel.org/linux-iommu/1599734733-6431-1-git-send-email-
> yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
> [2] Note that ioasid quota management code can be removed once the
> IOASIDs
> cgroup is ratified.
> 
> You can find this series, VFIO, KVM, and IOASID user at:
> https://github.com/jacobpan/linux.git ioasid_v4
> (VFIO and KVM patches will be available at this branch when published.)

VFIO and QEMU series are listed below:

VFIO: https://lore.kernel.org/linux-iommu/20210302203545.436623-1-yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
QEMU: https://lore.kernel.org/qemu-devel/20210302203827.437645-1-yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/T/#t

Regards,
Yi Liu
