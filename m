From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 15/18] cgroup: Introduce ioasids controller
Date: Thu, 4 Mar 2021 13:54:02 -0400
Message-ID: <20210304175402.GG4247@nvidia.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-16-git-send-email-jacob.jun.pan@linux.intel.com>
 <YD+u3CXhwOi2LC+4@slm.duckdns.org> <20210303131726.7a8cb169@jacob-builder>
 <20210303160205.151d114e@jacob-builder> <YECtMZNqSgh7jkGP@myrica>
 <20210304094603.4ab6c1c4@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210304094603.4ab6c1c4@jacob-builder>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
 t=1614880459; bh=1IsSiLJgMTXbIalwO2pbn+VbK2Xk9986eGeD/lKT7yQ=;
 h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
 From:To:CC:Subject:Message-ID:References:Content-Type:
 Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
 X-MS-Exchange-MessageSentRepresentingType:X-Header;
 b=rDYRwf0dwRc+djrxenqKoY96c9s8HF7iXjhjlMjLqhK7AgVH6nhHtLXOWqj5t6afh
 lRlLZiPC9KLV1CRT6m/HH8hUjiKj4J/qgp8jy29CLE3yY/zivgM0gAL0fTyY7ItEUT
 gAHQeIPZwaga7VM1F/4FXVNfUxC9hE0ZV/HL6apEPfv9s9IMJczvXmjfAiVzbLcjWV
 wbkKRvXO0p6/xkWn+ZArhyau+4P0VUr//MMXazPjODaYUWG7gFwiCOOvQTvKXFiK0q
 5f1xa+nA+hZu6N1SC31B8xRv1PcVkOgp9v2jnkOhuNTtx0++k1MFiF/khEFzvPqp5a
 1uWiZtwPm8+qQ==
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
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Mar 04, 2021 at 09:46:03AM -0800, Jacob Pan wrote:

> Right, I was assuming have three use cases of IOASIDs:
> 1. host supervisor SVA (not a concern, just one init_mm to bind)
> 2. host user SVA, either one IOASID per process or perhaps some private
> IOASID for private address space
> 3. VM use for guest SVA, each IOASID is bound to a guest process
> 
> My current cgroup proposal applies to #3 with IOASID_SET_TYPE_MM, which is
> allocated by the new /dev/ioasid interface.
> 
> For #2, I was thinking you can limit the host process via PIDs cgroup? i.e.
> limit fork. So the host IOASIDs are currently allocated from the system pool
> with quota of chosen by iommu_sva_init() in my patch, 0 means unlimited use
> whatever is available. https://lkml.org/lkml/2021/2/28/18

Why do we need two pools?

If PASID's are limited then why does it matter how the PASID was
allocated? Either the thing requesting it is below the limit, or it
isn't.

For something like qemu I'd expect to put the qemu process in a cgroup
with 1 PASID. Who cares what qemu uses the PASID for, or how it was
allocated?

Jason
