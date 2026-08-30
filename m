Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170312EF653
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 07:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788076445; cv=none; b=IT0L6VADqFBJdDidMJyspSxqPa8rehx3LNLWba4TQyTr3QXfs2tNqrSLShUG9ms6rfh8icvZBBwBAAcZnBZYHaWCt5IanQAC92gIx4HQAcStcmRLQCJ+kR0YgVDwChSeeLC5aXzlKLST8cGO/JN29bOajVdu/yvkgSeRHSfejw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788076445; c=relaxed/simple;
	bh=Hn03e+/WULF81D3yHyPxkS+4ZIZvHapTPnkx+jlSYf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VYmnIq4QmzRBUCfS218chOFw+DLCS6MHzKooqriuysj0iK7+XT9p+9/lVQlnIixYjsMmHxESCfHg3SsemgSSs6nTs2yvankdnxmvCTtcI5VLpei8NSd0NAyB5gAxHDHWkyADrVmiH2mBXENhC5BW2HVhEEeBFR+0c+9UFR9JI/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocy4ylfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocy4ylfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6D51F00ADF
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 07:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076443;
	bh=UeEQ5jVzcI0HkkaBYNG8dZHlQd9/ubRiXJT++zIWi7M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ocy4ylfFrWKNIBjucLRgP/bcUttjvfQaZdfmC/pHFTioFbRGlQ/BlBKtxGZvpA56x
	 y5ImLCwoTbty6dkS6KMS89q6JBdaD+/NQTN5LkWHvvPGlmvCnDIw8/djn59ZygBqOv
	 qpf6b1LPrGedr/UXbe+Q7ljzC/EK74Z0OZfMDyxNLvShInFyiXq22EwFZBrL7ZaP90
	 A1o3rLatmXqkczN8qBvTranP1LLvheI1b78mbPVMICwC8PwQZ6zS3T3aK3OzuKZ781
	 BMoERzwL+5IbTPFjHwrOp6xKzLVWu4mbxGH77VAham2ilthQ3rh/KxqQjwbVAoXHAA
	 +v6+rbaqH2HMg==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9390a2c8909so160711285a.0
        for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 00:54:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro+WIuiyM0JrRQQzYMejAF7oJgrptO5m/qwwskPhoihhF5OJn2A5KJoXd1tnpH7t3ZoVaPf01wA@vger.kernel.org
X-Gm-Message-State: AFuF++nfI5yemD6/7/+1fPRPAaNQbHwZjSoQXk3bzkPCugyhF91QFueF
	yvks76l57VkMFrfm+qfieOz4WxPHFQzNJgnCn3Al/B614H0V7llGHEV/9/TSFZdAhwR0541c1ly
	yQ9VCDMRdVLT2t3sEi/YTERllVCSQY2Q=
X-Received: by 2002:a05:620a:6c0d:b0:938:fd60:4f9 with SMTP id
 af79cd13be357-939138ffdc0mr2008314785a.27.1788076442846; Sun, 30 Aug 2026
 00:54:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828110919.1324028-1-ridong.chen@linux.dev> <20260828110919.1324028-3-ridong.chen@linux.dev>
In-Reply-To: <20260828110919.1324028-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 15:53:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
X-Gm-Features: AcwNN1XAAY1zLhOoDIQLd7-dIIw1xCvdhjIWr8q4jSclCc3cBnbDulr35kYiJ1A
Message-ID: <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 28, 2026 at 7:10=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> memory.min/low is silently bypassed for MGLRU during global proactive
> reclaim (writing to the root memory.reclaim) and global direct reclaim.

I guess nobody is silently bypassing anything. It's just that the
effective min is stale data. If kswapd has run at least once, should
the protection have been updated already?
I guess we need to update the changelog a bit?

> It can be reproduced as follows:
>
>   # echo 7 > /sys/kernel/mm/lru_gen/enabled
>   # cd /sys/fs/cgroup
>   # mkdir -p a/b
>   # echo 100M > a/memory.min
>   # echo +memory > a/cgroup.subtree_control
>   # echo 100M > a/b/memory.min
>   # echo $$ > a/b/cgroup.procs
>   # dd if=3D/dev/zero of=3D/tmp/testfile bs=3D1M count=3D200
>   # cat a/b/memory.current
>   222650368
>   # echo 500M > memory.reclaim
>   -bash: echo: write error: Resource temporarily unavailable
>   # cat a/b/memory.current
>   6070272
>
> memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
> protection. The traditional LRU path is not affected because
> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
> visits during a top-down tree walk.
>
> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
> moved the protection computation into lru_gen_age_node(), which only
> runs for kswapd. Non-kswapd global reclaim reaches shrink_one() through
> lru_gen_shrink_node() -> shrink_many() without any protection
> computation, so emin/elow remain stale or zero.
>
> Introduce mem_cgroup_protection_path() which computes emin/elow along
> the root-to-target path only by iterating through the cgroup ancestors
> array top-down. This avoids the full tree traversal that would be
> needed with mem_cgroup_calculate_protection(), limiting the cost to
> O(depth) per memcg - typically 3-5 levels.
>
> Call it from shrink_one() for the non-kswapd path so that each memcg
> about to be shrunk has correct protection values.
>
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/linux/memcontrol.h | 11 ++++++++++
>  mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c                |  8 ++++++-
>  3 files changed, 63 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7d1c0ce189a8..8066b798a759 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -605,6 +605,10 @@ static inline void mem_cgroup_protection(struct mem_=
cgroup *root,
>
>  void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>                                      struct mem_cgroup *memcg);
> +#ifdef CONFIG_LRU_GEN
> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> +                               struct mem_cgroup *memcg);
> +#endif
>
>  static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>                                           struct mem_cgroup *memcg)
> @@ -1133,6 +1137,13 @@ static inline void mem_cgroup_calculate_protection=
(struct mem_cgroup *root,
>  {
>  }
>
> +#ifdef CONFIG_LRU_GEN
> +static inline void mem_cgroup_protection_path(struct mem_cgroup *root,
> +                                             struct mem_cgroup *memcg)
> +{
> +}
> +#endif
> +

I wonder if we could follow the zswap pattern?

#if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
#else
static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
{
        return true;
}
...
#endif

>  static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>                                           struct mem_cgroup *memcg)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..095050d4296a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5198,6 +5198,51 @@ void mem_cgroup_calculate_protection(struct mem_cg=
roup *root,
>         page_counter_calculate_protection(&root->memory, &memcg->memory, =
recursive_protection);
>  }
>
> +#ifdef CONFIG_LRU_GEN
> +/**
> + * mem_cgroup_protection_path - compute protection along root->memcg pat=
h
> + * @root: the top ancestor of the sub-tree being checked (NULL for root_=
mem_cgroup)
> + * @memcg: the target memory cgroup
> + *
> + * Walk the ancestor path from @root down to @memcg and compute the effe=
ctive
> + * protection at each level.  This is safe for isolated queries because =
it
> + * ensures parents are computed before children.
> + */
> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> +                               struct mem_cgroup *memcg)

Can we rename it to `mem_cgroup_calculate_protection_path()`?

BTW, I see that the only caller is in vmscan and it passes NULL as
`root`. Do we need to keep the `root` argument if the new helper is
only used for global reclaim?

Best Regards
Barry
