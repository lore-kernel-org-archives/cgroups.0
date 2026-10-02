Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4699431E824;
	Fri,  2 Oct 2026 19:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790968873; cv=none; b=DYwy5Yn9pFuQKu/ndJP8I64cwpKbf5m4XtyVDiF9Z9rcJiPBO8Jlfl7jCRCbNs3t9b273Nfm1g1abAxKv0F9smLXlDfHeR/akKKRnOREOZJlXyqoGP0tFTu6bj+CyHwu2HFNyWVU81UHN898nPenYt7gjc0sTYn/XNNlmoncFTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790968873; c=relaxed/simple;
	bh=PP9J+oyLqRV9tkgj7WBN+AyMzFH8/Jp0KaFp6pHE0DQ=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uHs/hYS/z16JNiYSD/cQPefh/xRpDWyQ6DGbVY8Z0PYrCZ3KrsGx8GJoIkT+fh7x0VASAFTliLuvjWdw3k1iffTL5/ym8L6KN/pIbXr6EJu4gAMwamJhkV76hN8iELewnZl8QwH8u6+mz1P/6Rket5mbfwct13VkpzbzB+83U6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBHsSDNp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBHsSDNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D641F00893;
	Fri,  2 Oct 2026 19:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968871;
	bh=y6ZufPODuIHzGF3QNb5bOqql0/Xf5uMartGb9nYO4gI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EBHsSDNp7SJRGlgzs1s4PvOgtoI+WThEUd6L3zusu14fF9Utndhrof2SlWJ0i39Pe
	 9T26TGOv85czWPVV7eDQXIPcm+GnstsRvy7bnniBlBr06sjbs5zVXiUfbAJKt7wFUS
	 IHKxtSWvSyFeWy8eHkFsK0IlLb0Gqvi+Q/IiYy+/gxptoTtALdupBaU0TWhdtgEtOo
	 8jKr/9WKYjKSH3LgPyhy9N7QeycHORIo0YPIWrXdGLHd6ay0+BofOOWNVw9iIp23re
	 X2F1VUs7t7NeY2p3NQsglPI4wW7nGfL2vE4+9mVc7+PQ1RXIjh0q2jnKhtz/utdKvB
	 4mNxoaGwLxrLA==
Date: Fri, 02 Oct 2026 09:21:11 -1000
Message-ID: <ccbcb8e5f806ae1d29164b53551d61ef@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v5 2/3] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20261001-wb-dying-cgwb-flush-v5-2-8361eb8c65c6@honeycomb.io>
References: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
 <20261001-wb-dying-cgwb-flush-v5-2-8361eb8c65c6@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Liz.

On Thu, Oct 01, 2026 at 11:50:20PM +0000, Liz Fong-Jones wrote:
> + * The wb may have been killed and its blkcg association may be stale.  This
> + * is what foreign flushes want: they target the wb that owns the dirty
> + * inodes, which can be a killed one.  Use wb_get_create() to get a wb to
> + * attach inodes to.

The next patch attaches inodes to what this returns. Maybe just say that it
returns the wb in @memcg_css's slot, killed or not?

> + * This function uses css_get() on @memcg_css and thus expects its refcnt
> + * to be positive on invocation.  IOW, rcu_read_lock() protection on
> + * @memcg_css isn't enough.  try_get it before calling this function.

This describes cgwb_create(), so wb_get_create() is where it belongs.

The struct bdi_writeback comment in backing-dev-defs.h and wb_dying()'s
still describe the old lifetime rule. Can you update them too?

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
