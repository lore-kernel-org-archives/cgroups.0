Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B6F284690
	for <cgroups@vger.kernel.org>; Wed,  1 Jul 2026 18:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782931085; cv=none; b=AsiZECCDTtpToBKuIv31EFpEZIUl/o+zGTDhc5d9h9dc9jiRX0oi2InJWwBhcyQerjije2ZTMSY9/IOWk1P3lP18IGmeOVMpezrexaRpQLwWjcwm0A4qmf21/pFOFz/htey4IiHuqGgyKy+UcU3Idky2tkZ3QLnp0VcJD10EAZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782931085; c=relaxed/simple;
	bh=D77dTUSZVphmYx+121+McWG4thtRJBSKzbj89Evbt0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2OHH7r2wabOyhrBgISQKMlrq2XdyzMdOIrq7LjVaBcjLXZNax0rMIaHCukfaF1DR2/k1Zt7u3Ie4WnolIYBcbAYaPbjCZD/urRtOMUW+L5EKGq9Ann84q/0EXprj+cEyLrnpfpOVIWgVyMuTrPXIz07THeTOrJFGFKMUOX0svM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FJf2w7Qs; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FJf2w7Qs"
Date: Wed, 1 Jul 2026 11:37:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782931080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3K3cr4GsxbzT0LmEahJpkYwclSkV+OAI4Yq9jQe85c=;
	b=FJf2w7Qsiza1XaLAkJ8Wm7awSxXqDErp9N/xH9vKUYx112nque7r4ATs4c8aNdlIqTnlYQ
	s+LekgOIQ+TVL0++bWzqD4xBwbHENzpX85YyGY1lqjX3s//u5nu0Ge52Ewe0/UNPevdkNF
	x9r9vtviqSnZa6pX32d3S1onCMCDbJs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT
 documentation
Message-ID: <akVeVIkoqfT40QlX@linux.dev>
References: <20260701182102.1586784-1-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701182102.1586784-1-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 01, 2026 at 02:21:02PM -0400, Johannes Weiner wrote:
> Gregory points out that these descriptions are cursed and confusing,
> considering what these flags actually do. This is mostly due to
> historic implementation choices and cgroup1 baggage. Improve the
> description of their actual effects.
> 
> Reported-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
