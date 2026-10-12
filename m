Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB6F3C8C71
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 23:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846475; cv=none; b=m73nEAuDhqCYeStYYL8mhaG9zVf0SwD5l5RBb7WVN+Z1bBJ3x8YlEHilM63GqZJYgf0R6eDNLSgoCiO2CTdhfh7E3hpZWfShXEcT+b+6dnjo2AuCVVZceMIi7i2jOub9hnxL/GjjhXo7Pco+uZR8pY8+f3u+d+nFp7Uy6aQW0kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846475; c=relaxed/simple;
	bh=4d9rOcjLsImPuDW5V2enOqFBvzCKpQlzawzMGLQRTGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpWeunzUVzZIjsBRVu4vpeIpmEp3mqxr/cvZGrToXD12ftQrIzbLSf0Hypkh6ktaWDHx3pdbs7q1q+u2DIGYcb19XyP+mbJbMKJxj+Sg7Mkd9X1NxH2MucsAbdBGK/GaBRLvqX59d3YfyqxQpCzYFbkvtR1yhfIMyEpaxvzQGbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pxFBSrfj; arc=none smtp.client-ip=91.218.175.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pxFBSrfj"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4d9rOcjLsImPuDW5V2enOqFBvzCKpQlzawzMGLQRTGI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791846470; v=1; x=1792451270;
 b=pxFBSrfjjBS9dfF5e0L3BcLy0eStex7t480YvgeyFsn74xV0swFHsWQG2S498o22hkU4eJbQ
 iJNfKPf3+EXTHwAMaGOZViF7TZEMuuQmIeCIVfoOgBZc8K4LN206EHRT2/PxXXzdZCbVgyvaXq8
 RBGpS1jsq7porV8WNExn/Wnk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 235e8c915f036f3a;
	Mon, 12 Oct 2026 23:07:49 +0000
X-Mizu-Trace-ID: 235e8c915f036f3a
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 16:07:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peizhe Liu <peizheliu@utexas.edu>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Jean-Philippe Brucker <jpb@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, iommu@lists.linux.dev, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's
 memcg
Message-ID: <as1nxRIXe3-Ktfnp@linux.dev>
References: <20261012200823.699316-1-peizheliu@utexas.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012200823.699316-1-peizheliu@utexas.edu>

On Mon, Oct 12, 2026 at 03:08:23PM -0500, Peizhe Liu wrote:
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
> Signed-off-by: Peizhe Liu <peizheliu@utexas.edu>

This looks fine from memcg perspective.

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
