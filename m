Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BABF4EBAFE;
	Wed, 14 Oct 2026 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983788; cv=none; b=kBpP3DlGtgJCgJFacjnChET8U45QbQUojGhE+4g7foa7pG+qbyFOkb7kw7HzoVfEt5zOt3IWnpQ7ZNzwdGv01K7TgzJpGxoKFh3wdRmvZUFOjDLlAY3hiW1hAvgLUncKeqq2ZU2RKfvb7UJzU+uTMptrK2H4HUymUQAo2k+LqRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983788; c=relaxed/simple;
	bh=ibCuS2Gf6sgha0eLrUBR7Zyprs38RioaCxnk8Wma81w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kpKZQf3wnkClF1gsj9W1SepL4G/YT+1c1w7Me0UncvCDczZRMKNEu5b/dlcbeyV3tSrPyPYN/Cpk2JiAHBrzwx6QVo1bAB5eDngz3qXsdoI18ibd96zsIqnTH74aweKbAJOlGowiz7aet9rHrcTX3798t5k/WEU1ES6gJ6Qq1zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BBho0QDF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BBho0QDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6051F000FF;
	Wed, 14 Oct 2026 13:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791983786;
	bh=hrpo4cN83jrj+e2I5RQ50g0XlOIzeJ58mg+PewPmR3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BBho0QDF8uf5LQYJduMCtXsQHoR7qkt/9uXjiXsow2im7mQgSGD14LO/UIlh0jYpA
	 bRtbtrnXDJz05sPV/9eEiBlxQwp5PSiN9BkMDJ3he8d/9Icjqj+a/4YdKVXK287e6W
	 MCTrvva80BsCMHIESG2+JqR70b8iJS6KUjxt1B19GBlhZXupMbqsCrXFK6ww8U0XKz
	 B4GygYXRmfEBE1qeQUmtkOgW2WDrJXm5Q1/VXhoWCnQU9rpE4vB8OnKHGHST7n0DXT
	 Qr9KNgC0S1fgR2/eBzpe/4Xq57L6fT8DJKxBJ4IMY+Ojd8Jd3lx9rev/yVUTZDajsE
	 +dkHNMmbi+qpQ==
Date: Wed, 14 Oct 2026 14:16:24 +0100
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, stable@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] ipc, msg: Account msg_msg allocations with
 GFP_KERNEL_ACCOUNT again
Message-ID: <as-AWdUncVtquHdv@thinkstation>
References: <20261014052338.nothing.279-kees@kernel.org>
 <20261014052344.384723-2-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014052344.384723-2-kees@kernel.org>

On Tue, Oct 13, 2026 at 10:23:43PM -0700, Kees Cook wrote:
> Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> accounted only through SLAB_ACCOUNT on its bucket caches. With
> CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> which do not account it; the same happens when kmem_buckets_create()
> fails. Either way, the allocation is not charged to the sender's memory
> cgroup.
> 
> Allocate with GFP_KERNEL_ACCOUNT again, as before that commit, so the
> allocation is charged whichever cache serves it.
> 
> Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
> CONFIG_SLAB_BUCKETS as y and n.
> 
> Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <kees@kernel.org>

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

Thanks!
