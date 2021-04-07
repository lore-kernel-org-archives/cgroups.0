From: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 7 Apr 2021 20:43:50 +0200
Message-ID: <YG39ZtnTuyn5uBOa@myrica>
References: <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
 <fa57bde5-472f-6e66-3521-bfac7d6e4f8d@redhat.com>
 <20210406124251.GO7405@nvidia.com>
 <MWHPR11MB1886A7E4C6F3E3A81240517B8C759@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U09jkuhbNd4GqgIa8gbKdPQlfgb0wMDSk0hVwDV1gRw=;
        b=ngd4o4PyyH4y4MwaG4cnoC6BYaNJKVmTUn1FLk6iHOAPaNG8DeUfZzhymKYlRt0WBF
         HGIOklvd6ZH0GhYEpHVm1LuvZ4z2wBSgD26kvfyaBhMfmn663lBk1uddv969zUJdaAYt
         3YBKSHQAb6fT2Vyy/1JMWOttU9895pAjrlIlWnXHy+8Vp2NPYpaGV+sB+0StjU9OeP98
         tRy0QHfn3hsF8zE1Aq/BMXcz9eW6XrmshNU6mzVrbRp5IwhAeUJu2P0HNXcKc1pCQV2C
         WnUNExQdMC8rBcwLKpfweD2zJQ7hiRYL85Z0298BXC5qxaHuANgjHZkaqk2CWglrqSDR
         vunA==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886A7E4C6F3E3A81240517B8C759-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Apr 07, 2021 at 08:17:50AM +0000, Tian, Kevin wrote:
> btw this discussion was raised when discussing the I/O page fault handling
> process. Currently the IOMMU layer implements a per-device fault reporting
> mechanism, which requires VFIO to register a handler to receive all faults 
> on its device and then forwards to ioasid if it's due to 1st-level. Possibly it 
> makes more sense to convert it into a per-pgtable reporting scheme, and 
> then the owner of each pgtable should register its own handler.

Maybe, but you do need device information in there, since that's how the
fault is reported to the guest and how the response is routed back to the
faulting device (only PASID+PRGI would cause aliasing). And we need to
report non-recoverable faults, as well as recoverable ones without PASID,
once we hand control of level-1 page tables to guests.

> It means
> for 1) VFIO will register a 2nd-level pgtable handler while /dev/ioasid
> will register a 1st-level pgtable handler, while for 3) /dev/ioasid will register 
> handlers for both 1st-level and 2nd-level pgtable. Jean? also want to know 
> your thoughts...  

Moving all IOMMU controls to /dev/ioasid rather that splitting them is
probably better. Hopefully the implementation can reuse most of
vfio_iommu_type1.

I'm trying to sketch what may work for Arm, if we have to reuse
/dev/ioasid to avoid duplication of fault and inval queues:

* Get a container handle out of /dev/ioasid (or /dev/iommu, really.)
  No operation available since we don't know what the device and IOMMU
  capabilities are.

* Attach the handle to a VF. With VFIO that would be
  VFIO_GROUP_SET_CONTAINER. That causes the kernel to associate an IOMMU
  with the handle, and decide which operations are available.

* With a map/unmap vIOMMU (or shadow mappings), a single translation level
  is supported. With a nesting vIOMMU, we're populating the level-2
  translation (some day maybe by binding the KVM page tables, but
  currently with map/unmap ioctl).

  Single-level translation needs single VF per container. Two level would
  allow sharing stage-2 between multiple VFs, though it's a pain to define
  and implement.

* Without a vIOMMU or if the vIOMMU starts in bypass, populate the
  container page tables.

Start the guest.

* With a map/unmap vIOMMU, guest creates mappings, userspace populates the
  page tables with map/unmap ioctl.

  It would be possible to add a PASID mode there: guest requests an
  address space with a specific PASID, userspace derives an IOASID handle
  from the container handle and populate that address space with map/unmap
  ioctl. That would enable PASID on sub-VF assignment, which requires the
  host to control which PASID is programmed into the VF (with
  DEVICE_ALLOW_IOASID, I guess). And either the host allocates the PASID
  in this case (which isn't supported by a vSMMU) or we have to do a
  vPASID -> pPASID. I don't know if it's worth the effort.

Or
* With a nesting vIOMMU, the guest attaches a PASID table to a VF,
  userspace issues a SET_PASID_TABLE ioctl on the container handle. If
  we support multiple VFs per container, we first need to derive a child
  container from the main one and the device, then attach the PASID table.

  Guest programs the PASID table, sends invalidations when removing
  mappings which are relayed to the host on the child container. Page
  faults and response queue would be per container, so if multiple VF per
  container, we could have one queue for the parent (level-2 faults) and
  one for each child (level-1 faults).

Thanks,
Jean
