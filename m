Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F4C2E7393;
	Thu, 16 Jul 2026 01:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784164819; cv=none; b=maJm2VMCHHHNkLgqwDijBmZxBY+KefVUr2LdEdiFNJkx6V1e9NG/MrK6+3OjyE4P2etHlvQdxy7Rp2tK4avwktnOjfH18FAjNlaZmGtbGUksdLIaz/RNGnUlPtUPB7wNtl2wPyh1Etd69hAGgqa+iFvCxdynehIrXRbY8L2cnyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784164819; c=relaxed/simple;
	bh=psEq+Sv7XmBVm9NrgzLtLfCqQPDLUcg25/pXP59VBU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nFpBqUP79Wc6w+gRLoxeMt5yYIhlr8Xu7sCJdwzsBZL91MHi4/Ipo2btItbdVUsS4Tlr6PQoxnkxMe3lfFaS8VgioJ3uGp8JB46svaExfR6+6dJVoJI6JrQYUBiRAy64aYuUl3bDpUn+nZebiSXVclibnmC9Wf96pKj+Em9wFiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fevypTON; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fevypTON"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784164805; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/ef5fK1C/u5JKytDn0JDImp821HrmWjkSDu/2fR1IAU=;
	b=fevypTONIV9LwOZJ/VK5N0hWUCwQY5bMw+aWTqBd+i6T37KD3a/ehszGfM6QnTmCQDA6RoJQYC+uD6Y/WmK2ph8VFDLqNcsR15UT+EppBZcpjFkV4bwlyUSc0IzH1qAxapVjosfNcBYD9AXkzduOSV/Ztp080GCmlL8odsa1jNg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0X7AlBuV_1784164802;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7AlBuV_1784164802 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 09:20:03 +0800
Message-ID: <09771ca6-2869-4028-98a8-5d6614b48301@linux.alibaba.com>
Date: Thu, 16 Jul 2026 09:20:02 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into
 individual filesystems
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
 dgc@kernel.org, qi.zheng@linux.dev, brauner@kernel.org,
 cgroups@vger.kernel.org, clm@fb.com, dsterba@suse.com, hannes@cmpxchg.org,
 hughd@google.com, jack@suse.cz, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 Al Viro <viro@zeniv.linux.org.uk>, kernel-team@meta.com
References: <20260715103516.2410175-1-usama.arif@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



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

[snip]

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e1f46a0016fc..5407e4200460 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -520,6 +520,22 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>   	return (memcg == root_mem_cgroup);
>   }
>   
> +/**
> + * mem_cgroup_shrink_is_root - is this a global or root-memcg shrink invocation?
> + * @sc: shrink_control describing the current shrinker call
> + *
> + * Returns true when @sc represents a global reclaim shrink (sc->memcg == NULL)
> + * or a root-memcg shrink, i.e. not a per-memcg iteration of
> + * shrink_slab_memcg(). Filesystems whose ->nr_cached_objects()/
> + * ->free_cached_objects() implementations operate on filesystem-global state
> + * and do not honour sc->memcg can use this to early-return 0 in per-memcg
> + * contexts.
> + */
> +static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
> +{
> +	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
> +}
> +
>   static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>   {
>   	return objcg->is_root;
> @@ -1071,6 +1087,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>   	return true;
>   }
>   
> +static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
> +{
> +	return true;
> +}
> +
>   static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
>   {
>   	return true;
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5789a0f5a346..dc8cd4f563f4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -846,6 +846,16 @@ static long shmem_unused_huge_count(struct super_block *sb,
>   		struct shrink_control *sc)
>   {
>   	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
> +
> +	/*
> +	 * The per-superblock shrinklist is filesystem-global and does not
> +	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
> +	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work.
> +	 */
> +	if (!mem_cgroup_shrink_is_root(sc))
> +		return 0;
> +
>   	return READ_ONCE(sbinfo->shrinklist_len);
>   }
>   #else /* !CONFIG_TRANSPARENT_HUGEPAGE */

For shmem part, LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
