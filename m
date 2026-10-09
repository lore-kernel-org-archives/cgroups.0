Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153094E13EF;
	Fri,  9 Oct 2026 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555725; cv=none; b=UhP7wywFJPZCFNij9RJMiSOV3v+73DLoI5marHfXE0GfQmUmSiLBkzzDOLn7LfX12zmW12MEXxZ2zaJv88VO5NIX+X+e3CPWc2tsusmwLHngRN6oowr0T6Z5Up06nqGAHgY9AGpTTrP3jIbZPldPMk6t0JaCSF/ownFofYi/1z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555725; c=relaxed/simple;
	bh=cEk7UtfOw0m/HJ5m4IqOoQp4D/REMPzShSeM3GZ78xU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eH7KT6CZ5YvwapMzwk2PxUUbQEn/Uqll+XYjmxsdBTzW624DNnfLa10L+5p591guHzoHTpOwm/u5R7aNtjqqGGMhVMQesgRrmcul8Iu7LEeKStfVBFh+PXfgTHZG81I/HzG95kUSyd+LPMRbAy4fqfdzIfMJbrOS/Ub8UST90r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0VPT2ge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0VPT2ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C6D1F00893;
	Fri,  9 Oct 2026 14:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791555723;
	bh=zBnO3x40NIzVOgWJRZVkADybTZas0fGVJZTACvz2ApI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J0VPT2geg9nK4PxvkGdJPDu1Ax2DB4cYIOYa0LlOk5CNt47gcJXXwVes5he9zpyMb
	 fdcj3kb6IcAbic2YTs83/uVmj2sIRXVbOmtG8+qjWDvrGYZu/sbGQm6GszWj4esD0s
	 ZnSZiOSAhpQTGTKtFvJaG0gsTUFnzqpG1rQRrNwzwTmF3KnNL7oakXb+GkJpQ354HY
	 uVOsd+bTqrzZ8V/WvNG4TSwgcA028JmqpUSzBnupx7vRy+L1mbvoarx0ECPbxOsUGD
	 sOm77pYYA2gkT4AvO7UMrqNENyeR2dpGpbfEWb1ic+Qze5UmCZxXqlaWxyuiaGFBNQ
	 ZDrR6oUHQOsYg==
Date: Fri, 9 Oct 2026 16:22:01 +0200
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <asjhg2e4-WSeKuXd@thinkpad>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006092035.166776-2-kees@kernel.org>

On Tue, Oct 06, 2026 at 02:20:28AM -0700, Kees Cook wrote:
> Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> accounted only through SLAB_ACCOUNT on its bucket caches.

> With
> CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> which do not account it; the same happens when kmem_buckets_create()
> fails. Either way, the allocation is not charged to the sender's memory
> cgroup.

Ouch, now I see what's gone wrong here... 
The fix for this bug should be Cc: stable IMHO.
Allowing to escape memcg charging is not good.

> Allocate with GFP_KERNEL_ACCOUNT again, as before that commit. Memcg
> charges such an allocation in whichever cache serves it, so drop the
> SLAB_ACCOUNT, which no longer adds anything.

Hmm in the long term we don't want allowing __GFP_ACCOUNT allocations
that are served from slab caches without SLAB_ACCOUNT, as this wastes
memory.

See: https://lore.kernel.org/linux-mm/20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org

And now I see the initial kmem_buckets design did not sufficiently
tackle the question "How this should work when kmem_buckets falls back
to kmalloc?"

I suppose the kmem_buckets' abstraction should not be too tightly
coupled with kmalloc caches. Creating a kmem_buckets should be
conceptually equivalent to creating a set of caches with speicifc
slab flags, size, align, useroffset/size. (for variable size allocation).

When it falls back to kmalloc, kmem_buckets itself should provide a
compatibility layer when falling back to kmalloc.
(Okay, allowing ctor is completely broken, but other attributes are fine)

...I don't agree with the idea that "since kmem_buckets can fall back to
kmalloc, kmem_buckets can only have the same requirements as kmalloc
(slab flags, alignment, etc.)".

By that logic, shouldn't we give up specifying useroffset and usersize
too? :-)

> Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
> CONFIG_SLAB_BUCKETS as y and n.
> 
> Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
>
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
>  ipc/msgutil.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/msgutil.c b/ipc/msgutil.c
> index e28f0cecb2ec..1ba8e59cb255 100644
> --- a/ipc/msgutil.c
> +++ b/ipc/msgutil.c
> @@ -43,7 +43,7 @@ static kmem_buckets *msg_buckets __ro_after_init;
>  
>  static int __init init_msg_buckets(void)
>  {
> -	msg_buckets = kmem_buckets_create("msg_msg", SLAB_ACCOUNT,
> +	msg_buckets = kmem_buckets_create("msg_msg", 0,
>  					  sizeof(struct msg_msg),
>  					  DATALEN_MSG, NULL);
>  
> @@ -58,7 +58,8 @@ static struct msg_msg *alloc_msg(size_t len)
>  	size_t alen;
>  
>  	alen = min(len, DATALEN_MSG);
> -	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen, GFP_KERNEL);
> +	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen,
> +				 GFP_KERNEL_ACCOUNT);
>  	if (msg == NULL)
>  		return NULL;

-- 
Cheers,
Harry / Hyeonggon
