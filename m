Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535D93BB109;
	Fri, 28 Aug 2026 19:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787944822; cv=none; b=BrIFPJETiQrgf8/BUvPfckBZs6sKW/HIAU+yByFx0dPiZ40D1XS9jhPRR7xaQ0oqltnzyKC/FPlwTtc7O3nuZ6LduM8HMbxe1bcD9mBwVI60vYY9d9NQUYF/SNTp6WPKQ4tkrFgPOpKcbYWNcgitW1tMxEKaBD3pRuvBkIONiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787944822; c=relaxed/simple;
	bh=uNeM2/Fk2yqr4ZHA4xk46RqzVAdqafasj/mKiyfZD20=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cwfRHYOLD+sDNymgq6cI8kDLcFw5p8d6UdZd2dkOJVT1RvJ2980iuumOM/c8+0ZhjZuzybjWLxsrKLlBGgEqRw4nEzgCZbbaGVPYOQib6Ml7yQbchRuvUhylhI8n6ur/2CZwJpqqtoXmMDVJG8Wmf7XQVIfW0uuXa2+fN/dufts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YccYuhnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YccYuhnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C051F000E9;
	Fri, 28 Aug 2026 19:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787944818;
	bh=DqswDGqiNUCPl5M5sQ08mk77pL/gqXDNGxwzzYiqye4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YccYuhnKN/IJ9Yinyg5VnK5LmyQFBhGAl0u028g3vTYAYyZYUB4UOenvskRreRIs5
	 XiXM3dXuSxkyV8+vlP63u25LymCgQPGRymqbdy+/G+qs0bx5B4Mt4rb+5TViOAGAH1
	 TlnoYCDuZ4PVWFaDr5YyTnO+C3pgxUDjnipDZlLE=
Date: Fri, 28 Aug 2026 12:20:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
Message-Id: <20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>
In-Reply-To: <20260828135036.7d44361f@fangorn>
References: <20260828135036.7d44361f@fangorn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Aug 2026 13:50:36 -0400 Rik van Riel <riel@surriel.com> wrote:

> When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
> isolation, schedule_drain_work() can drop the work in a separate RCU
> critical section, and housekeeping_update()'s synchronize_rcu() can race
> that second check, leaving the flag set.
> 
> drain_local_stock() only clears the bit for work that ran, so the flag
> remains set and the stock is never drained again.
> 
> Have schedule_drain_work() return whether the work was queued, and clear
> FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
> isolated, so future drains can retry.

Is there some Reported-by: or reproducer for this?

Given the complexity of the reproducers which Gemini developed for me, I'm
suspecting "nope".

> Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> Cc: stable@vger.kernel.org

Why is a backport being proposed?  How does that benefit those we
serve?

Sashiko suggests that we ain't done yet:
	https://sashiko.dev/#/patchset/20260828135036.7d44361f@fangorn


