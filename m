From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH 2/9] slab: remove synchronous rcu_barrier() call in memcg
 cache release path
Date: Sat, 14 Jan 2017 16:19:39 +0300
Message-ID: <20170114131939.GA2668@esperanza>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-3-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=IV/AVjBcsL+rc9lLIYAZRYtZ8i/i6bk9A0UQ7bH+T2s=;
	b=J0cJHgfL8gXsuShuM6//h19ppwdCR2kEFbm613Vc2hiPOfZsE2LzEGjf1fLtEuMc+ZhUNMEL74GbLH53WhkHjaEpS3ktUapKQasteWYCq/4e94QzxN4ctmQJDhQ/sMfNiGtmUcWBvuACpKFo84SxpBMDAkyHz2q0HoLrFWxIOwA=;
Content-Disposition: inline
In-Reply-To: <20170114055449.11044-3-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

Hello Tejun,

Thanks a lot for looking into this issue as it seems to affect a lot of
users!

On Sat, Jan 14, 2017 at 12:54:42AM -0500, Tejun Heo wrote:
> This patch updates the cache release path so that it simply uses
> call_rcu() instead of the synchronous rcu_barrier() + custom batching.
> This doesn't cost more while being logically simpler and way more
> scalable.

The point of rcu_barrier() is to wait until all rcu calls freeing slabs
from the cache being destroyed are over (rcu_free_slab, kmem_rcu_free).
I'm not sure if call_rcu() guarantees that for all rcu implementations
too. If it did, why would we need rcu_barrier() at all?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
