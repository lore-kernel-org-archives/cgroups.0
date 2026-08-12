Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C29D3A6B73;
	Wed, 12 Aug 2026 22:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786575012; cv=none; b=GACGGXyOIDdNhwYul5Vbwlbd5IamFs24BU5G7KNyTA22XQUJGQbiCNu39uNy7ob0Mitkvop5UbGHN/I+kAHc5Ck1NI4D0Mm/V4KBIly6bB7Sut/NNOEBTo8j19E6ZzujH8nsTtxUK5mbPqlPL2DWJDZ0wUhTG13BAQiFgTPMBgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786575012; c=relaxed/simple;
	bh=bjjz7nNUvL+Z0BFBXzx+ECunLrF1peB3LDErRFgu9/0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=VZWYh0Trhv8d1YfHNSPXXsshHgghh5sNRTSnVU6IzE4d7VDfOS7OTmFiKh1gZxIZKwZ8eyRhq1o+C9sBxbvwVUXJxjzoooFO9x3g83tl0PJTz4EoNjUfjaF/M44kD6imFXohSxkiQzNEL0eOgcCbFR7RXEuDzksYB9REhUMVWmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZP2/two; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZP2/two"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34681F000E9;
	Wed, 12 Aug 2026 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786575011;
	bh=jX1mtHvsVWE4pAYEkaJGnNdeV9GfqdK01h7t4lsHXwE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qZP2/twoQ3M6TVc5K/4I1BejDEiVV/5s1xxUZWr+68fh1f4NGuze+uNFmhKGphuwS
	 IDWzhDdhQucWY5qGffH0ue8tsfYipYzw11nEWRJfDAk1JemHr5cN6Ug+Ox+bZbNgOt
	 GBZUmjLQXGzvtRqw8eYb/ANowk9aWXMTDNKByUmM=
Date: Wed, 12 Aug 2026 15:50:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/9] memcg: make the v1 soft limit knob inert
Message-Id: <20260812155010.8710b4a9191c9ee4ad6da255@linux-foundation.org>
In-Reply-To: <20260811203203.3456029-2-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
	<20260811203203.3456029-2-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Aug 2026 13:31:55 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> The v1 soft limit has been deprecated since v6.12 and nobody has
> reported depending on it. Start the removal by decoupling the interface
> from the implementation: keep memory.soft_limit_in_bytes, but ignore
> writes to it and always report the maximum value on read similar to
> what memory.kmem.limit_in_bytes already does.
> 
> Writes are still parsed, so malformed input keeps returning -EINVAL.
> The knob now also behaves the same everywhere: it used to return
> -EOPNOTSUPP on PREEMPT_RT, where soft limit reclaim has always been
> disabled.
> 
> This also fixes the syzbot report linked below. Soft limit reclaim is
> the only caller that runs shrink_lruvec() from kswapd against a
> specific memcg, so it is the only way to reach lru_gen_shrink_lruvec()
> and in turn set_mm_walk(), which warns when called from kswapd.

Thanks, I'll pluck this one as a hotfix.

It's old code, yes?  Are there any theories about why the sysbot issue
has just popped up?  Should we backport the fix?

