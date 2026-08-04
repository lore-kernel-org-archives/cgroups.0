Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD132432BF4;
	Tue,  4 Aug 2026 11:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785841563; cv=none; b=C09eeifgQv8t3il/Eq2wGjCpCOcE986BKTGYa48YMsSJBE4DRbTEHK0z18gRGXvt9OT/H8xy08fd1acp4JcHbsobCqbmaybSkBy1wsC/2dWcXYjGJkQKrk7Yb9wfsULsw9/7UALwgBo+m8nvjDfUlVghvWCklU9sLUvop2ADbAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785841563; c=relaxed/simple;
	bh=tm0QQfWUcitnKhhP8a8G3wriHBPTymdKwTFnHH7S9TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aY8cD0WR7FmkZvj3iD294KEj6k73tGlUoEfZkSjvUH1CrTnI+DU5sGFylzRVT2pEV2buAbmh6mJuWFo9PIsQRmygGB8DwsTvsvq78uTRI7WkQaATSil9NlPdEjGYLlpAC9fUSlrV/V4gAeI3L4ERvwnIIyC2AYUVb7L6rC5PtsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oD5Zmkw0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oD5Zmkw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA24B1F000E9;
	Tue,  4 Aug 2026 11:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785841561;
	bh=mc7qeLHMRbW/wC7gufGWIVBnXgSs6EdAYNqGrTgnYxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oD5Zmkw0aY6RdWQAIBbdYCG78Nk2rXWrkFZsM3mMlbhiE5pm9KGqkkdsvap9UcY7W
	 xnnd0ZaLiP9GsAPqrHEzYNtK3JWjoR77bSfunQQIY5RhnKuQqr6KpF+LrtULpaIyrx
	 gcCgMkd8YIpCCpjipttzwbUxQnkglxYtOTE+ZkZHJ/a5/hE7uQH6jxFv9+sqCDiwJ0
	 kaY1EgRhdppszstjOWbZpZF4jqfY6cu7Uicd9OgWIu/Rbg0dTDVMi3DB/RlSgf37Ps
	 XkmpcOYaILXsmybetLvLW5De9Gz6Z2wYc2a26LZhIMeiNRcXbs2r1rp52Ec4535LHO
	 M6/k5q/jUOp6A==
Date: Tue, 4 Aug 2026 12:05:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
Message-ID: <anHG7BcQ8EFrwvGm@lucifer>
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
 <8179be78-a35c-4d0f-8034-27f3154db0e7@kernel.org>
 <7e7c8e04-646f-4135-9ba5-e0c7fd6d8b41@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e7c8e04-646f-4135-9ba5-e0c7fd6d8b41@kernel.org>

On Tue, Aug 04, 2026 at 12:51:40PM +0200, David Hildenbrand (Arm) wrote:
> On 8/4/26 12:45, David Hildenbrand (Arm) wrote:
> > On 8/4/26 12:08, Lorenzo Stoakes (ARM) wrote:
> >> There are a number of internal headers local to mm/ which reference
> >> functions and data types without including the relevant headers.
> >>
> >> mm/vma.h is a special case that intentionally does not include additional
> >> headers, but the others are not.
> >>
> >> This breaks tooling like clangd (which is where I noticed this), though the
> >> build is OK due to the C files including the headers happening to include
> >> required dependencies.
> >>
> >> It's better to be explicit about dependencies anyway, so add the missing
> >> includes and fix clangd as a bonus.
> >
> > I'm curious, how did you identify these? The mm/vmalloc.h is rather easy, but I wonder about
> > e.g., mm/shuffle.h including mmzone.h.
> >
>
> To clarify, I have clangd running behind a vim plugin, and so far it just worked.
>
> I had to generate a weird XML at some point that does magical things for clangd.

Well for me I get the kernel build to generate compiler_commands.json and use
that via:

	scripts/clang-tools/gen_compile_commands.py vmlinux.a arch/x86/boot/

In a build script.

But maybe I need your weird XML... I do get frustrated that it limits things to
what I happened to compile. It'd be nice to get it to index literally everything
somehow.

>
> So I'm curious how to invoke clangd manually to actually get these reports.

See other reply, it's just that I noticed missing symbols.

Actually this happened with vma.h (I sloppily got AI to figure out any other
cases) which _intentionally_ doesn't have includes.

But clangd lets you work around that in .clangd:

If:
  PathMatch: mm/vma\.h
CompileFlags:
  Add: [-include, mm/vma_internal.h]

:)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo
