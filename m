Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FD53E9F9D
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 09:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784713440; cv=none; b=ft0VXhoj3sEXqrdBlp9kdsXwSnzUZVRPYMdyP970eqj5/Iyt08ifSh5/E5F4fV1hVldjrP2csqZFYdPvry5ytPLUHCaE8xrLw7vV+8Kb44ebxJtqh7yeBPDqaTu5cEKVaqbEaZukatJtIgrweBhxiRLyiX8C10kSAbAk0uCSGFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784713440; c=relaxed/simple;
	bh=5zT1F/18SKmDcDLHECwvG+epTfeUkMU2/51GLqV8MvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvADq4GS+iA4eoFRj5VKqcW9yMOkwwkWYGuSl1mFiJNuloXm5OSW6SbRT9M7+Px/wrCi0vnydd330ZhPqG9ObppUpHR7IYYjZy8YOifgy7bHQGWlKgDMNR/d8Dn1cqpOEo7HLruOusYeQGkbXRAeJwcX3WVtAVPtK9i4RUcArsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Lz3epi88; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Lz3epi88"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-472326ca506so9458089f8f.2
        for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 02:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784713432; x=1785318232; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fsxdo4WU+Ra3Ii3+AJeiKBXkT5u+K5Jpj+4piFHrP8Q=;
        b=Lz3epi88SvQIgTK0fS/2y4VEeef124KIlbi0y5hreOG7Q+qodwNSghZdOuebBxgNZZ
         0Dce5Y5FsIsL7tj/GRthR8TvoHWjD+6eZwe2rXAddv5U/vlGhb2vXJA+YC/fju8jx1wB
         +OI6xMuVYQT6/rt4cXE1nQpO/4KYJJlAupHhUyqem15f2xiCVQ4XMJmRQgJp5ql8bcsz
         zdDHCnUkLg96X42HNev6NCRq8i2CbZX7Ys7/omg/AW2Sextr8dMwodnpy0oZBeUfLNlA
         NF8CZPQ1GN+E3xArl8/QNHjeSLp3ihSTa5l3bvZCBteFz0rxbGxuSNhDNmFxcR2iR4PQ
         q56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784713432; x=1785318232;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fsxdo4WU+Ra3Ii3+AJeiKBXkT5u+K5Jpj+4piFHrP8Q=;
        b=BbJPLJUwrw3f7kZVh2ORi7Ef0t2a6LTKYKiQS7UdEhdnF6wJBf8bla5pVYHDCTLLa8
         Zx1bji+YF0iJkV9eFHzMCzN0CrcRIAa5p0gZCCYUvWHfi1hfHqu1D52VAkZBX/OVQm59
         Y0L6jCUadpqNsO06V8IVRfq6ymWiaru09TakMq4HzQZuiwVQnaOFharf6LskdVATs6SX
         7YyAij7q6AkIv/V/fOEml4PScRW4sPmFMmZbtJNJriwiaa42YNif99xip6bZ/7eDMl/V
         DVq5l6EamI/GmTjZz5DvZl5OoTcqVL3skUomI8cOMO6zqc5zaETMEX1GAuCEbyS4w+iT
         FmOQ==
X-Forwarded-Encrypted: i=1; AHgh+RqNsxkZQwdC2i1g8xLV8vja2ISztCD1FVxmiosZjBG2pujryKP+PYwpvLtlMu1pczZDKT79eT7s@vger.kernel.org
X-Gm-Message-State: AOJu0YylvWGmcpCgMYdVpUZX7n8p7cLogTDL1GM9YvpcekFJd4hGCEoG
	GfhhBg9i0fSskcpYQ/cpr27aY/jRVigClGaa9LEL06FRzETprMY49xq13eV1O/qfuHk=
X-Gm-Gg: AR+sD10kaVRI7ChxnPRfndMpPVyz3oNboGzKuRZNxbObRdJjtCJHsLh6uWmjL26pNhQ
	f761vvRoIobUPTFaXowc4YlWy9qOCpMpivPUQCmjyHnidVKHlCHDuE0mVmkxcq3nRfwuR1CkAiR
	r/AgE6K+z11RKkFffzun3lYq2vJc6gQZft0No5luG5Fi5UVuCzdVhzpcnDXc31k480BRx56U1YJ
	dQxOMqWik57VNmQ9HKe1l1oaa1SA39kvbCMjyxmEGE12BhcjRMdcxKOpcMiy+JIGDhWHp7OOB2n
	PqdBCqm32To8MDyalMeyN5MKzDmRChUz2p6vrWl6muJlo2ZxeRRPRu4sfB89EOzIC2CgmJxat9K
	Q3gspVbypNoB8GeO83TLdkqJKqdwdgkvGYL4Qh6lwAM56jvUnhhkC7jzRPGZcNZI9RKokQxcm7F
	NpbCjJTg==
X-Received: by 2002:a05:6000:1acc:b0:47f:8309:8bac with SMTP id ffacd0b85a97d-47f83098c0amr6502172f8f.3.1784713432186;
        Wed, 22 Jul 2026 02:43:52 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bdac28sm4439266f8f.16.2026.07.22.02.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 02:43:51 -0700 (PDT)
Date: Wed, 22 Jul 2026 11:43:49 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, David Vernet <void@manifault.com>, 
	Eduard Zingerman <eddyz87@gmail.com>, Andrea Righi <arighi@nvidia.com>, 
	Changwoo Min <changwoo@igalia.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	JP Kobryn <inwardvessel@gmail.com>, Mykola Lysenko <mykolal@meta.com>, 
	Nathan Chancellor <nathan@kernel.org>, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-input@vger.kernel.org, sched-ext@lists.linux.dev, linux-mm@kvack.org, 
	kernel-team@meta.com, bpf@vger.kernel.org, llvm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] selftests/cgroup: add memcg_stat_cross_cpu
 correctness test for flush
Message-ID: <amCBeD8sGVdi1Nm4@localhost.localdomain>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-3-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ag6sewjdvm6sdw3b"
Content-Disposition: inline
In-Reply-To: <20260721174833.1232771-3-ziyang.meme@gmail.com>


--ag6sewjdvm6sdw3b
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 2/4] selftests/cgroup: add memcg_stat_cross_cpu
 correctness test for flush
MIME-Version: 1.0

Hello Ziyang.

On Tue, Jul 21, 2026 at 10:48:31AM -0700, Ziyang Men <ziyang.meme@gmail.com=
> wrote:
> Add a test_progs selftest that verifies the memory-cgroup BPF kfuncs
> return values that agree with what userspace reads from cgroupfs, across
> a whole cgroup subtree that has been charged on many CPUs.
>=20
> It complements the existing cgroup_iter_memcg test.  cgroup_iter_memcg
> calls the memcg kfuncs on a single cgroup (BPF_CGROUP_ITER_SELF_ONLY) and
> only asserts each value is greater than zero, so it never checks that a
> value is actually correct.  This test compares the kfunc values against
> what userspace reads from memory.stat, and checks every node in the
> cgroup tree.
>=20
> Moreover, cgroup_iter_memcg does not exercise the rstat flush
> (mem_cgroup_flush_stats()).  This test does: it launches a process on
> each leaf that charges and holds memory across multiple CPUs (so the
> leaf's rstat is dirty on K per-cpu trees), then confirms the flush works
> for both the BPF and the file path by checking two properties:
>=20
>   1. after the flush, each leaf's anon is at least what the process
>      charged there;
>=20
>   2. after the flush, the sum of the leaves' charged memory equals the
>      amount at the root.
>=20
> The BPF reader and the file reader run in two separate rounds.  Each
> round builds the same cgroup tree from scratch and charges the same
> amount of memory, so both rounds start from the same state and the
> numbers are comparable.  In detail:
>=20
>   - round 1 (BPF) builds the subtree, forks one child per leaf that
>     charges the leaf across K CPUs and then blocks holding the charge,
>     walks the tree with a SEC("iter.s/cgroup") program that flushes the
>     subtree at the root and reads each cgroup via the memcg kfuncs
>     (bpf_get_mem_cgroup, bpf_mem_cgroup_flush_stats,
>     bpf_mem_cgroup_page_state, bpf_mem_cgroup_vm_events,
>     bpf_put_mem_cgroup) into a hash map;
>=20
>   - round 2 (cgroupfs) builds and charges an identical tree the same way,
>     then reads every cgroup's memory.stat / memory.current from
>     userspace.
>=20
> The subtests differ in how many CPUs each leaf is charged on (a single
> CPU or across K CPUs), and run on two cgroup tree sizes.  The charging
> children pin CPUs and there is one per leaf, so the test is registered
> serial.
>=20
> The traditional path reads memory.stat / memory.current through a new
> read_cgroup_file() helper added to cgroup_helpers (the read counterpart
> of write_cgroup_file).  When the memcg kfuncs are unavailable
> (CONFIG_MEMCG=3Dn) the test skips cleanly; the base selftest config now
> selects CONFIG_MEMCG=3Dy.
>=20
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>

On one hand, this migth be useful to ensure somewhat stable behavior of
the reported stats, OTOH, it's exposing quite some implementation
details (flushing, per-cpu charging).
I'd say that flushing for BPF progs should work (which is what
cgroup_iter_memcg() should test IIUC) and yield some precision effect,
however, the comparison with memory.stat may be source of false
positives due to noise.
Also, this is supposed to measure convergence in some "static" situation
but in reality the things are moving (memcg charges/uncharges) in
various pace so some differences would still occur (IMO such deviations
are OK, perhaps the test should spell out its preconditions and limitations=
).

As for the implementation in general -- it'd need some tighter
connection with existing cgroup selftests (e.g. use integer types like
cgroup selftest, utilization/adaptation of existing helpers to reduce
copies of same/similar code).


> --- a/tools/testing/selftests/cgroup/Makefile
> +++ b/tools/testing/selftests/cgroup/Makefile
> @@ -14,14 +14,29 @@ TEST_GEN_PROGS +=3D test_freezer
>  TEST_GEN_PROGS +=3D test_hugetlb_memcg
>  TEST_GEN_PROGS +=3D test_kill
>  TEST_GEN_PROGS +=3D test_kmem
> +TEST_GEN_PROGS +=3D test_memcg_stat_cross_cpu
>  TEST_GEN_PROGS +=3D test_memcontrol

Yeah, this is perhaps so much different from test_memcontrol that it
deserves a separate prog, OTOH it'd be good to share some common
cg/memcg functions across the two (some notes below).


> +unsigned long long cg_get_id(const char *cgroup)

This duplicates get_cgroup_id_from_path() from
tools/testing/selftests/bpf/cgroup_helpers.c

> +/* ---- allowed CPU set ------------------------------------------------=
--- */
> +
> +static int *cpu_list; /* ids of the CPUs this process may run on */

I think it'd be simpler to just use cpu_set_t and the standard helper
macros/functions for this.

> +/* Recursively create children of @path. @path must already exist and be=
 recorded. */
> +static int build_children(const char *path, int fanout, int depth)
> +{
> +	char child[PATH_MAX];
> +	int i;
> +
> +	if (depth =3D=3D 0)
> +		return 0;
> +
> +	/* Enable memory on this interior node so its children get a memcg. */
> +	if (cg_write(path, "cgroup.subtree_control", "+memory"))
> +		return -1;
> +
> +	for (i =3D 0; i < fanout; i++) {
> +		snprintf(child, sizeof(child), "%s/c%d", path, i);
> +		if (add_node(child, depth =3D=3D 1, NULL))
> +			return -1;

is_leaf :=3D depth =3D=3D 1
doesn't look correct (I see below the test builds hierarchies with
depth=A0>=A01)
Ah, it's non-conventional meaning of "leaf", I'd suggest a subtree or
partition or similar (IIUC the purpose).


> +		if (build_children(child, fanout, depth - 1))
> +			return -1;
> +	}
> +	return 0;
> +}
> +
> +static size_t tree_capacity(int fanout, int depth)
> +{
> +	size_t total =3D 1, level =3D 1;
> +	int d;
> +
> +	for (d =3D 0; d < depth; d++) {
> +		level *=3D fanout;
> +		total +=3D level;
> +	}
> +	return total;
> +}
> +
> +/* The tree is arranged in the DFS order within an array */
> +static int build_tree(int fanout, int depth, int *root_fd)
> +{
> +	n_nodes =3D 0;
> +	n_leaves =3D 0;
> +	nodes =3D calloc(tree_capacity(fanout, depth), sizeof(*nodes));
> +	if (!nodes)
> +		return -1;
> +
> +	if (add_node(subtree_root, depth =3D=3D 0, root_fd))
> +		return -1;
> +	return build_children(subtree_root, fanout, depth);
> +}
> +
> +/* ---- cross-CPU charge (one pinning child per leaf) ------------------=
--- */
> +
> +static pid_t *charger_pids;
> +static int n_chargers;
> +/* parent pid, for the children's PR_SET_PDEATHSIG race check */
> +static pid_t test_pid;
> +static int charge_ready[2] =3D { -1, -1 };	/* child -> parent "ready" ba=
rrier */
> +static int charge_ctrl[2] =3D { -1, -1 };	/* parent -> child "exit" (clo=
se to signal) */
> +
> +/*
> + * One charging child, dedicated to a single leaf and spread over K CPUs=
=2E  It
> + * joins its leaf, maps a resident anon region, then faults the region i=
n K
> + * slices, each on a different CPU, so this leaf's rstat ends up dirty o=
n K
> + * per-cpu trees.  The region stays mapped, so the charge persists while=
 the
> + * parent reads.  After signalling readiness the child blocks (holding t=
he
> + * charge) until the parent closes the control pipe.  Never returns.
> + *
> + * @base is this child's starting index into cpu_list; its K CPUs are
> + * (base + 0..K-1) mod n_cpu.
> + */
> +static void charger_child(const struct cg_node *leaf, int base, int k,
> +			  size_t resident_bytes)
> +{

It'd be nicer if this shared alloc_* functions from test_memcontrol.c
(module adjustoment to cater both users).

> +static int file_read_node(const char *path, struct file_snap *o)
> +{
> +	char buf[8192];
> +
> +	memset(o, 0, sizeof(*o));
> +
> +	if (cg_read(path, "memory.stat", buf, sizeof(buf)))
> +		return -1;
> +	parse_stat(buf, o);

We have cg_read_key_long() for such extractions.

> +
> +/* ---- correctness comparison -----------------------------------------=
--- */
> +
> +static bool close_enough(__u64 a, __u64 b, __u64 tol)
> +{
> +	return (a > b ? a - b : b - a) <=3D tol;
> +}

See
tools/testing/selftests/cgroup/lib/include/cgroup_util.h:values_close()


> +
> +/* Dump one node's bpf-vs-file stats; called when a mismatch is detected=
=2E */
> +static void dump_node(int i, const struct memcg_stat_snapshot *b,
> +		      const struct file_snap *f)
> +{
> +	ksft_print_msg("node %d bpf : anon=3D%llu file=3D%llu shmem=3D%llu fmap=
ped=3D%llu pgfault=3D%llu\n",
> +		       i, b->anon, b->file, b->shmem, b->file_mapped, b->pgfault);
> +	ksft_print_msg("node %d file: anon=3D%llu file=3D%llu shmem=3D%llu fmap=
ped=3D%llu pgfault=3D%llu\n",
> +		       i, f->anon, f->file, f->shmem, f->file_mapped, f->pgfault);
> +}
> +
> +/*
> + * Compare the BPF kfunc snapshots (round 1) against the memory.stat val=
ues
> + * (round 2), node by node.  The two rounds are independent, equivalently
> + * charged trees, so the flushed stats are compared within a small toler=
ance
> + * that absorbs per-round overhead (i.e., a charging child's own stack p=
ages).
> + * A wrong unit, enum or field in the kfunc path would miss by far more.
> + *
> + * Two per-round checks verify the flush itself: each leaf was charged
> + * resident_bytes of anon spread over K CPUs, so its flushed anon must b=
e at
> + * least that; and the root's recursive anon must equal the sum of the l=
eaves'
> + * anon (rstat propagated the charge up the tree).
> + *
> + * Returns 0 if every check passes, -1 otherwise.
> + */
> +static int check_correctness(const struct memcg_stat_snapshot *bpf,
> +			     const struct file_snap *file, const bool *is_leaf,
> +			     int n, size_t resident_bytes)
> +{
> +	__u64 stat_tol =3D 64 * page_size;
> +	__u64 pgf_tol =3D 1024;

These are central values of the test.  It's necessary to explain the
choice of them.


> +	__u64 broot =3D 0, bsum =3D 0, froot =3D 0, fsum =3D 0;
> +	int i, mism =3D 0, flush_bad =3D 0;
> +
> +	for (i =3D 0; i < n; i++) {
> +		const struct memcg_stat_snapshot *b =3D &bpf[i];
> +		const struct file_snap *f =3D &file[i];
> +		__u64 bcur =3D b->usage_pages * page_size;
> +
> +		/* kfunc path (round 1) compared with memory.stat path (round 2) */
> +		if (!close_enough(b->anon, f->anon, stat_tol) ||
> +		    !close_enough(b->file, f->file, stat_tol) ||
> +		    !close_enough(b->shmem, f->shmem, stat_tol) ||
> +		    !close_enough(b->file_mapped, f->file_mapped, stat_tol) ||
> +		    !close_enough(b->pgfault, f->pgfault, pgf_tol)) {
> +			mism++;
> +			dump_node(i, b, f);
> +		}
> +
> +		/* memory.current is live (no flush) and must bound the flushed anon */
> +		if (b->anon =3D=3D 0 || b->anon > bcur) {
> +			flush_bad++;
> +			ksft_print_msg("node %d: anon=3D%llu exceeds current=3D%llu\n",
> +				       i, b->anon, bcur);
> +		}
> +
> +		/* each leaf's flush must have gathered the full cross-CPU charge */
> +		if (is_leaf[i]) {
> +			if (b->anon < resident_bytes || f->anon < resident_bytes) {
> +				flush_bad++;
> +				ksft_print_msg("node %d: short flush bpf=3D%llu file=3D%llu\n",
> +					       i, b->anon, f->anon);
> +			}
> +			bsum +=3D b->anon;
> +			fsum +=3D f->anon;
> +		}
> +		if (i =3D=3D 0) { /* nodes[0] =3D=3D subtree_root */
> +			broot =3D b->anon;
> +			froot =3D f->anon;
> +		}
> +	}
> +
> +	if (mism) {
> +		ksft_print_msg("bpf (round 1) disagrees with memory.stat (round 2)\n");
> +		return -1;
> +	}
> +	if (flush_bad) {
> +		ksft_print_msg("flush did not aggregate the cross-cpu charge\n");
> +		return -1;
> +	}
> +	if (broot !=3D bsum || froot !=3D fsum) {
> +		ksft_print_msg("root anon !=3D sum of leaf anon: bpf %llu/%llu file %l=
lu/%llu\n",
> +			       broot, bsum, froot, fsum);
> +		return -1;
> +	}
> +	if (bsum =3D=3D 0) {
> +		ksft_print_msg("tree carries no anon\n");
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +/* ---- one case -------------------------------------------------------=
--- */
> +
> +struct testcase {
> +	const char *name;
> +	int fanout;
> +	int depth;
> +	int cpus_per_leaf; /* K: CPUs each leaf is charged on; 0 =3D all CPUs */
> +	size_t resident_bytes; /* anon charged per leaf */
> +};
> +
> +/*
> + * Remove the subtree in reverse creation order.  Nodes are recorded in =
DFS
> + * order (a parent precedes all its descendants), so iterating backwards
> + * removes every child before its parent.
> + */
> +static void destroy_tree(void)
> +{
> +	int i;
> +
> +	if (!nodes)
> +		return;
> +	for (i =3D n_nodes - 1; i >=3D 0; i--)
> +		cg_destroy(nodes[i].path);
> +	free(nodes);
> +	nodes =3D NULL;
> +}
> +
> +/*
> + * Round 1: build and charge a fresh tree, walk it with the BPF iterator=
 (which
> + * flushes and reads each cgroup via the memcg kfuncs), and capture one =
snapshot
> + * per node into @snap.  @is_leaf records the tree shape so the later co=
mparison
> + * can run after the tree is gone.  Returns the node count, or -1 on fai=
lure.
> + * The tree is always torn down before returning.
> + */
> +static int capture_bpf_round(const struct testcase *tc,
> +			     struct memcg_stat_snapshot *snap, bool *is_leaf)
> +{
> +	struct memcg_stat_cross_cpu *skel =3D NULL;
> +	struct bpf_link *link =3D NULL;
> +	int root_fd =3D -1, ret =3D -1, i, mfd;
> +
> +	if (build_tree(tc->fanout, tc->depth, &root_fd)) {
> +		ksft_print_msg("build tree (bpf) failed\n");
> +		goto out;
> +	}
> +	if (start_chargers(tc->cpus_per_leaf, tc->resident_bytes))
> +		goto out;
> +
> +	skel =3D memcg_stat_cross_cpu__open();
> +	if (!skel) {
> +		ksft_print_msg("skel open failed\n");
> +		goto out;
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
> +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
> +	union bpf_iter_link_info linfo =3D {};
> +
> +	linfo.cgroup.cgroup_fd =3D root_fd;
> +	linfo.cgroup.order =3D BPF_CGROUP_ITER_DESCENDANTS_PRE;
> +	opts.link_info =3D &linfo;
> +	opts.link_info_len =3D sizeof(linfo);
> +
> +	link =3D bpf_program__attach_iter(skel->progs.cgroup_memcg_stat_cross_c=
pu,
> +					&opts);
> +	if (!link) {
> +		ksft_print_msg("attach iter failed\n");
> +		goto out;
> +	}
> +
> +	/* bpf walk through the cgroup tree and fetch result */
> +	if (bpf_walk_once(link)) {
> +		ksft_print_msg("bpf walk failed\n");
> +		goto out;
> +	}
> +
> +	mfd =3D bpf_map__fd(skel->maps.results);
> +	for (i =3D 0; i < n_nodes; i++) {
> +		/* Save the position for the leaf, used for later correctness check */
> +		is_leaf[i] =3D nodes[i].is_leaf;
> +		if (bpf_map_lookup_elem(mfd, &nodes[i].id, &snap[i])) {
> +			ksft_print_msg("map lookup failed for node %d\n", i);
> +			goto out;
> +		}
> +	}
> +	ret =3D n_nodes;
> +out:
> +	bpf_link__destroy(link);
> +	memcg_stat_cross_cpu__destroy(skel);
> +	if (root_fd >=3D 0)
> +		close(root_fd);
> +	stop_chargers();
> +	destroy_tree();
> +	return ret;
> +}
> +
> +/*
> + * Round 2: build and charge an identical fresh tree, then read every cg=
roup via
> + * memory.stat / memory.current.  The tree is reset after bpf read, so e=
ach
> + * read does a real rstat flush.  Returns the node count, or -1 on failu=
re.
> + * The tree is always clear before returning.
> + */
> +static int capture_file_round(const struct testcase *tc, struct file_sna=
p *snap)
> +{
> +	int root_fd =3D -1, ret =3D -1, i;
> +
> +	if (build_tree(tc->fanout, tc->depth, &root_fd)) {
> +		ksft_print_msg("build tree (file) failed\n");
> +		goto out;
> +	}
> +	if (start_chargers(tc->cpus_per_leaf, tc->resident_bytes))
> +		goto out;
> +
> +	for (i =3D 0; i < n_nodes; i++)
> +		if (file_read_node(nodes[i].path, &snap[i])) {
> +			ksft_print_msg("file read failed for node %d\n", i);
> +			goto out;
> +		}
> +	ret =3D n_nodes;
> +out:
> +	if (root_fd >=3D 0)
> +		close(root_fd);
> +	stop_chargers();
> +	destroy_tree();
> +	return ret;
> +}
> +
> +static int run_case(const struct testcase *tc)
> +{
> +	struct memcg_stat_snapshot *bpf =3D NULL;
> +	struct file_snap *file =3D NULL;
> +	bool *is_leaf =3D NULL;
> +	size_t cap =3D tree_capacity(tc->fanout, tc->depth);
> +	int nb, nf, ret =3D KSFT_FAIL;
> +
> +	bpf =3D calloc(cap, sizeof(*bpf));
> +	file =3D calloc(cap, sizeof(*file));
> +	is_leaf =3D calloc(cap, sizeof(*is_leaf));

(This caught my eye, it looks like those could be better members of
struct cg_node. But I'm not 100% leaned to it.)

> +	/* round 2: file reader flushes and reads a fresh, equivalent tree */

Hm, I think that's quite a strong assumption that the 2nd tree would be
equivalent (wrt memcg state). Could you back it up with some arguments
if you want to rely on it?



Thanks for an interesting comparer,
Michal

--ag6sewjdvm6sdw3b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCamCQxRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiNbQD8C4AH4jaYi6gD1GbnB0sM
NW9dxXz9+pvykaHfFRW+jh8BALbvddo6X3fXt4ct0hLvUV5MM/vXj9SRlLnqY08+
fa8N
=FVmc
-----END PGP SIGNATURE-----

--ag6sewjdvm6sdw3b--
