Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74214FD7B2;
	Tue, 29 Sep 2026 13:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688638; cv=none; b=bayIW6pbLzBaSOtH9B8S+qE/2OsCck2s0PePF5Kt2hSnKhRrS0k9txJXSkawyGLW5+eV8RsYL9QHoriSJBjaz/DVkpJ/JtX5a91qO4MFP5ceLkBXYPMWOjlVLO9eL4ozeE+gNUBPSxNLLilkSrFDY7Vbt0Kc5h1HaHFJUACGVFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688638; c=relaxed/simple;
	bh=CRSnFDcudn+O1z3dXdbQUFJ7Fo6ozes9yh9CgLUwIMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=me/Qv0MLiGOR0+Wu++zdXYbldY9fs2dRbgTTN/DNpxfxXmGAPe0B0s5LmvMDgb7JvArp/g+78A9BIVbpYDgFTQttSoZNpTuQCcS8LbpQS5Z/bvYCF1LbPkOt2tx5+KpBQWKicFRDjme3vDaY2D2O41QV2CSCpITxaZIEovWX4gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwQw2msT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwQw2msT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA871F00893;
	Tue, 29 Sep 2026 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790688637;
	bh=CktuKaVpQF4v7fUWgp1B/FLtTW+0VHvulKFUhKzny6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OwQw2msTwGYBWjPIoGKWVaY9WOrD1EfK00LheuYYhSxVBHTi2aKUA3nRNzWydFewU
	 WgoXCi06D905T8lhQFKvNWjqkRDrHGUNbaaLm/N0HEKKq0Bs6jb0MR3YwfUqs18DLQ
	 4eHYqxCVQZmmQvSDMZVWPugfwOuA70ZEOktwOaEICARldtAvNcN6MuQeA++r4KqfXR
	 IS1k+/0fdIHSaG+OXsD/WvDZo6VQWrFxON6f4A60vmBvvJWBP7yeOfEhHm6+enA7zR
	 5+8oou/1UJFxgoVbvH6Gm+5GZw0Crq5dBu/hEmLy1BLSsR6wM9kUBlWoLjUXidPRan
	 sgp66J7A8QPaw==
Date: Tue, 29 Sep 2026 14:30:35 +0100
From: Harry Yoo <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 RESEND 1/5] mm/memcontrol: flatten try_charge_memcg
 control flow
Message-ID: <aru8sLRda2q3DMoF@thinkstation>
References: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
 <20260928192349.3432886-2-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928192349.3432886-2-joshua.hahnjy@gmail.com>

On Mon, Sep 28, 2026 at 12:23:44PM -0700, Joshua Hahn wrote:
> Refactor try_charge_memcg by flattening the nested memsw/memory
> page_counter operations to separate the logic between the two.
> 
> When page_counter_try_charge is made stock-aware, this flattening makes
> the control flow easier to follow since each page counter now has its
> own success/failure paths.
> 
> No functional changes intended.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
