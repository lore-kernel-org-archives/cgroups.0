Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFFE3AE187
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 10:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786357215; cv=none; b=pykqnV7uaVug36dTu/CkL1Ll66zs2OSrSUK0o/n2VZZQQukSjpqWbfXBhimH0ZyBdCEXU589qQM4BpJhLdgM5f6foFQ+e2LKH7dyc/6NwyZhbGJrJXQGod0VSM42upCZVTFLCEnUj+mp+8vOJCR47pcENPJdhs3BjguyamVXfPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786357215; c=relaxed/simple;
	bh=S3tC3XwyCQIlqsXvJZnXU3u+9DkFlQbCtiIWEShahuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seosJJv64T5hXZdQEACHVr1dLL5zDQ+/9K1iA9Y8zY8K9fp0Ne7hK5Yy0gMDInwd+KX9uNlOVpzOrGmcDeSzsM0yI2Pe1XGOzKazEGrYX3FEEnLDQHw8Gc2+e25i9YKgPXaMgYUVFGDpmfFzuEL5cEuLH/Kdwq2oZGPEGSz6HeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fGXDlnyO; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fGXDlnyO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786357201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2kxNcoz88gUTv2RyDdUD2oJ4g9y+1zQ1kNSN4EE2fzA=;
	b=fGXDlnyOZW78tBnMnlQ1tn0gaqx7mSxN8jnpxd3X5ZBs5A+AHB+T0i5Ka2ATUkpwOgnsv1
	KMqRp0Augsx1/HsaVXbYVEtsd6TD99UKyuJ+3mT8utVuks9GQoMS+0WK8+l44Y4crMrbtQ
	xIGnFQ0O2uyU8LD3THLBVtNK7IeoZsw=
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	david@fromorbit.com,
	dgc@kernel.org,
	qi.zheng@linux.dev,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	cgroups@vger.kernel.org,
	clm@fb.com,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	kernel-team@meta.com
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into individual filesystems
Date: Mon, 10 Aug 2026 03:19:52 -0700
Message-ID: <20260810101954.822260-1-usama.arif@linux.dev>
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 15 Jul 2026 03:35:16 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skipped every
> ->nr_cached_objects() hook whenever the shrinker was invoked for a
> non-root memcg, on the assumption that none of them honour sc->memcg.
> 
> That assumption is wrong for XFS, whose inode-reclaim hook is
> intentionally driven from per-memcg contexts to free memcg-charged
> slab. Encoding a blanket "never memcg-aware" policy in fs/super.c
> short-circuits that path.
> 
> Push the check down into the callbacks whose counters really are
> irrelevant to per-memcg reclaim - btrfs_nr_cached_objects() and
> shmem_unused_huge_count() - and drop the fs/super.c gate. Each
> filesystem can now lift the restriction independently if its counter
> later grows memcg awareness, without touching fs/super.c.
> 
> Introduce mem_cgroup_shrink_is_root() in <linux/memcontrol.h> so the
> callbacks don't open-code "sc->memcg is NULL or root".
> 
> Fixes: 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink")
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> v1 -> v2:
> - Do not gate xfs_fs_nr_cached_objects(); XFS's inode reclaim is
>   intentionally driven from per-memcg contexts to free memcg-charged
>   slab (Dave Chinner).
> - Add mem_cgroup_shrink_is_root() helper in <linux/memcontrol.h> so the
>   filesystem callbacks don't open-code "sc->memcg is NULL or root".
>   (Dave Chinner)
> - Add fixes tag (Dave Chinner)
> ---
>  fs/btrfs/super.c           | 10 ++++++++++
>  fs/super.c                 | 19 ++-----------------
>  include/linux/memcontrol.h | 21 +++++++++++++++++++++
>  mm/shmem.c                 | 10 ++++++++++
>  4 files changed, 43 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a7d804219bec..cc4537435399 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -22,6 +22,7 @@
>  #include <linux/namei.h>
>  #include <linux/miscdevice.h>
>  #include <linux/magic.h>
> +#include <linux/memcontrol.h>
>  #include <linux/slab.h>
>  #include <linux/ratelimit.h>
>  #include <linux/crc32c.h>
> @@ -2434,6 +2435,15 @@ static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_contro
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>  	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
>  
> +	/*
> +	 * The evictable extent map counter is filesystem-global and does not
> +	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
> +	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work.
> +	 */
> +	if (!mem_cgroup_shrink_is_root(sc))
> +		return 0;
> +
>  	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
>  
>  	return nr;
> diff --git a/fs/super.c b/fs/super.c
> index d2d04a6f4f84..a8fd61136aaf 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -24,7 +24,6 @@
>  #include <linux/export.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> -#include <linux/memcontrol.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
>  #include <linux/writeback.h>		/* for the emergency remount stuff */
> @@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>  	wake_up_var(&sb->s_flags);
>  }
>  
> -/*
> - * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
> - * operate on filesystem-global state and ignore sc->memcg. Driving them
> - * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
> - * per-cpu counters and queueing duplicate work: the actual reclaim happens on
> - * the global path (kswapd or root direct reclaim) regardless. Restrict them
> - * to that path.
> - */
> -static inline bool super_fs_objects_eligible(struct shrink_control *sc)
> -{
> -	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
> -}
> -
>  /*
>   * One thing we have to be careful of with a per-sb shrinker is that we don't
>   * drop the last active reference to the superblock from within the shrinker.
> @@ -212,7 +198,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  	if (!super_trylock_shared(sb))
>  		return SHRINK_STOP;
>  
> -	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
> +	if (sb->s_op->nr_cached_objects)
>  		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
> @@ -273,8 +259,7 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>  		return 0;
>  	smp_rmb();
>  
> -	if (sb->s_op && sb->s_op->nr_cached_objects &&
> -	    super_fs_objects_eligible(sc))
> +	if (sb->s_op && sb->s_op->nr_cached_objects)
>  		total_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);

Hi Christian,


It looks like the changes in fs/super.c didnt make it into the patch that was
merged in vfs.fixes [1]. Just wanted to check how we could correct this?
Should Qi (or I) send a followup patch?

Thanks,
Usama

[1] https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=vfs.fixes&id=0ef8faff490be6aa1a1e5dfcb0c8492689e91c0f 
