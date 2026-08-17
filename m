Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C835537CD53;
	Mon, 17 Aug 2026 22:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787005721; cv=none; b=ZfT32ms81Ey8CqliYIpGzFqSojzGCjhjtzYouVBVhit5ulqM8TnI5VyVR3Ua708BpbO2c7cba/9azfsD/Q0A+BqVWbfwTVXgPJOZzIgxoo3e7nJ5UQhTSeFCXIgYYkj+KbOh4sGXC+Nve3RTOwwwmS5cQhaQ9dIJUmBtwAG9uV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787005721; c=relaxed/simple;
	bh=ci67Y3ydxnCm5PGsuyBo62VanLXVhMW/wP+2t4BovW8=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=BlLcYskLkTG7C/5iOh/0eE9LLqzD58HLaAUveaSSSxRGuqldXs6fELsjXRs5cAN5SXwQttXpwT1xzPFGGd4pzS7QET2INHuznlDH+iKahTLp5zVmhYdrVVvJFxKUW3CiNVfQLcr9abE4S0d0dx9HGEKw3BgLTh68OHBhqG0MaQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tc5MJbtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tc5MJbtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D2E1F000E9;
	Mon, 17 Aug 2026 22:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787005719;
	bh=2rlpVXbAykVwz9+AZePgXoC0/jk7LvitYt17kX7jkng=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Tc5MJbtRKc2T56j8TPEFqHVRu+9t5joPOQMuHGYCOUv/tokp05C+FQbSK0O2eiBlg
	 5IWqPpSe4xIud2+OHSRdawpNRCNCvNBHJp7PcMwoKpC0JwnKc8lvuCoOQOGsXVNj7z
	 o6blYSDOu6r9haWoIUnjDGOL/v3SGNHEmK+69aWdV/hKTaFJnbeq8BW5cLdE9xasnB
	 iMmzi6MU/RxDpX1W1xjSg0xBkwWi9IaSMXiIiwN8m6dNiYaEnMTqZ0S6E+bBhHIALM
	 Iz6cly0aJwhEYsGx6XEbmxzjd5/AV/8PKEqxf44xOptR/1zJ2hMBg+5znIgTTSjPjy
	 SNkKjVOAolC+w==
Content-Type: multipart/mixed; boundary="===============7619779090411820820=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <d3d3e1072f16308c6a228f3d35b9d86abce127073644c32d41e6d05d5557b78b@mail.kernel.org>
In-Reply-To: <20260817214205.723267-2-ziyang.meme@gmail.com>
References: <20260817214205.723267-2-ziyang.meme@gmail.com>
Subject: Re: [PATCH v2 1/2] block: add BPF kfuncs to read blkcg io.stat
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,kernel-team@meta.com,axboe@kernel.dk,tj@kernel.org,josef@toxicpanda.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com
Cc: martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,roman.gushchin@linux.dev,shakeel.butt@linux.dev,inwardvessel@gmail.com,mykolal@meta.com,ziyang.meme@gmail.com,linux-block@vger.kernel.org,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 17 Aug 2026 22:28:38 +0000 (UTC)

--===============7619779090411820820==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> The behavior mirrows the blkcg_print_stat().
>
> The blkg device iterator take a RCU css.
>
> No kfuncs are added to read the blkcg counters since user can read it
> using the BPF_CORE_READ.

This isn't a bug, but there are a few rough spots in the changelog:
"mirrows" should be "mirrors", "The blkg device iterator take a RCU css."
reads as a fragment that restates the earlier sentence about the iterator
taking the RCU-protected css, and "since user can read it" is missing an
article before "user".

Could the changelog also say why a new flush kfunc is needed rather than
reusing the existing css_rstat_flush() kfunc -- is the point specifically
the root-cgroup blkcg_fill_root_iostats() path?

> diff --git a/block/Makefile b/block/Makefile
> index e7bd320e3d69..572e49988c8e 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -17,6 +17,9 @@ obj-$(CONFIG_BLK_ERROR_INJECTION) += error-injection.o
>  obj-$(CONFIG_BLK_DEV_BSG_COMMON) += bsg.o
>  obj-$(CONFIG_BLK_DEV_BSGLIB)	+= bsg-lib.o
>  obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
> +ifdef CONFIG_BPF_SYSCALL
> +obj-$(CONFIG_BLK_CGROUP)	+= bpf_blkcg.o
> +endif
>  obj-$(CONFIG_BLK_CGROUP_RWSTAT)	+= blk-cgroup-rwstat.o
>  obj-$(CONFIG_BLK_CGROUP_FC_APPID) += blk-cgroup-fc-appid.o
>  obj-$(CONFIG_BLK_DEV_THROTTLING)	+= blk-throttle.o

[ ... ]

> diff --git a/block/bpf_blkcg.c b/block/bpf_blkcg.c
> new file mode 100644
> index 000000000000..25c809f5091c
> --- /dev/null
> +++ b/block/bpf_blkcg.c
> @@ -0,0 +1,154 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Block I/O Controller-related BPF kfuncs and auxiliary code
> + */
> +
> +#include "blk-cgroup.h"
> +
> +#include <linux/bpf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/rculist.h>
> +
> +__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_blkcg_flush_stats - Flush a block cgroup's io statistics
> + * @cgrp: cgroup to flush
> + *
> + * Propagate I/O statistics up the cgroup tree. Root statistics come from
> + * block devices and include all cgroups' I/O.
> + */
> +__bpf_kfunc void bpf_blkcg_flush_stats(struct cgroup *cgrp)
> +{
> +	struct cgroup_subsys_state *css;
> +
> +	/* Pin the css for the sleepable flush. */
> +	rcu_read_lock();
> +	css = cgroup_css(cgrp, &io_cgrp_subsys);
> +	if (css && !css_tryget(css))
> +		css = NULL;
> +	rcu_read_unlock();
> +
> +	if (!css)
> +		return;
> +
> +	if (!css->parent)
> +		blkcg_fill_root_iostats();
> +	else
> +		css_rstat_flush(css);
> +
> +	css_put(css);
> +}

This isn't a bug, but would it be simpler for bpf_blkcg_flush_stats() to
take the io css directly, so the same handle feeds bpf_iter_blkg_new()?
The two entry points in this file take different cgroup handles:
bpf_blkcg_flush_stats() takes struct cgroup* and resolves the css
internally with cgroup_css()/css_tryget(), while bpf_iter_blkg_new()
below takes struct cgroup_subsys_state* directly. A program that wants to
flush and then iterate therefore needs both handle types for the same
cgroup. Taking struct cgroup_subsys_state* in both, as mm/bpf_memcontrol.c
does for its memcg handles, would make them composable and would drop the
cgroup_css() lookup.

> +
> +struct bpf_iter_blkg {
> +	__u64 __opaque[2];
> +} __aligned(8);
> +
> +struct bpf_iter_blkg_kern {
> +	struct blkcg *blkcg;
> +	struct blkcg_gq *pos;
> +} __aligned(8);
> +
> +/**
> + * bpf_iter_blkg_new - Start iterating a block cgroup's per-device blkgs
> + * @it: iterator to initialize
> + * @css: the io controller's css
> + *
> + * Each blkg holds one device's io.stat counters. Offline blkgs are skipped.
> + * A blkg without a disk can be returned. Must run under RCU.
> + *
> + * Return: 0 on success, -EINVAL if @css is not the io controller's.
> + */
> +__bpf_kfunc int bpf_iter_blkg_new(struct bpf_iter_blkg *it,
> +				  struct cgroup_subsys_state *css)
> +{
> +	struct bpf_iter_blkg_kern *kit = (void *)it;
> +
> +	BUILD_BUG_ON(sizeof(struct bpf_iter_blkg_kern) > sizeof(struct bpf_iter_blkg));
> +	BUILD_BUG_ON(__alignof__(struct bpf_iter_blkg_kern) !=
> +		     __alignof__(struct bpf_iter_blkg));
> +
> +	kit->pos = NULL;
> +
> +	if (css->ss != &io_cgrp_subsys) {
> +		kit->blkcg = NULL;
> +		return -EINVAL;
> +	}
> +
> +	kit->blkcg = css_to_blkcg(css);
> +	return 0;
> +}
> +
> +/**
> + * bpf_iter_blkg_next - Return the next online blkg of the iterated block cgroup
> + * @it: iterator
> + *
> + * Return: the next online blkg, or NULL when the walk is done.
> + */
> +__bpf_kfunc struct blkcg_gq *bpf_iter_blkg_next(struct bpf_iter_blkg *it)
> +{
> +	struct bpf_iter_blkg_kern *kit = (void *)it;
> +	struct blkcg_gq *blkg = kit->pos;
> +	struct hlist_node *node;
> +
> +	if (!kit->blkcg)
> +		return NULL;
> +
> +	if (!blkg)
> +		node = rcu_dereference(hlist_first_rcu(&kit->blkcg->blkg_list));
> +	else
> +		node = rcu_dereference(hlist_next_rcu(&blkg->blkcg_node));
> +
> +	/* Skip offline blkgs, matching io.stat. */
> +	while (node) {
> +		blkg = hlist_entry(node, struct blkcg_gq, blkcg_node);
> +		/* A race only changes whether this blkg is returned. */
> +		if (data_race(blkg->online)) {
> +			kit->pos = blkg;
> +			return blkg;
> +		}
> +		node = rcu_dereference(hlist_next_rcu(&blkg->blkcg_node));
> +	}
> +
> +	/* The iterator must keep returning NULL after completion. */
> +	kit->pos = NULL;
> +	kit->blkcg = NULL;
> +	return NULL;
> +}
> +
> +/**
> + * bpf_iter_blkg_destroy - Tear down a blkg iterator
> + * @it: iterator
> + */
> +__bpf_kfunc void bpf_iter_blkg_destroy(struct bpf_iter_blkg *it)
> +{
> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_blkcg_kfuncs)
> +BTF_ID_FLAGS(func, bpf_blkcg_flush_stats, KF_SLEEPABLE)
> +
> +BTF_ID_FLAGS(func, bpf_iter_blkg_new,
> +	     KF_ITER_NEW | KF_RCU | KF_RCU_PROTECTED)
> +BTF_ID_FLAGS(func, bpf_iter_blkg_next, KF_ITER_NEXT | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_iter_blkg_destroy, KF_ITER_DESTROY)
> +BTF_KFUNCS_END(bpf_blkcg_kfuncs)
> +
> +static const struct btf_kfunc_id_set bpf_blkcg_kfunc_set = {
> +	.owner		= THIS_MODULE,
> +	.set		= &bpf_blkcg_kfuncs,
> +};
> +
> +static int __init bpf_blkcg_init(void)
> +{
> +	int err;
> +
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
> +					&bpf_blkcg_kfunc_set);
> +	if (err)
> +		pr_warn("error while registering bpf blkcg kfuncs: %d\n", err);
> +
> +	return err;
> +}
> +late_initcall(bpf_blkcg_init);

This isn't a bug, but could a selftest under tools/testing/selftests/bpf/
be added alongside these kfuncs to lock down the RCU-protected iterator
usage? Four new kfuncs are registered for BPF_PROG_TYPE_UNSPEC (all
program types) with no accompanying selftest and no in-tree consumer, so
nothing exercises the iterator's KF_RCU_PROTECTED contract, the
offline-blkg skip, or the root-vs-non-root flush split. Comparable
additions -- mm/bpf_memcontrol.c and the bpf_iter_css family -- landed
with tests under tools/testing/selftests/bpf/, which is also what pins the
intended usage pattern (bpf_rcu_read_lock() around new/next/destroy) for
future readers.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32073368069
--===============7619779090411820820==--
