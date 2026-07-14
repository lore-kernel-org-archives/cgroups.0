Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3DA423EAD
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 20:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784059635; cv=none; b=X4PguTmWDTKSX1ZY92fSRDn9X5sZY42BPxicAcOvvJOyuirhgM3jWbbC608WS7WhTRLGcQ66HJgs0FBqg7gXXRRlPCY+2nzn/AHpYlQdyiji9oViAJuqePAD1H94L5kA9/7kEfcbdlS6quAA6HDAHAJhlzUTnnOLpigR3KrWA7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784059635; c=relaxed/simple;
	bh=mUlS/9jTJk2befzJ5zQnz+BuBZZZASQ9ea1bZBF8Y+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MoX9a8/f5vni9VomMPPpsi8jPS6eB8cgAo2/e5IZh4z7fysNkkSZko6cKbY6+PlPs5arSW2zmowvIbvFc11IILSbDwHsZLh2E64pqkyOSG5rYX7RuDs03VKcmI++IWz5vSurwHUADn0aIdyxiPWTbvV41dzYrFCMZRor8mvM+aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dMmNsSId; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dMmNsSId"
Date: Tue, 14 Jul 2026 13:06:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZU7WkL3i7SeRgw5VglrcCcv1+ohX2xp0VclLPC+zgZ4=;
	b=dMmNsSIdDI5qEX7Fe1KdUrRF1+56hw0daHyObBPoRBHlkapQaVA20nf+VW5moiise4EA7k
	vHWB65YHe2v1r/liuuQ8KQj7MtjofuSgzavPSB/Z9U5y2Q9cBBkM2nCT2NfnwcDEmuZ/sH
	B1DKUFgntjr7QQ8Nz42SVsuyPi/OhAw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
Message-ID: <alaWwe-2HSpnCrnq@linux.dev>
References: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 13, 2026 at 05:37:37PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
> mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
> for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
> int return type required by the old callback interface.
> 
> The function now has a single direct caller and no failure path. Make it
> return void.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
