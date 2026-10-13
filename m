Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEBA47FAE6;
	Tue, 13 Oct 2026 03:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791863182; cv=none; b=d/1yOdmu+rCV+8pc0EwncUhdDQdSjB3KW+bWHNj9qiv6EBYTeBmbqI054b8sfAcAkOtFhKBYZBX8SV1myD8/82aUkM7v4etMR4Iz46bysBGb47B6QNPK0b+vZ6KYphaRlg6VUXv/GCk7NTAFIHxLUmkGdRnwFTfaDl4WAy1uDQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791863182; c=relaxed/simple;
	bh=RhIhPrAPsTnz5pQ9KOdBeslQrq84PfQbaYRRruCJAEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StOaTXHeOTgEogCCEy5k58yT4NLnOi9Sd0n/mobWKPrUBr6zzKCmRSRs8rvkjuwaL1fWCdzUBOnr8msNmmcuxZUK9bbxqf7CgQiQdFqmslEq7bzl9oDiTsDFCyQXKToFA48G1qexVLw2iXhPbS5uWZWcsL4mfqX38McPZLW9aqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGjuDRH7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGjuDRH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534BB1F000FF;
	Tue, 13 Oct 2026 03:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791863181;
	bh=gC6zFEfTKNW+9VnhF2BDN32Uuy+DW12hIGMiIIHt3k4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cGjuDRH7fd9Q/vGOFT7srXE4MzTaO0zvziw1vupAjmuNfJNV1aw1OWZUFLjuLqLq/
	 I87VuwtS1dHs5FQ/DKdlQisdn43nyzXs9Kd4T6xzP4a1TQWy45Re6iwudrZ+5QtEFV
	 fzz0HzS82PYt3Xg92bu5uvNyIhnz725muXUX2lfYjTmpv6xKxmB0EYSWqqZOrA1zQB
	 1lEKQvnQnz5DIPbu9YI7ZSuAG1Pl0hqbabAb9PpdL1iwfvHMFjz5A/s173yYvtg3Yh
	 4I6L0EMZ5eWiwYWI/6OsZ2o19PmZpjPcEAGi5dNXnpqJVXBO2/H1jcejotXKyWlDgu
	 PjEnZQQ010M0w==
Date: Mon, 12 Oct 2026 20:46:21 -0700
From: Kees Cook <kees@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <202610122044.1E1CDBF72@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <38befa8c-3885-44eb-813c-0ee34cd55248@kernel.org>
 <be34b92e-e82c-4f69-ac9d-b045081ea418@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be34b92e-e82c-4f69-ac9d-b045081ea418@kernel.org>

On Mon, Oct 12, 2026 at 11:03:18PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/12/26 19:55, Vlastimil Babka (SUSE) wrote:
> > On 10/6/26 11:20, Kees Cook wrote:
> >> Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> >> alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> >> accounted only through SLAB_ACCOUNT on its bucket caches. With
> >> CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> >> kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> >> which do not account it; the same happens when kmem_buckets_create()
> >> fails. Either way, the allocation is not charged to the sender's memory
> >> cgroup.
> >> 
> >> Allocate with GFP_KERNEL_ACCOUNT again, as before that commit. Memcg
> >> charges such an allocation in whichever cache serves it, so drop the
> >> SLAB_ACCOUNT, which no longer adds anything.
> >> 
> >> Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
> >> CONFIG_SLAB_BUCKETS as y and n.
> >> 
> >> Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
> >> Assisted-by: LLM
> >> Signed-off-by: Kees Cook <kees@kernel.org>
> > 
> > Could we, for the purposes of a backportable fix, just have both
> > SLAB_ACCOUNT and GFP_KERNEL_ACCOUNT in place? That should do the right thing
> > regardless of CONFIG_SLAB_BUCKETS state, no?
> 
> BTW we're thinking to add 1+2 (once this part is clarified) for 7.4 (with
> stable@ for patch 2). 

Yeah, I'll respin with it present on the create and the alloc sides.

> But for the rest we'll have to target 7.5 as it's only
> a week to the 7.4 merge window now.

Yeah, that's totally fine; I'm in no rush. I want to get it right, and
I'm still recovering from my surprise about how GFP_KERNEL_ACCOUNT
actually works. ;)

-- 
Kees Cook
