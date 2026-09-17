Received: from mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754034EF145
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 20:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789676811; cv=none; b=e/Cy9uACBiQrE6Qi3xfKfYBb7xBRVXG9RyKpzEDcwSii0BqyP/mdpv4zRAQZNzCbovPWw+PD21gan2VwE0MS9K83+BjcLOa6NYmGnrzBusIk+4gT1aHUIcFqtFrLiWW2Wo7d2e7UcALbcc5fnADtra7UMfGvkSorOsL0NjexfT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789676811; c=relaxed/simple;
	bh=IymYpdktmr2T4Y5nV+Oxbm/h4xXa2qb7o9DAxlo2Xn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qO0ondSr5Kmyh6k6LI6ba+d6E4y3V/HP8JJtlSMj1gqq9X2siUE+PtJh4LDWtuDbO8pi7kh7seEMBiJT6QH4y67tiURjuXZrvZ/y/N55DOlAGFwbLXNDZCtVx9mZWOtmyDeoSmEImXm12jwWme+YIM6lodNVrtIa6gmV2pdIMPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D4pmKdxh; arc=none smtp.client-ip=91.218.175.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D4pmKdxh"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IymYpdktmr2T4Y5nV+Oxbm/h4xXa2qb7o9DAxlo2Xn0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789676806; v=1; x=1790281606;
 b=D4pmKdxhFVZQFivGakGVOSrbvSKbZEBdyCjj4lGV6icshBRbqhP0wfoG4pG19ksSNEqjl1yM
 Ofu6j1bY3qoTBen7GlUiQHRiD4JQ4RFAd7b72QkQqDt39PRjCXSVvkzG80oNq8a0aoXMyLNHK1p
 hUboxtUeSqOiYwVgIw/c67As=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5c187154c223a05e;
	Thu, 17 Sep 2026 20:26:45 +0000
X-Mizu-Trace-ID: 5c187154c223a05e
X-Migadu-Flow: FLOW_OUT
Date: Thu, 17 Sep 2026 13:26:40 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aqxMk6yaiFHeeAAg@linux.dev>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916125737.1095414-1-cui.tao@linux.dev>

On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> The legacy cgroup v1 memory controller has already been moved out of
> the shared implementation at the file level (mm/memcontrol-v1.c) and at
> the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
> per-cgroup state, however, still sits as individual members inside
> struct mem_cgroup, guarded by #ifdefs.
> 
> This series isolates the deprecated implementation from the shared hot
> structure: all v1-only members are grouped into a dedicated
> struct mem_cgroup_v1, and every access goes through memcg->v1.X.
> 
> With this in place the v1 implementation is self-contained: its
> interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
> its eventual removal becomes a localized deletion of this struct
> together with mm/memcontrol-v1.c, instead of unwinding
> ifdef-scattered members across the shared header.

Sorry I don't see any benefit of this code churn. The code is already behind
config. What exactly this code churn is giving us?

