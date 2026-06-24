Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C7633291F
	for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 18:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782327477; cv=none; b=XGDlclz5eTKNRW4laIPnISvtJFCU2Hqohh3wpCkCu8XjvnweGLR27AZLw6MdULy3FNZCzXBhbZvLb3I7vFDxwQTZV8doQzfTb/Kw01eYAljEEcMul9wGZeB3WqEP9syUwI1bNOoLxX4L7mGIEywniq4YuFAIAAhR9VCp93kzDu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782327477; c=relaxed/simple;
	bh=8LiknA3s4aXYjOiJna+mtPeQ+tHGCFB4z1rNFGKDWD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHwFNzhar92Q5U1DvTvez9w4OZg/ueolvLykbeqPbHi/VGRjyaWTuqXaWCjrcmvq2XZyPG/5WFWh2mpXM34e5cNcIKc633KM2ak3P/k7l99NikTDO124jEgOF6bnh5lsFh9Czof3E4KXmF6kzOLZAATtbyyAkEadGOzY1d0o4J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fL/0ysjt; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fL/0ysjt"
Date: Wed, 24 Jun 2026 11:57:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782327472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mo93bdWIfXadU3JlsmoTA9FAy2jJ63ni0Cp8m8DNffo=;
	b=fL/0ysjt6s9uWnDzOcDwXWqPM58Y7CMtfrbAA9+HN8in73/dhNpk+zxZHeIUBA8iwJ74df
	SzX5+jJv+YFvcE/18lRg4UTiRNkjMbU1p3zwVfELA4p1ixdvivlx0503Kxoo+NAKF9i4pu
	Pso6VJzxjK9MykKA7wFVzKyw/Tgx4Ac=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-kernel@kvger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: remove unused for_each_mem_cgroup macro
 and cleanup
Message-ID: <ajwojYJ9hzOXYaet@linux.dev>
References: <20260624183700.1152742-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624183700.1152742-1-joshua.hahnjy@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 24, 2026 at 11:36:59AM -0700, Joshua Hahn wrote:
> Commit 7e1c0d6f58207 ("memcg: switch lruvec stats to rstat") removed the
> last caller of for_each_mem_cgroup back in 2021, and there have not been
> any new callers since. Remove the macro.
> 
> A comment in mem_cgroup_css_online has also been out of date since 2021,
> when 2bfd36374edd9 ("mm: vmscan: consolidate shrinker_maps handling
> code") open-coded the for_each_mem_cgroup iterator. Update the comment.
> 
> Finally, 99430ab8b804c ("mm: introduce BPF kfuncs to access memcg
> statistics and events") added a second declaration for memcg_events to
> include/linux/memcontrol.h, duplicating the one in mm/memcontrol-v1.h.
> Let's clean that up too.
> 
> No functional changes intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thanks for the cleanup.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
