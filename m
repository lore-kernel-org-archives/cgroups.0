Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1675A490BE3;
	Fri, 14 Aug 2026 17:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786728074; cv=none; b=bX87uBwNsadNmZ0bp5F06jW5QnIKokHrbUb08JEHqE9gXWxM+VQ+sh790CmfGoxiZDVATq8W8R49dNYocO3XMKoU7wvvBvHO+cEcc8HL7sX6CRGvM4/Q2jBtszwvsZRsEoHKbuXczSuFNgRoDEiUlmbDEqIBHpnL+1rbO9SmtmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786728074; c=relaxed/simple;
	bh=vMpgoOz+p2ujp7Er4C/MiQeSNTJxo4gZojuIIbKJndk=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=sviiRB95cqlPD3n7BP4sniXuMQn1LIyYmNeBorvOKRA3usDEeTLusBkW+xBzD7QHMon0wdqaCeU01x7kGYp9aflvgHnTIFhKf4LMDH30a3QGz8EUb5zUqrs2cP3/j1wWmaLyjDnK6PJ6zocIrAB7wbmhRCtHU1QycFSt7cGmZM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gtgY7SnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gtgY7SnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756A61F00A3A;
	Fri, 14 Aug 2026 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786728073;
	bh=BRL/PSO1BC0vvlDljyLXfI9OVmFFb4IneOZPFgBEPj8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=gtgY7SnUZh0xl3EBMF0kIXyX21CWe9oYi8qA4wg9vGLe21bsaqy7Dy98bmfH4z/TF
	 G2S0FzURzQsIovd6I5gLbqZbHuw9V3P8+6og2bofp5MTNeJz6k1Sp+vGTL9SX4e/OJ
	 wrx8J00UBCamLm+toy8zCmMG0OMWZrBB9+o+NgdAtGndUqxXY6Q7wjwob9n5kxf7AK
	 3IEdsN3PDJlfGHXQEk7M/qFDaRwW9KHEn2A8/CN59GNaHRb3VarIzswPmDvqEZ0A6r
	 4qLoSAYiGF8TJXaQzNjrEov+EUlZALlqOCZ5yIkCGRn5+W6O5SKe58KL7eZ69eNqs6
	 wvZ4f7KlVgsIg==
Content-Type: multipart/mixed; boundary="===============7566751797017694167=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <cb7504a8500fe771ca5abeb9eeedb194e4cf5d4859a031caa27e2ddeeba6964c@mail.kernel.org>
In-Reply-To: <20260814075054.507089-3-ziyang.meme@gmail.com>
References: <20260814075054.507089-3-ziyang.meme@gmail.com>
Subject: Re: [PATCH v3 2/4] selftests/cgroup: add memcg_stat_cross_cpu correctness test for flush
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 14 Aug 2026 17:21:11 +0000 (UTC)

--===============7566751797017694167==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
> index 39f979690dd3..356b6a533d88 100644
> --- a/tools/testing/selftests/cgroup/config
> +++ b/tools/testing/selftests/cgroup/config
> @@ -4,3 +4,8 @@ CONFIG_CGROUP_FREEZER=y
>  CONFIG_CGROUP_SCHED=y
>  CONFIG_MEMCG=y
>  CONFIG_PAGE_COUNTER=y
> +CONFIG_BPF=y
> +CONFIG_BPF_SYSCALL=y
> +CONFIG_DEBUG_INFO=y
> +CONFIG_DEBUG_INFO_BTF=y
> +CONFIG_DEBUG_INFO_DWARF4=y

A subsystem pattern flags this as potentially concerning: CONFIG_BPF_EVENTS=y
is missing. The new program is SEC("iter.s/cgroup"), which is
BPF_PROG_TYPE_TRACING, and that program type is only registered inside
'#ifdef CONFIG_BPF_EVENTS' in include/linux/bpf_types.h:38. Without it
find_prog_type() returns -EINVAL and the skeleton load fails at runtime
even though the build succeeded.

CONFIG_BPF_EVENTS is 'default y' but has 'depends on (KPROBE_EVENTS ||
UPROBE_EVENTS) && PERF_EVENTS' (kernel/trace/Kconfig:853), so a kselftest
kernel configured only from the merged fragments can easily end up without
it. tools/testing/selftests/bpf/config:5 sets CONFIG_BPF_EVENTS=y
explicitly for exactly this reason.

Note also that CONFIG_DEBUG_INFO is not promptable (it is selected by the
DEBUG_INFO_* choice), so that line is a no-op.

> diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
> index e01584c2189a..01927511c059 100644
> --- a/tools/testing/selftests/cgroup/Makefile
> +++ b/tools/testing/selftests/cgroup/Makefile

[ ... ]

> @@ -33,3 +75,13 @@ $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
>  $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
>  $(OUTPUT)/test_pids: $(LIBCGROUP_O)
>  $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
> +
> +ifneq ($(HAVE_BPF),)
> +# Links cgroup_util and the skeleton against the libbpf lib.bpf.mk built.  The
> +# uapi include is private to this binary: the other tests here must keep
> +# resolving <linux/*.h> against the system headers.
> +$(OUTPUT)/test_memcg_stat_cross_cpu: private CFLAGS += -I$(top_srcdir)/tools/include/uapi
> +$(OUTPUT)/test_memcg_stat_cross_cpu: test_memcg_stat_cross_cpu.c \
> +					$(BPF_SKELS) $(LIBCGROUP_O) $(BPFOBJ)
> +	$(call bpf_link,$@,$< $(LIBCGROUP_O))
> +endif

A subsystem pattern flags this as potentially concerning:
memcg_stat_cross_cpu.h is not listed as a prerequisite of the userspace
binary, and BPF_EXTRA_HDRS (documented by the new
tools/testing/selftests/lib.bpf.mk as 'more headers needed by the BPF
objects') is left unset, so the BPF object does not depend on it either.

That header defines struct memcg_stat_snapshot, which is the wire format
shared between the BPF program and the test binary. Editing it therefore
rebuilds neither side, and an incremental build can silently produce a
binary whose struct layout disagrees with the loaded skeleton.

The sibling conversion commit ef5ceab9d440 (selftests/hid) does set
BPF_EXTRA_HDRS for its shared header, so the mechanism was available.
LOCAL_HDRS would cover the C side.

> diff --git a/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
> new file mode 100644
> index 000000000000..3c2acd49c16b
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c

[ ... ]

> +/*
> + * Flush once at the subtree root, then read each cgroup through the kfuncs.
> + * iter.s because the flush kfunc may sleep.
> + */
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
> +	/* The walk ends with a NULL element; return 0 so it runs to the end. */
> +	if (!cgrp)
> +		return 0;

A subsystem pattern flags this as potentially concerning: the comment
misstates the mechanism and will mislead the next reader. The NULL element
is the epilogue: cgroup_iter_seq_stop() invokes
__cgroup_iter_seq_show(seq, NULL, true) only after cgroup_unlock() and
only once the walk has already finished, and it sets p->visited_all = true
immediately afterwards.

__cgroup_iter_seq_show() converts a non-zero return into p->terminate =
true, but nothing reads p->terminate after that point, so returning 0
rather than non-zero for the NULL element has no effect on how far the
walk gets. The pre-existing comparable program
tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c returns 1 for the
NULL element. The code is functionally correct; only the stated rationale
is wrong.

> diff --git a/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c b/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
> new file mode 100644
> index 000000000000..9946c41c7a90
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c

[ ... ]

> +static size_t leaf_charge(size_t want, int k)
> +{
> +	long online = sysconf(_SC_NPROCESSORS_ONLN);
> +	size_t floor;
> +
> +	floor = (size_t)FLUSH_MARGIN * MEMCG_CHARGE_BATCH * online *
> +		page_size / n_leaves;
> +	if (want < floor)
> +		want = floor;
> +	if (want < (size_t)k * page_size)
> +		want = (size_t)k * page_size;
> +
> +	return (want + page_size - 1) / page_size * page_size;
> +}

Does this handle the sysconf(_SC_NPROCESSORS_ONLN) failure case correctly?
The return value is not checked, and the expression it feeds is unsigned.
Because of the leading (size_t) cast, online is converted to size_t, so a
-1 return makes floor ~= (2^64 - 1048576)/n_leaves instead of a small byte
count.

want is then clamped up to that value and returned, and start_chargers()
passes it to charge_leaf(), where malloc(ca->bytes) fails, the charger
exits, and the test reports the misleading "%s never reached its charge"
failure. The same file already guards the analogous call: main() does
'page_size = sysconf(_SC_PAGESIZE); if (page_size <= 0) page_size =
BUF_SIZE;' (lines 947-949), and this is the only unchecked sysconf() in
the whole cgroup selftest directory.

> +static int start_chargers(int k, size_t bytes)
> +{
> +	struct charge_args ca = { .bytes = bytes, .k = k };
> +	long prev, cur;
> +	int i, retries;
> +
> +	for (i = 0; i < n_nodes; i++) {
> +		if (!nodes[i].is_leaf)
> +			continue;
> +		if (cg_run_nowait(nodes[i].path, charge_leaf, &ca) < 0) {
> +			ksft_print_msg("cannot start a charger on %s\n",
> +				       nodes[i].path);
> +			return -1;
> +		}
> +		ca.base += k;
> +	}

Can the per-leaf charge sizing in leaf_charge() cause memory pressure? The
per-leaf charge is raised to at least k * page_size, and run_case() sets k
= n_cpu for the 'cross_cpu' cases, so the total anon the test pins is
n_leaves * n_cpu * page_size with no ceiling. For the two large-tree cases
(fanout 10, depth 3) n_leaves is 1000, which is 1000 * n_cpu * 4K: 256 MB
on a 64-CPU host, 1 GB at 256 CPUs, 4 GB at 1024 CPUs, held simultaneously
by 1000 live processes.

The file's own header comment states the requirement this violates: "The
comparison is exact, which needs the subtree quiesced ... Global reclaim
would move the numbers and the test would report a mismatch", and
check_tree() runs with STAT_TOLERANCE_PCT 0, so any reclaim during the run
turns into a hard KSFT_FAIL rather than a skip. Nothing in the test
compares the computed footprint against MemAvailable or caps it.

The same sizing also feeds the charge-completion deadline in
start_chargers(): CHARGE_WAIT_RETRIES (100) * DEFAULT_WAIT_INTERVAL_US/10
(10 ms) gives each leaf only ~1 s to both reach bytes and read the same
memory.current twice in a row, while up to 1000 chargers are concurrently
performing k sched_setaffinity() migrations each.

> +	for (i = 0; i < n_nodes; i++) {
> +		if (!nodes[i].is_leaf)
> +			continue;
> +		/*
> +		 * Wait for the charge to both cover the region and stop
> +		 * moving.
> +		 */
> +		prev = -1;
> +		for (retries = CHARGE_WAIT_RETRIES; retries; retries--) {
> +			cur = cg_read_long(nodes[i].path, "memory.current");
> +			if (cur >= (long)bytes && cur == prev)
> +				break;
> +			prev = cur;
> +			usleep(DEFAULT_WAIT_INTERVAL_US / 10);
> +		}
> +		if (!retries) {
> +			ksft_print_msg("%s never reached its charge\n",
> +				       nodes[i].path);
> +			return -1;
> +		}
> +	}
> +	return 0;
> +}

A subsystem pattern flags this as potentially concerning: start_chargers()
open-codes a retry/poll loop over a cgroup control file instead of using
(or extending) the cgroup selftest library's polling helpers.

lib/include/cgroup_util.h already exports cg_read_key_long_poll(cgroup,
control, key, expected, retries, wait_interval_us),
cg_wait_for()/cg_prepare_for_wait() and cg_wait_for_proc_count(), and this
loop also silently treats cg_read_long()'s -1 error return as "not charged
yet" and burns a retry on it, which the shared helper does not do (it
returns the error).

The existing helper is not a drop-in substitute: cg_read_key_long_poll()
polls a memory.stat key for exact equality against expected and returns on
the first read error, whereas this loop needs 'memory.current >= bytes AND
unchanged across two reads' on a different file. So the semantics genuinely
differ and a bespoke loop is defensible; the guide's underlying point still
applies in that this series already extends the shared library
(cg_get_id/cg_touch_pages/cg_alloc_anon), so a 'wait until >= X and stable'
helper could live there too and pick up the missing error handling for
free.

> +/*
> + * Collect what the kfuncs report.  The program flushes at the first cgroup it
> + * sees, the subtree root in DESCENDANTS_PRE order.
> + */
> +static int read_bpf(int root_fd)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +	struct memcg_stat_cross_cpu *skel = NULL;
> +	union bpf_iter_link_info linfo = {};
> +	struct bpf_link *link = NULL;
> +	int ret = -1, i, mfd, fd;
> +	char buf[4096];
> +	ssize_t r;
> +
> +	skel = memcg_stat_cross_cpu__open();
> +	if (!skel) {
> +		ksft_print_msg("skel open failed\n");
> +		return -1;
> +	}
> +	if (bpf_map__set_max_entries(skel->maps.results, n_nodes + 8)) {
> +		ksft_print_msg("set max_entries failed\n");
> +		goto out;
> +	}
> +	if (memcg_stat_cross_cpu__load(skel)) {
> +		ksft_print_msg("skel load failed\n");
> +		goto out;
> +	}
> +
> +	linfo.cgroup.cgroup_fd = root_fd;
> +	linfo.cgroup.order = BPF_CGROUP_ITER_DESCENDANTS_PRE;
> +	opts.link_info = &linfo;
> +	opts.link_info_len = sizeof(linfo);
> +
> +	link = bpf_program__attach_iter(skel->progs.cgroup_memcg_stat_cross_cpu,
> +					&opts);
> +	if (!link) {
> +		ksft_print_msg("attach iter failed\n");
> +		goto out;
> +	}
> +
> +	fd = bpf_iter_create(bpf_link__fd(link));
> +	if (fd < 0) {
> +		ksft_print_msg("bpf_iter_create failed\n");
> +		goto out;
> +	}
> +	while ((r = read(fd, buf, sizeof(buf))) > 0)
> +		;
> +	close(fd);
> +	if (r) {
> +		ksft_print_msg("bpf walk failed\n");
> +		goto out;
> +	}

A subsystem pattern flags this as potentially concerning: every BPF
capability shortfall in read_bpf() is reported as a test FAILURE rather
than a SKIP.

The feature gate is narrow. memcg_kfuncs_available() (line 907) probes
exactly one symbol:

  ok = btf__find_by_name_kind(btf, "bpf_get_mem_cgroup", BTF_KIND_FUNC) > 0;

but memcg_stat_cross_cpu.bpf.c additionally requires bpf_put_mem_cgroup,
bpf_mem_cgroup_flush_stats, bpf_mem_cgroup_page_state and
bpf_mem_cgroup_vm_events, plus kernel support for a sleepable cgroup
iterator (SEC("iter.s/cgroup")). On a kernel that exports
bpf_get_mem_cgroup but not the rest of the set (a partial backport, or a
future kernel that renames/retires one of them),
memcg_stat_cross_cpu__load() fails with a capability-absent errno (-ENOENT
for an unresolvable __ksym kfunc, -EOPNOTSUPP/-EINVAL for an unsupported
sleepable iter). The same applies to bpf_program__attach_iter() and
bpf_iter_create(), which also fail with -EOPNOTSUPP/-EPERM when the
capability or privilege is absent.

All three paths take 'goto out' and return -1. run_case() initialises 'ret
= KSFT_FAIL' and only ever upgrades it to KSFT_PASS, so it has no
KSFT_SKIP or ksft_test_result_skip() path at all. The result is a hard
"not ok" in the TAP output for a machine that simply lacks the
prerequisite. The diagnostics also make this indistinguishable from a
genuine failure: none of the four messages ("skel load failed", "attach
iter failed", "bpf_iter_create failed", "bpf walk failed") carry errno or
strerror(errno), so a CI operator cannot tell a missing-capability
environment from a real flush regression.

> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index 0ebf796f3cff..15ba46879504 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31820214629
--===============7566751797017694167==--
