Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D58241D623
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 20:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784059390; cv=none; b=kXW/+rmUToIqDVJTdUpJkS3tptBltKX0gyB38OF7ILdSgZD91TfTfQF2qoAdOF8OcX+5X7M4Z8hSIlN7UfSpSg/gOl5h6s0fL+d+jnPHg7Aqp9S0CG8N89B5LJc6VJnW9rBGOZ3W2QRsTLfVtmoSYqtkLY8OR8rVedx7Nbv3Gsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784059390; c=relaxed/simple;
	bh=8Vs2E4lhGbsxcUnNmFBe7D3JbcCSs+R/A9ZtdEMLp1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLA4hQAr7+tIT5ubSdR/XROFMIlyGmJFKmDUGkKYOhBl1W8f5NazOvg4xpRUUf5FhP5vvFO2jMWxZrVx4E70bJe+0lIytzCsVYCXLh6ISAyikIDO+CHkyJJoTABbTbzSVcy/cSW+EtUDeMKceNUelf4tW9Mb08Ea+KDhRWbe1TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dfMb2v7Q; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dfMb2v7Q"
Date: Tue, 14 Jul 2026 13:02:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DuIl5xuy4TZoJQCjWgZF0VALuE2V1cGmxxoJ5Co9yXc=;
	b=dfMb2v7QRs6gvUh/4AsKzjMa0nEeQQwr3az2MHCdmRUrc0jVbYKAzo/608o82CGKbaVBSW
	MHOK0lRA9g15VEPCl1ToGduRGEn4buZl4cm4PkrJkYZmsOdVJl1X1ovJA3F3NXKm5DnUAB
	e8BdVXDhs0eL77rZclJyYfEAJHLnOo4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: factor out memcg kmem uncharge sequence
Message-ID: <alaVzJ1OhSSgD6hY@linux.dev>
References: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 13, 2026 at 05:03:04PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The kmem-uncharge sequence (mod_memcg_state(MEMCG_KMEM) +
> memcg1_account_kmem + conditional memcg_uncharge) is duplicated verbatim
> in obj_cgroup_release() and drain_obj_stock_slot(). Factor it into a
> small memcg_uncharge_kmem() helper. The reference get/put stays at the
> call sites, as they differ.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
