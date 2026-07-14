Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC80373C0E
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 20:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784059327; cv=none; b=ee4tMDrI+UEVtNp4aHHLH42bM590SpATSIqzHbk8AWatdkrr2A9s1YusGaNmDhWvw7IiHxG9b65l9B8/GK+J+g0iuuuIBREclJcLKdGIoADDi/mNyfgOmUVlrCiX4pCGzKAqSYAONS5F6BZeEZLqWWpMLuLh1jnG81xu9Wjolsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784059327; c=relaxed/simple;
	bh=1S9LlB1FfQeGmdklTKpu+OZCLRMrE0GysRmvObCavpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q/8KpYbDRTUUvPyfMTnr96ktG+/BBOn3q0Q6ZzM+1WOf+K4ifwo6dK5rk2FGt7+twO0Nd2sJo8Md879EV+DaSc0hiWzQ67b2cDM5Q83CwdzFT2yM1A5OPXeC/0L+8+I3VpYkfhnZFMiOcsZOG3zY0N5+whAU/bkeb1q398TycLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iDmk6w9d; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iDmk6w9d"
Date: Tue, 14 Jul 2026 13:01:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5iQTYalcOPdzmrOdtskVxlMVi64c8hoKREEpckzvENQ=;
	b=iDmk6w9d3cXbR8IsPomQZgWuP8mSwsa2F2OpOGKY94SNiRJ2qNqcSgcef7bv7LAc2sUJA3
	eLwr/L1+atgHnoxg0VvDjpgI4T1PxQRU1LxfS7zV5oIjghoKtYe8AHHqjGcZHbAqFY/Vyd
	pnrY8DMXXhnj5sc3lmJxJ0AlNuFHrWk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: drop unused cpu argument from
 flush_nmi_stats
Message-ID: <alaVjJphyxveFEbI@linux.dev>
References: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 13, 2026 at 05:00:10PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() does not use its cpu argument. Remove it from the
> function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub. The
> caller still uses cpu for the subsequent per-CPU rstat flush.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
