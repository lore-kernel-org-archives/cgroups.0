Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D062D47F1;
	Fri, 11 Sep 2026 08:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789113788; cv=none; b=uBw5HaGyRNoa6Gxe69Jv8eVQsk0XIUz56wLcy7ngpgv9bxzqkk3QJY4SlnLSaVkectM/gE9rx7V03tkgeylMnuSsF5f0btPX42KMQ5m8zjSCYIepbRaWH1EQOQOzSbVtGIjdM0/Bq2Os721NlEG1j2tFuXCouhbq7XTow7BrZRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789113788; c=relaxed/simple;
	bh=0tl5kcbVjbRm2L0Tkkqs6NMN6wuumQHj0DwHbJIN+3c=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=myNakSB9jMESOw8yaBOtdb40IMD9d9DcoKBb3M70//6Kw2k4nmHFiBJJfcpex7r/n54zZsR5Oww34imrIlxtEtkf2ITZHLX5YCDeTKpcBgLxuZ4zZyurKXjwNoiIi1k2vriTL7pHyRY4VS0JpkSxLyceI+dbjrnaUU5H7Z3sDGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khFdfwiX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khFdfwiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F901F000FF;
	Fri, 11 Sep 2026 08:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789113786;
	bh=jicaZQqy3uaxS0UIDSIn9mKlZV+ZLzt/G5hdYWmamoA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=khFdfwiXpHo8d2gq8HN+AUQXN7EKJTJdo+hszNQRu6abdokIoaSImSde1snkJXj5A
	 azKp1+KfEO/CXKr6nZu1ArTRIXWdfjivRUloOen++Vy+Nln1TjCkzk2lKwyoBV0EYd
	 c51R45eoreSRRbkCCgjuNffn3uTWl7p6su+RUcX3PNOwqfroQTZJVBwGVJqQ76/WpP
	 bzhxv5KYH5z1l104wnrs+Mn84Rb7rqjSZv474al5fN0ZLoaw5p1MbWR4mCtQzKFSRb
	 8YWis8eKks1OT1O+JJky53C6mwSH+pj+KWfQF580QcRYOKgm2rlhuMKlVREeDuRPMW
	 /Fe3iiih/QDsA==
Content-Type: multipart/mixed; boundary="===============0636239813871099389=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <f0031ae946427a1943ff3aa6f3484227392f10cbf6e5b6c74f3311c06ef74fc2@mail.kernel.org>
In-Reply-To: <20260910233303.1063501-3-ziyang.meme@gmail.com>
References: <20260910233303.1063501-3-ziyang.meme@gmail.com>
Subject: Re: [PATCH v5 2/4] selftests/cgroup: add memcg_stat_cross_cpu correctness test for flush
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri, 11 Sep 2026 08:03:04 +0000 (UTC)

--===============0636239813871099389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
> index 2596c12cd864..ca12d794c092 100644
> --- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
> @@ -54,6 +54,88 @@ ssize_t write_text(const char *path, char *buf, ssize_t len)
>  	return len < 0 ? -errno : len;
>  }
>
> +/**
> + * cg_get_id - return a cgroup's kernfs ID
> + * @cgroup: absolute cgroup path
> + *
> + * This is cgrp->kn->id, not st_ino.
> + *
> + * Return: ID or 0 on failure.
> + */
> +unsigned long long cg_get_id(const char *cgroup)
> +{
> +	union {
> +		unsigned long long id;
> +		unsigned char raw[8];
> +	} handle;
> +	struct file_handle *fhp, *fhp2;
> +	int mount_id, fhsize, err;
> +	unsigned long long ret = 0;
> +
> +	fhsize = sizeof(*fhp);
> +	fhp = calloc(1, fhsize);
> +	if (!fhp)
> +		return 0;
> +
> +	/* The failed probe reports the cgroupfs handle size. */
> +	err = name_to_handle_at(AT_FDCWD, cgroup, fhp, &mount_id, 0);
> +	if (err >= 0 || fhp->handle_bytes != 8)
> +		goto out;
> +
> +	fhsize = sizeof(*fhp) + fhp->handle_bytes;
> +	fhp2 = realloc(fhp, fhsize);
> +	if (!fhp2)
> +		goto out;
> +	fhp = fhp2;
> +
> +	if (name_to_handle_at(AT_FDCWD, cgroup, fhp, &mount_id, 0) < 0)
> +		goto out;
> +
> +	memcpy(handle.raw, fhp->f_handle, 8);
> +	ret = handle.id;
> +out:
> +	free(fhp);
> +	return ret;
> +}

[ ... ]

> diff --git a/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
> new file mode 100644
> index 000000000000..fff3b9256aa3
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
> @@ -0,0 +1,101 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
> +#define BPF_NO_KFUNC_PROTOTYPES
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_core_read.h>
> +#include "memcg_stat_cross_cpu.h"

A subsystem pattern flags this as potentially concerning: this new BPF
program is a narrow cross-CPU variant of a test that already exists in
tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c. The two programs
are structurally near-identical - same SEC("iter.s/cgroup") attachment,
same 'css = &cgrp->self; memcg = bpf_get_mem_cgroup(css)' prologue, the
same bpf_mem_cgroup_flush_stats() call, the same five
bpf_core_enum_value() lookups for NR_ANON_MAPPED / NR_FILE_PAGES /
NR_SHMEM / NR_FILE_MAPPED / PGFAULT fed into
bpf_mem_cgroup_page_state() and bpf_mem_cgroup_vm_events(), and the same
release. The only differences are that the new program writes a
BPF_MAP_TYPE_HASH keyed by cgroup ID instead of a global variable, and
flushes only at seq_num == 0.

Placing the variant in tools/testing/selftests/cgroup/ rather than
extending the existing test costs roughly 40 lines of new BPF build
machinery in the Makefile and a new BPF/BTF config fragment, all of
which selftests/bpf already has.

Would it make sense for the cross-CPU correctness assertions to be an
additional case in the existing cgroup_iter_memcg test instead?

> +
> +/* Sleepable iterator: flush the root once, then snapshot each cgroup. */
> +SEC("iter.s/cgroup")
> +int cgroup_memcg_stat_cross_cpu(struct bpf_iter__cgroup *ctx)
> +{
> +	struct cgroup *cgrp = ctx->cgroup;
> +	struct memcg_stat_snapshot snap = {};
> +	struct cgroup_subsys_state *css;
> +	struct mem_cgroup *memcg;
> +	int idx_anon, idx_file, idx_shmem, idx_fmapped, idx_pgfault;
> +	__u64 cg_id;
> +
> +	/* Ignore the final post-processing call. */
> +	if (!cgrp)
> +		return 0;
> +
> +	css = &cgrp->self;
> +	memcg = bpf_get_mem_cgroup(css);
> +	if (!memcg)
> +		return 0;
> +
> +	/* DESCENDANTS_PRE visits the subtree root first. */
> +	if (ctx->meta->seq_num == 0)
> +		bpf_mem_cgroup_flush_stats(memcg);

The whole test is built on the assumption that this single call
actually flushes the subtree, but bpf_mem_cgroup_flush_stats() is not a
forced flush and can be a no-op.

Looking at mm/bpf_memcontrol.c, bpf_mem_cgroup_flush_stats() calls
mem_cgroup_flush_stats(memcg), which calls
__mem_cgroup_flush_stats(memcg, false), and mm/memcontrol.c contains:

    static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
    {
            bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
            ...
            if (!force && !needs_flush)
                    return;
            ...
            css_rstat_flush(&memcg->css);
    }

with:

    static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
    {
            return atomic_long_read(&vmstats->stats_updates) >
                    MEMCG_CHARGE_BATCH * num_online_cpus();
    }

So css_rstat_flush() only runs when the subtree root has accumulated
more than MEMCG_CHARGE_BATCH (64) * num_online_cpus() pending stat
updates. The commit message states the test will "flush the subtree once
from a sleepable cgroup iterator, then compare every reported value with
memory.stat", and also says it will "Bound CPU fanout and aggregate
memory use so large systems skip cases that would exceed the limit".
Those two statements are in tension: the same bounding that keeps the
footprint small on a many-CPU machine also lowers the number of stat
updates generated relative to the num_online_cpus()-scaled threshold, so
on a large host the flush the test depends on can be skipped entirely.

This can cause two outcomes:

1. False pass. When the flush is skipped, the BPF program snapshots
whatever aggregate is already cached in memcg->vmstats. Those cached
values are self-consistent (they came from an earlier propagation), so
the 'root == sum of leaves' check and the comparison against memory.stat
can both succeed without the flush path ever having been exercised. The
test then reports PASS on a kernel whose cross-CPU aggregation is
broken, which is precisely the weakness the commit message says it
exists to fix ("The existing cgroup_iter_memcg test only checks that
selected values are non-zero").

2. False failure. The BPF snapshot and the userspace memory.stat read
happen at different times, and mm/memcontrol.c runs a periodic *forced*
flush of the whole tree every FLUSH_TIME:

       static void flush_memcg_stats_dwork(struct work_struct *w)
       {
               __mem_cgroup_flush_stats(root_mem_cgroup, true);
               queue_delayed_work(system_dfl_wq, &stats_flush_dwork, FLUSH_TIME);
       }

If the iterator's own flush was skipped (leaving per-CPU deltas
unpropagated) and the forced dwork lands between the iterator run and
the memory.stat read, memory.stat sees the newly propagated deltas that
the snapshot does not, and the exact-equality comparison fails on a
correct kernel.

Note that the kfunc's own kernel-doc ('Propagate memory cgroup's
statistics up the cgroup tree') reads as unconditional, which is likely
why the test relies on it; the implementation is conditional.

Making the comparison tolerant of a skipped flush, or generating enough
stat updates to clear MEMCG_CHARGE_BATCH * num_online_cpus() on the
largest host the test is bounded for, would close both holes.

[ ... ]

> diff --git a/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c b/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
> new file mode 100644
> index 000000000000..96e4a4a958ed
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c

[ ... ]

> +static int add_node(const char *path, bool is_leaf)
> +{
> +	struct cg_node *n = &nodes[n_nodes];
> +
> +	if (cg_create(path))
> +		return -1;
> +
> +	strncpy(n->path, path, sizeof(n->path) - 1);
> +	n->id = cg_get_id(path);

Does this code check for cg_get_id() failure? cg_get_id() is documented
and coded to return 0 on failure:

    /**
     * cg_get_id - return a cgroup's kernfs ID
     * ...
     * Return: ID or 0 on failure.
     */
    ...
    	err = name_to_handle_at(AT_FDCWD, cgroup, fhp, &mount_id, 0);
    	if (err >= 0 || fhp->handle_bytes != 8)
    		goto out;	/* ret is still 0 */

name_to_handle_at() fails with ENOSYS on a kernel built with
CONFIG_FHANDLE=n (init/Kconfig: 'bool "open by fhandle syscalls" if
EXPERT / select EXPORTFS / default y' -- it is a real, selectable
configuration, and tools/testing/selftests/cgroup/config does not list
CONFIG_FHANDLE). In that case fhp->handle_bytes stays 0 from the
calloc(), so cg_get_id() returns 0 for every node and add_node()
silently records id == 0 for all of them.

The failure only surfaces much later in read_bpf():

	for (i = 0; i < n_nodes; i++)
		if (bpf_map_lookup_elem(mfd, &nodes[i].id, &nodes[i].bpf)) {
			ksft_print_msg("no map entry for %s: %s (%d)\n", ...);

The BPF side keys the results map on BPF_CORE_READ(cgrp, kn, id), which
is never 0, so every lookup misses and run_case() returns KSFT_FAIL. A
missing kernel feature is therefore reported as 'not ok <case>' with the
misleading message 'no map entry for /sys/fs/cgroup/mcg_xcpu: No such
file or directory', instead of the skip the rest of this test is careful
to emit for absent prerequisites.

Checking the return in add_node() (return -1 when n->id == 0, which
build_tree() already propagates into the existing 'cannot build the
tree' path) makes the diagnosis immediate.

[ ... ]

> +/* Flush the subtree and collect each cgroup's kfunc values. */
> +static int read_bpf(int root_fd)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +	struct memcg_stat_cross_cpu *skel = NULL;
> +	union bpf_iter_link_info linfo = {};
> +	struct bpf_link *link = NULL;
> +	int ret = -1, err, i, mfd, fd;
> +	char buf[4096];
> +	ssize_t r;
> +
> +	skel = memcg_stat_cross_cpu__open();
> +	if (!skel) {
> +		ksft_print_msg("skel open failed: %s (%d)\n",
> +			       strerror(errno), errno);
> +		return -1;
> +	}
> +	err = bpf_program__set_autoload(skel->progs.memcg_kfuncs_probe, false);
> +	if (err) {
> +		ksft_print_msg("disabling capability probe failed: %s (%d)\n",
> +			       strerror(-err), err);
> +		goto out;
> +	}
> +	err = bpf_map__set_max_entries(skel->maps.results, n_nodes + 8);
> +	if (err) {
> +		ksft_print_msg("set max_entries failed: %s (%d)\n",
> +			       strerror(-err), err);
> +		goto out;
> +	}
> +	err = memcg_stat_cross_cpu__load(skel);
> +	if (err) {
> +		ksft_print_msg("skel load failed: %s (%d)\n",
> +			       strerror(-err), err);
> +		goto out;
> +	}

A subsystem pattern flags this as potentially concerning: read_bpf()
converts capability-absent errors into a hard test failure, while the
same errno classes are treated as a skip elsewhere in the same file.

The three BPF setup steps in read_bpf() - memcg_stat_cross_cpu__load()
above, bpf_program__attach_iter() below, and bpf_iter_create() further
down - all fall through to `goto out` with ret == -1, which run_case()
turns into KSFT_FAIL and main() into ksft_test_result_fail().

The file already has the classifier for this:

	static bool unsupported_bpf_feature_error(int err)
	{
		return err == -EINVAL || err == -ENOENT || err == -EOPNOTSUPP;
	}

and probe_memcg_bpf_features() uses it on exactly these three calls to
return 0 so that main() can ksft_exit_skip("sleepable cgroup iterator
or memcg kfuncs are not available"). read_bpf() does not consult it, so
a capability gap that the up-front probe does not model surfaces as a
regression signal rather than a skip.

The probe and read_bpf() are not identical: the probe attaches
memcg_kfuncs_probe with BPF_CGROUP_ITER_SELF_ONLY, whereas read_bpf()
attaches cgroup_memcg_stat_cross_cpu with
BPF_CGROUP_ITER_DESCENDANTS_PRE and additionally resizes
skel->maps.results to n_nodes + 8 before loading.

[ ... ]

> +/* Equal file samples require an exact BPF match; otherwise accept their range. */
> +static bool bracketed(unsigned long long v, long a, long b)
> +{
> +	long lo = a < b ? a : b;
> +	long hi = a < b ? b : a;
> +
> +	return v >= (unsigned long long)lo && v <= (unsigned long long)hi;
> +}

Michal Koutny raised a concern in v2 about using the existing
values_close() helper from cgroup_util.h instead of implementing a
custom comparison function. You acknowledged this feedback and said you
would use values_close(), but the current code still uses a custom
bracketed() function. While this function is correct and appropriate for
the new design (bracketing BPF values between two file reads), it
differs from the acknowledged reviewer suggestion. Could you clarify the
design change that led to keeping the custom function?

> +static int run_case(const struct testcase *tc)
> +{
> +	int root_fd = -1, ret = KSFT_FAIL, err, k;
> +	size_t charged;
> +
> +	if (build_tree(tc->fanout, tc->depth, &root_fd)) {
> +		ksft_print_msg("cannot build the tree\n");
> +		goto out;
> +	}
> +
> +	k = tc->cpus_per_leaf;
> +	if (k <= 0)
> +		k = n_cpu < MAX_CPUS_PER_LEAF ? n_cpu : MAX_CPUS_PER_LEAF;
> +	else if (k > n_cpu)
> +		k = n_cpu;
> +	err = leaf_charge(tc->resident_bytes, k, &charged);
> +	if (err == -E2BIG) {
> +		ksft_print_msg("%s needs more than %luMB to trigger a flush on %ld online CPUs\n",
> +			       tc->name, MAX_TOTAL_CHARGE >> 20, n_online_cpu);
> +		ret = KSFT_SKIP;
> +		goto out;
> +	}
> +	if (err) {
> +		ksft_print_msg("cannot calculate the charge for %s: %s (%d)\n",
> +			       tc->name, strerror(-err), err);
> +		goto out;
> +	}
> +
> +	ksft_print_msg("%s: %d cgroups, %d leaves, %d/%d cpus, %zuKB per leaf\n",
> +		       tc->name, n_nodes, n_leaves, k, n_cpu, charged >> 10);
> +
> +	if (start_chargers(k, charged))
> +		goto out;
> +
> +	/* Read BPF first; memory.stat would consume the pending flush. */
> +	if (read_bpf(root_fd) || read_files(0) || read_files(1))
> +		goto out;

Can the ordering here actually bracket the BPF value? Both cgroupfs
samples are taken after the BPF sample, so they cannot bracket it and
the second sample adds no tolerance where tolerance is needed.

Ordering is fixed: read_bpf() first, then read_files(0), then
read_files(1). check_tree() then asks:

	if (!bracketed(b->anon, f0->anon, f1->anon) || ... ||
	    !bracketed(b->pgfault, f0->pgfault, f1->pgfault)) {

and bracketed() accepts v only inside [min(a,b), max(a,b)]:

	long lo = a < b ? a : b;
	long hi = a < b ? b : a;
	return v >= (unsigned long long)lo && v <= (unsigned long long)hi;

Because the BPF value was sampled strictly before f0, the interval
[f0,f1] only tolerates drift that begins after f0 was read. Any change
during the read_bpf()->read_files(0) window pushes both f0 and f1 to
the same side of the BPF value and the comparison fails even though the
kfunc returned the correct value at the time it was taken.

For a monotonically increasing counter the requirement collapses to
exact equality: pgfault only ever grows, so f0->pgfault >= b->pgfault
always, and the check can only pass when b->pgfault == f0->pgfault.

The exposed window is not small and grows with the tree. read_files(0)
issues six file reads per cgroup (five cg_read_key_long() reads of
memory.stat plus one memory.current), so for the deepest case (fanout 4,
depth 3 => 85 cgroups) the last node's f0 is read after roughly 500
cgroupfs reads, all of which sit inside the untolerated interval for
that node.

What mostly hides this today is that memory.stat's flush is threshold
gated (memcg_vmstats_needs_flush() requires more than MEMCG_CHARGE_BATCH
* num_online_cpus() pending updates), so after the BPF flush the
following memory.stat reads usually return the identical already-flushed
values. That makes the comparison an equality check in practice, which
is what the comment admits ("Equal file samples require an exact BPF
match"), but it also means the two-sample scheme provides no protection
against the one interval it was added for.

Sampling memory.stat once before read_bpf() and once after would
genuinely bracket the BPF value; alternatively drop the second sample
and document that the check is an equality check.

The file header comment ("then require two file samples to bracket each
BPF value") and the changelog ("then compare every reported value with
memory.stat") describe a tolerance the code does not provide.

[ ... ]

> +static bool unsupported_bpf_feature_error(int err)
> +{
> +	return err == -EINVAL || err == -ENOENT || err == -EOPNOTSUPP;
> +}
> +
> +/* Return 1 if supported, 0 if unavailable, or a negative error. */
> +static int probe_memcg_bpf_features(int root_fd)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +	struct memcg_stat_cross_cpu *skel;
> +	union bpf_iter_link_info linfo = {};
> +	struct bpf_link *link = NULL;
> +	int ret, err, iter_fd = -1;
> +
> +	skel = memcg_stat_cross_cpu__open();
> +	if (!skel) {
> +		err = errno ? -errno : -EINVAL;
> +		ksft_print_msg("capability probe open failed: %s (%d)\n",
> +			       strerror(-err), err);
> +		return err;
> +	}
> +
> +	err = bpf_program__set_autoload(skel->progs.cgroup_memcg_stat_cross_cpu,
> +					false);
> +	if (err) {
> +		ksft_print_msg("disabling test program failed: %s (%d)\n",
> +			       strerror(-err), err);
> +		ret = err;
> +		goto out;
> +	}
> +
> +	err = memcg_stat_cross_cpu__load(skel);
> +	if (err) {
> +		ksft_print_msg("BPF capability probe load failed: %s (%d)\n",
> +			       strerror(-err), err);
> +		ret = unsupported_bpf_feature_error(err) ? 0 : err;

Does the capability-absent error set need to include -EPERM and -EACCES?
The classifier omits them, so running the new test without CAP_BPF turns
an environment difference into a hard TAP failure instead of a skip.

Path: main() -> probe_memcg_bpf_features() ->
memcg_stat_cross_cpu__load() -> bpf_object__load() ->
bpf_object__probe_loading() (tools/lib/bpf/libbpf.c), which does a
trivial bpf_prog_load() and returns -errno. Without CAP_BPF (or with
kernel.unprivileged_bpf_disabled set, the default on most distros) that
is -EPERM; loading the iter.s/cgroup program itself additionally needs
CAP_BPF+CAP_PERFMON. -EPERM is not in the set above, so:

    err = memcg_stat_cross_cpu__load(skel);        /* -EPERM */
    ret = unsupported_bpf_feature_error(err) ? 0 : err;   /* -> -EPERM */

and main() does:

    if (ret < 0)
        ksft_exit_fail_msg("cannot probe BPF capabilities: %s (%d)\n", ...);

so the binary reports 'not ok' / exits KSFT_FAIL rather than skipping.
Nothing earlier in main() gates on privilege: memcg_kfuncs_available()
only reads /sys/kernel/btf/vmlinux (world readable),
cg_find_unified_root() reads /proc/mounts, and open(root,
O_RDONLY|O_DIRECTORY) on /sys/fs/cgroup succeeds for any user.

Note that -EPERM from bpf() is unambiguous - it is a capability/sysctl
gate, never a verifier verdict (the verifier returns -EACCES/-EINVAL) -
so adding -EPERM (and -ENOSYS, for a kernel without the bpf syscall) to
the skip set does not weaken the test.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34573210499
--===============0636239813871099389==--
