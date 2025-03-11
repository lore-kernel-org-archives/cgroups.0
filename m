Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3125425F96B
	for <cgroups@vger.kernel.org>; Tue, 11 Mar 2025 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741710413; cv=none; b=S5ONAYD04unLioka7lVOfvONU3Bg6aCIufC7i1CJlbpipDnkeK/yX/E+NCI7eMiWdPqx38QeNStVgK+hncuXZ5niFAvQCtZxEmpChHEpq87TSywFPVW9XEdeABdGVPx6JXg0RImJRatX2HpDSSGkgSJX+H2QHiEiUkj9znpIZXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741710413; c=relaxed/simple;
	bh=hKC54g++R1G+XXuF0lAdxlj7rxnHNuR8kyyjmE1wPkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vDTMNRJopRXhNDU0V2eM//D1NpduYPs0P4yRmMIl0a+Nq7bGjECv1oBGIVqcVe/Vb1ktaLWhbSWm6OOjHbTo9ifVMWReCI2gl1Ww/uWqw3IGcvaRPRveCutCUp2fhoumz06H7whay2xeHAfBK7rscBQNfiaz+s2ri1EfxaNrbEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hzs6x+Rz; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hzs6x+Rz"
Date: Tue, 11 Mar 2025 16:26:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741710399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V2mnFFnUijG9A/gZIz5QOKtJPBK4Pn57c7YnZizYs6g=;
	b=Hzs6x+Rzgb48DJUaYA8dcBu9P4KaphhCvBK6PDI/xDYc20+Ix1DnzuXl3MLVpFHc+/5WNz
	o7sF8qDuDp6OvmiiOtY5vEtxYtmTHnvOXi1bMCoUzOw0PS8BMWxBNkdMb5WPcADd3UrWwe
	FbNy/uDzx8xH2be/izyHuAW905pj/5M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: drain obj stock on cpu hotplug teardown
Message-ID: <Z9BkOgZIK1iSQKd5@google.com>
References: <20250310230934.2913113-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310230934.2913113-1-shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 10, 2025 at 04:09:34PM -0700, Shakeel Butt wrote:
> Currently on cpu hotplug teardown, only memcg stock is drained but we
> need to drain the obj stock as well otherwise we will miss the stats
> accumulated on the target cpu as well as the nr_bytes cached. The stats
> include MEMCG_KMEM, NR_SLAB_RECLAIMABLE_B & NR_SLAB_UNRECLAIMABLE_B. In
> addition we are leaking reference to struct obj_cgroup object.
> 
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
