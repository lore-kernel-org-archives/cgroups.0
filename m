Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4F85616AE;
	Wed, 14 Oct 2026 18:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792001310; cv=none; b=CXpc54yla8EqbrNZC+DjDojGMaf4hkMQWbPVNd/9HhHajO6Aw3k4pV08DRol1VkgWRjFwizfpxJIYTf+6r9NvnwimsP/g4E2dYE9D70u/BvPoP6cYFhHWeYio8j2mFy9pZKreTvik9JEBPK9svKoBngjC9XM+MvUuEiH/XJYthw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792001310; c=relaxed/simple;
	bh=O9QAb4cT19cQrmU9QK3dbb4DiRCzx0j6VWtrSOzT/YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fa6ySRjP/RKojeYWj4CH6WQKRMiGdX/2THBZ9G4XJBVjpquPBuFKa4M8tFCOTdI6hYPosgyEUMxWOqyUpQktkrt4ZK8RnK6l4e07YHWUkR14h34HQIyQddSH5+G9uDVEnjtPSmQszY4xsK+/kXCXOlZIcGJjCdi2nxR+LrhAqeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cfx0G1dR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cfx0G1dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14711F000C4;
	Wed, 14 Oct 2026 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792001308;
	bh=Au3LNpF2hUg5xkBv3JpQ9J5GcYVRPUaLDT906GDhkkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cfx0G1dRgMNLo0iM3NmZK8XJOB2BFB9HB4XAZm0dcHDa39O3+PHvzqLD+bFFbZ5XU
	 CO7Cvf+BUhrG9mV7cn9u+hrPuXP5VGFZgB+JW4lSyJ/79un/CNw2OoS3rS9NeAXBdY
	 KBiK6ueSPHbeqs7Ulq9QKAVs7zlOofpLMMe8zDevqAWKGpUBjXcdog+fNRpb4Ew8xR
	 ndbdaLOj7y9/miUYnBDNf2jauFsA0g5hqHF6Nc4K7yyExEwdubwQ49mXtQsOr+vPD3
	 QLbXVnyS1B7I1U/nFfIEo0ItJU+PXB21lkkZo+ZzkoxQaD8ksQtoMow96sgO0IeWLI
	 StkcXiA5nGoAQ==
Date: Wed, 14 Oct 2026 19:08:26 +0100
From: Harry Yoo <harry@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
Message-ID: <as_FB6P5YAhc7B1A@thinkstation>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>

On Wed, Oct 14, 2026 at 01:08:20PM -0400, Tal Zussman wrote:
> The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
> switch to native NR_VMALLOC vmstat counter"). Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
