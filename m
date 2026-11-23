Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=85.214.250.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424145;
	b=0Nm55taNka0N3bWYXo5MLxxqFeU0LjLZlgq521WbxLWS77a1yLU6plKvihHazyj36SdM
	 OOS6yUnmifVmHIjDOVU+zxmCqs9wlCjeZDn9pO9De7n9a3RnkRv2PX+U4OnddNo/6pRQc
	 VH5DUm+24r5btKvYdihChT+VyezbRK9vI9w8FqV9deDevvS6fKfQ0hUY0UgjDKeTQ0Xie
	 YYcSs5nwvJT9YJ9VhAJNhRw8MXd32SCnto/ijbUey2ctpvLbl2qaZNctjb9vTbJw9zMDb
	 s4UkE/mp8el1f181Nr4hMGISfyPl46iSHuOlZRCe/8dVfpETVGv4cHZCoo903viFZ3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424145;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=aZ8iY72BDIX7Lb6nq1K3Ub9imyQBaBRIv4gacmQR40U=;
	b=d/b28+fBVNUTsKMKld2JINt59S16wqxWe/sG/BAO6G5CRd/Y2IciXXcakzPoN7fr0fdY
	 4z3MLNbWSuFThFxD9fo4AWFqbe2af1whgi2ixIN3A0qUZoDDgC2a5/n5CLbtj0l74c6Y9
	 3sUR//tRe/kJh5QP0bK9FHqjRe6LNC0IeR7CrjPF2681ymK+643QeE/o6u5JI2ujnfomc
	 XVwWE04cjn/MsTQk9W009cz1S7tbpbWrC524Xqxxjvr6L4E1ke2Sx/pWBde50JsAn6nmB
	 HpoNhaKUMTtKF7/Nrdcnie3NWquskHiaA1lzPc6EX6fAb/xnFzXMrfxazjGqtJAwJqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=8bytes.org;
	spf=pass smtp.mailfrom=8bytes.org;
	arc=none smtp.remote-ip=85.214.250.239
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E64606A31F;
	Mon, 23 Nov 2026 08:55:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2E64606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p549216fa.dip0.t-ipconnect.de [84.146.22.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 4B87F2436B3;
	Mon, 23 Nov 2026 09:55:38 +0100 (CET)
Date: Mon, 23 Nov 2026 09:55:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Peizhe Liu <peizheliu@utexas.edu>
Cc: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Kevin Tian <kevin.tian@intel.com>, Jean-Philippe Brucker <jpb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, iommu@lists.linux.dev, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's
 memcg
Message-ID: <awP_epk66QlZF7rj@8bytes.org>
References: <20261012200823.699316-1-peizheliu@utexas.edu>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012200823.699316-1-peizheliu@utexas.edu>

On Mon, Oct 12, 2026 at 03:08:23PM -0500, Peizhe Liu wrote:
>  drivers/iommu/iommu-sva.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Applied, thanks.
