Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E9F70808;
	Fri, 16 Oct 2026 04:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792125988; cv=none; b=inq/AbWTsljiYjEP0belwmblxWyKQl3P2ZomLD/boLBGNs/JGY2n5Coch9PDczjhWs2EYwth5BqJBsqOsHfPpjF5gW2wNnnC2dO3iFkeYJlllcGRwrQ55oe6433warvl7+R46I8oqqA/SQ4xD5lKuaDl6i2aFYqXn8xUduwNPQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792125988; c=relaxed/simple;
	bh=ESE5Y7NX1PVIUio7g0vrpnPWwgH0Dm/XFgqJ74MmLb8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AWWXGzLL7dEZLblobmdYdYO8VhQfWSfBFMpWtE7FS0gUGWC7qMUbFbnq8rBEaw0eVCutvI4CKXuPXBstG8l65ukgVNp8xvfFGbBGhG/AuSqG+MniK/XO0K56yOX7qEwvIXN4oiXcAp2A7AP5JNIJa8/FFYna4q0efSHan4tb2zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3CNYYQD; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3CNYYQD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792125986; x=1823661986;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ESE5Y7NX1PVIUio7g0vrpnPWwgH0Dm/XFgqJ74MmLb8=;
  b=H3CNYYQDfP0kddfbPZL3j4Breb3ZeMM6rPeEFVyk97aFCg9+YAw5XhMh
   j2mhTGOVRimEjB2jtOA9Fr/JJfDnuyTvNJPVuFgXK3tLAYH9qneKHjxzC
   To4BGJFwaQWWGGAqsWHHtmr08DTe8uPrGRF+JclIOvoqJEDcD1ZMajQlU
   +O0adFMAdcSxWpqMqfD/BNZRO5/xQqalEF6o4v9Jsct8tjVzFFrftkw5K
   SrhBouyFcM6Rep1VVF7BDQiC+yDnQ7vZRr/m3z+sNizWLhi9xlm+UI3xM
   F7c3QUxdQbilndtHx90lfoxRV+iMLlFZERLHKnDICbWOh/UD0C6oB0bR1
   g==;
X-CSE-ConnectionGUID: HTAwNuITSu+sspsw72V2LA==
X-CSE-MsgGUID: 6Zr99Rs8SPiAP8iUwA4BQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="917578"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="917578"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 21:46:22 -0700
X-CSE-ConnectionGUID: pTq9aZLBSWy1P65RlcXdSA==
X-CSE-MsgGUID: 9pjtIiMZS2WPwF8bG0cUBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="1955532"
Received: from unknown (HELO [10.238.0.90]) ([10.238.0.90])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 21:46:18 -0700
Message-ID: <630d7044-c7b9-4cfe-a05e-0def5f2900af@linux.intel.com>
Date: Fri, 16 Oct 2026 12:46:16 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jpb@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 iommu@lists.linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's
 memcg
To: Peizhe Liu <peizheliu@utexas.edu>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>
References: <20261012200823.699316-1-peizheliu@utexas.edu>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20261012200823.699316-1-peizheliu@utexas.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/2026 4:08 AM, Peizhe Liu wrote:
> iommu_sva_handle_mm() runs from the IOPF workqueue and calls
> handle_mm_fault() for the faulting mm, but does not set the active
> memcg. File-backed faults can allocate page cache through
> mem_cgroup_charge(folio, NULL, gfp), which falls back to the root memcg
> when the worker has neither an active memcg nor a current->mm. Page
> cache faulted in by a device is therefore charged to root and escapes
> the task's memory.max.
> 
> Set the active memcg to the one associated with the faulting mm while
> handling the fault, and restore the previous value afterwards.
> 
> Fixes: fc36479db74e ("iommu: Add a page fault handler")
> Signed-off-by: Peizhe Liu<peizheliu@utexas.edu>
> ---
> Tested on a Xeon Gold 5512U with Intel DSA, based on iommu/next.
> Before/after testing confirmed that the block-on-fault case charges
> the page cache to the task's memcg after this change and is subject
> to memory.max.
> 
>   drivers/iommu/iommu-sva.c | 6 ++++++
>   1 file changed, 6 insertions(+)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
