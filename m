Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BF731D757;
	Sun,  6 Sep 2026 01:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788658952; cv=none; b=Hihjj/e/u5CSqVfdZeWAtfi1QGN48QxeNBZXVUIv+ij7Kpw2OVbCLRx1xGqep+mxt61m89VdHlKKQn4jx1Go5Iuqzj7qdkM1p7eWZg4poGpjnDKO/5RPzMEDAom5C/O+fx/LN6bo3Gt8XeLLX7W6yBvVQYiLBRoHFg13ZiK73j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788658952; c=relaxed/simple;
	bh=ApLE/2PxWloz+Z9G2cOjEzC/92REoLzHOvW9vdU51Is=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=TpipKIQJX37ntBsM6x9qxQzM6Lj3gnxixz+ZU88oAaFs3R4mw+s36UmpWGOkP7uFtWqKytRxU5Eax4K4Tym40UFHwqVLSXAJGigaFfM4pNfTtd4dVQkjA5wK97qxGI3J9Awi/j802FdM1h2z/VJaeLxeUev6JpbBvqEt+G9xC3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d9otqxcd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d9otqxcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F288F1F00A3A;
	Sun,  6 Sep 2026 01:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788658950;
	bh=/AYMvAp78dVD5vLMe+eK825AGZ5A0V/aakGb0r5iBD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d9otqxcd7zj7hxwsR7h9z2fXV+XdoihBpmslDHd0s4xCWUN1nwpYbP6klTajWyeY8
	 8w+ufiaU8aIE8EqK3x4dEuUmX7zmiB/PaoxQh+7SI8o2wyvRAzjJaGcC+dLNbn7q+1
	 6FrDVJ5D6Lc3kW9cUm6S3KRt2N1DjTCTMaIoKtGM=
Date: Sat, 5 Sep 2026 18:42:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hui Zhu" <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: workingset: use lruvec_page_state_local() to
 count lru pages
Message-Id: <20260905184229.8f7f30cf10638e7dc8224467@linux-foundation.org>
In-Reply-To: <2ec3a7f73e85ee5f5739c9dc2e58e9a0e2091925.1788514750.git.zhuhui@kylinos.cn>
References: <cover.1788514750.git.zhuhui@kylinos.cn>
	<2ec3a7f73e85ee5f5739c9dc2e58e9a0e2091925.1788514750.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  4 Sep 2026 17:45:55 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
> which only the classic LRU paths maintain.  MGLRU accounts its pages
> through __update_lru_size(), which skips that array, so with MGLRU on the
> four evictable LRU lists are always seen as empty.  The shadow node budget
> (pages >> 3) then collapses to slab plus unevictable pages, and the
> workingset shadow shrinker reclaims eviction tokens almost as fast as they
> are created, losing thrashing protection.
> 
> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
> race this re-exposes on cgroup v2 is closed by the follow-up patch that
> redirects dying-memcg stat updates for all hierarchies.

The follow-up patch is "mm: memcg: skip the RCU lock when the memcg is
not dying"?  But that's an optimization so I'm confused.

If we're re-exposing a race, the fix for that race should have the same
Fixes: and cc:stable as the commit which did the reexposure?

It isn't clear why any of these patches is cc:stable.  The overall
effect is a tiny performance improvement?  Very clear descriptions of
end-user effects are always helpful.

So at this time I'll schedule the whole series for 7.4-rc1.  If there's
some reason why some/all of these should be backported then please lmk.

