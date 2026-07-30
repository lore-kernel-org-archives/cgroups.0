Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B65C3E639E
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 08:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785401936; cv=none; b=mSLIrs2zpr8TNAjRf43MwT9pC8/D83ACZ1uH6obo5+GVKyvQFCMSAFVGRwKsYrYzi3Bre45t/IL2jOczu8yGD2e7tOKebhb/RCJNHRhoOPIrCG372vZ4XStKeiLyCcxbELLtYE5/P/X/KqQz7PWXXnNy8ucG8+UR22iFiw0JPkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785401936; c=relaxed/simple;
	bh=ZxIeiGcu7J7kEbS9sdXzW0cciLD/THQQev7WdgxnqQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lduowPVHkBEYYGqKlyXXK27t8azkffyDQXBrou1J0CIJeAmJIylsrWoXJc9cJCkbwXMV5ElxxehG1p2EQ0cvePx+vwDDCk2kikvY/N7Vtv+eC2imcpNwCnKJ0fz+Cvj/i1UBMHV9bNIYy0bn4CZwkJSGxVI/Og4mgVGTEcKClGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=myBJjWXk; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="myBJjWXk"
Message-ID: <9c7efd5f-f8d3-4926-acb4-34c326ffb1c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785401920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AFhMzfQqyefJXEYJAjFh+5rGJKRIhpAgY51DG4j2Pi0=;
	b=myBJjWXkQnmr9W3gwI1XddrkrmhyZuAF6cALo5kfamQOvLGiTcGR6mEJjcBsosQO5yyInI
	NBoyPGLMi6D7XYrlxORwUWUA4OGdgieRuwzm3yMz9sK3z/RFzmF3GdVb34DaR8pJVGgw43
	2Wymy3dvUCJadYLPDxBg0KzYiKxOPhg=
Date: Thu, 30 Jul 2026 16:58:03 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into
 individual filesystems
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
 dgc@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 cgroups@vger.kernel.org, clm@fb.com, dsterba@suse.com, hannes@cmpxchg.org,
 hughd@google.com, jack@suse.cz, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 Al Viro <viro@zeniv.linux.org.uk>, kernel-team@meta.com
References: <20260715103516.2410175-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/15/26 6:35 PM, Usama Arif wrote:
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
>    intentionally driven from per-memcg contexts to free memcg-charged
>    slab (Dave Chinner).
> - Add mem_cgroup_shrink_is_root() helper in <linux/memcontrol.h> so the
>    filesystem callbacks don't open-code "sc->memcg is NULL or root".
>    (Dave Chinner)
> - Add fixes tag (Dave Chinner)
> ---
>   fs/btrfs/super.c           | 10 ++++++++++
>   fs/super.c                 | 19 ++-----------------
>   include/linux/memcontrol.h | 21 +++++++++++++++++++++
>   mm/shmem.c                 | 10 ++++++++++
>   4 files changed, 43 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a7d804219bec..cc4537435399 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -22,6 +22,7 @@
>   #include <linux/namei.h>
>   #include <linux/miscdevice.h>
>   #include <linux/magic.h>
> +#include <linux/memcontrol.h>
>   #include <linux/slab.h>
>   #include <linux/ratelimit.h>
>   #include <linux/crc32c.h>
> @@ -2434,6 +2435,15 @@ static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_contro
>   	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>   	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
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
>   	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
>   
>   	return nr;
> diff --git a/fs/super.c b/fs/super.c
> index d2d04a6f4f84..a8fd61136aaf 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -24,7 +24,6 @@
>   #include <linux/export.h>
>   #include <linux/slab.h>
>   #include <linux/blkdev.h>
> -#include <linux/memcontrol.h>
>   #include <linux/mount.h>
>   #include <linux/security.h>
>   #include <linux/writeback.h>		/* for the emergency remount stuff */
> @@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>   	wake_up_var(&sb->s_flags);
>   }
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

Hi Christian, it looks like you missed this when pushing. The commit
0ef8faff490be (next-20260729) doesn't include this part of the code.

Thanks,
Qi

