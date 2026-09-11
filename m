Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1584476CFE
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 09:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118444; cv=none; b=SEj6Yqu/gsqFVPj5dbJKeeytTqntzxm3DcUpJ5XR3HDe976ji5grsS2/7ssDQUVJjzGFI+4Ydn+suJtsCFOcxXZk0bKFwaEZ09aXlYXXVSDitywfwgtDI5xHZSHTxSBM1nvH4FGZ9SYiu6TDAhbHuxFXDmtbZYNV+6GXQJxI8eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118444; c=relaxed/simple;
	bh=UFu6gOupqmD/1GxGmRJLoTDZNWK4bDj00hEqeQH1j/k=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ly8rrgIzBRzu7csjdOZ89n/LhQV3KVwPvzLx7/pVkZprFp2mhgiqEeOtlO2kzn6FZ74yZa/6AZf0zFLw/ZHmgOvmDR/SywYbp5dOCnggORtyo5brdJR/T41IZX36O6v9ILauynnn6Ft4nhUAJdVxb7NCZDJqXIhYhpqDQpBPkdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E2ulxXNj; arc=none smtp.client-ip=91.218.175.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E2ulxXNj"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=UFu6gOupqmD/1GxGmRJLoTDZNWK4bDj00hEqeQH1j/k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789118438; v=1; x=1789723238;
 b=E2ulxXNjXQ0I2slO6KOU+cyIDHVI/odAdpIPOCDzn2tXeMHcDm6AeqKldGkOW1kYLUk42YS4
 1F+kSVAH9FlosF02q7trFc2LJpzW2f/mpbWZct47TRtwQHhIbGqT78muOaxyZLVqh2boXy2AFRR
 JrVAZDDPDN1HRHzeh3XFm7Fo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6ca65b37e596c222;
	Fri, 11 Sep 2026 09:20:38 +0000
X-Mizu-Trace-ID: 6ca65b37e596c222
X-Migadu-Flow: FLOW_OUT
Message-ID: <b941d2aa-db3f-4473-ab4b-54105e277bf8@linux.dev>
Date: Fri, 11 Sep 2026 17:20:28 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 cuitao@kylinos.cn
Subject: Re: [RFC PATCH v2 0/5] blk-iocost: BPF struct_ops cost model
To: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk
References: <20260910125817.223354-1-cui.tao@linux.dev>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260910125817.223354-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/10 20:58, Tao Cui 写道:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> This is v2 of the RFC.  It incorporates the feedback from the first
> review round: the attachment model, pricing ownership and per-cgroup
> state handling have all been reworked, and the interface,
> registration, dispatch and configuration changes are now folded
> into a single patch.  Thanks for the detailed review.
> 

Thanks for running the automated review.

I've gone through the reports. Some point out real issues or places that
can be improved, while others need a closer look. I'll sort through
them and address the valid ones in the next revision, including the
documentation updates where appropriate.

Thanks.

> Why a pluggable model at all
> ----------------------------
> 
> When iocost landed in 2019, its commit message already promised that
> "a later patch will also allow using bpf progs for cost models", and
> the code has carried the split for it ever since: calc_vtime_cost()
> is a dispatcher whose only implementation is calc_vtime_cost_builtin().
> Seven years later the builtin linear model is still the only one.
> This series fills that slot, following the TCP congestion control
> model registration pattern: builtin algorithms remain the default
> while new ones can be prototyped in BPF.
> 
> The measured problems
> ---------------------
> 
> The builtin model prices each IO with a binary sequential/random base
> picked by a single per-cgroup cursor and a 16MB seek threshold, plus
> a per-page cost.  On a virtio-blk device with the HDD autop profile,
> a 4k IO costs ~24us when judged sequential and ~2.7ms when judged
> random, a 112x spread, so a wrong judgement becomes a wrong price.
> Three classes of mispricing, all measured:
> 
>  1. Heuristic rigidity.  Two legitimate sequential readers in one
>     cgroup (a database with multiple tablespaces, a threaded backup)
>     ping-pong the single cursor and are all priced random: a
>     measured 89x overcharge collapses throughput under the same
>     weight.
>     Random IO within a hot window smaller than the 16MB threshold is
>     priced sequential: measured 107x undercharge, an accounting
>     escape for hotspot workloads.  No setting of the six builtin
>     parameters seems able to fix this: telling the streams apart
>     requires per-IO state tracking, which looks like logic rather
>     than coefficients.
> 
>  2. Device nonlinearity.  SLC-cache phases, SMR band placement and
>     shared controllers (multiple NVMe namespaces multiplexing one
>     device) make the real cost of an identical IO vary by an order of
>     magnitude over time or across namespaces.  A static
>     6-parameter linear model has no way to express that.
> 
>  3. Unpriced operations.  Flush and zone append fall through to a
>     cost of zero and bypass throttling entirely (fixed in a separate
>     series already posted), but the same pattern extends to device
>     quirks the builtin model was never taught.
> 
> Mispricing feeds directly into the control loop: vtime budgets,
> surplus donation and the vrate feedback all consume the model's
> output, so a wrong model can skew the whole controller.
> 
> How
> ---
> 
> A bound BPF model fully owns pricing for every IO on the device:
> both the bio charging path and the request-level sizing path consult
> it, there is no per-IO or per-path fallback to the builtin formula,
> and the model prices every operation including flushes.  The builtin
> cursor is not exposed; a model is expected to track its own stream
> state.
> 
>     u64 calc_cost(u64 opf, u64 nbytes, sector_t sector,
> 		  struct blkcg *blkcg, u64 model_flags)
> 
> opf is the full bio->bi_opf (the operation must be extracted with a
> mask, and the REQ_* flag bits, including PREFLUSH/FUA, are part of
> it); model_flags carries iocost-specific metadata which is not
> part of bio->bi_opf, such as whether the cost calculation is for
> a merged request; the return value is vtime, clamped to 1 second
> of device time per IO.  blkcg is passed so the model can key
> per-cgroup state; state stored in BPF_MAP_TYPE_CGRP_STORAGE
> follows the cgroup lifetime, and optional blkcg_online()/
> blkcg_offline() callbacks mirror the css lifecycle for models
> which want eager setup or teardown.
> 
> The registration and binding model follows the TCP congestion
> control model registration pattern: registering a struct_ops makes
> the model available by its name, while io.cost.model binds one
> registered model to a device with "model=<name>" and restores the
> builtin model with "model=linear".  Unregistering a model removes
> it from the registry so it can no longer be selected by name;
> devices already using the model keep using it until they are
> switched back to the builtin model, at which point the reference
> is released.  Sleepable models are rejected at
> verification, since calc_cost() runs under RCU read lock.
> Patch overview:
> 
>  1/5: the BPF struct_ops cost model support: Kconfig, ops
>       definition, name registry, registration, io.cost.model
>       binding, unified dispatch and verifier checks
>  2/5: selftest with the 2x example model (the full builtin linear
>       HDD formula at double cost) plus a runner and the selftest
>       kernel config entries
>  3/5: add an iocost_ioc_tick tracepoint emitting the per-period
>       controller state, so model quality can be evaluated without
>       drgn (existing events are state-change driven and silent in
>       steady state)
>  4/5: a second example model which replaces the single-cursor
>       sequentiality heuristic with per-cgroup multi-stream detection
>       keyed by the cgroup, the first consumer of the state interface
>  5/5: document the model=<name> binding in cgroup-v2.rst
> 
> Does it work
> ------------
> 
> Mechanism, verified functionally (QEMU, virtio-blk with the HDD
> profile, same 8s sequential-read workload from a 1%-weight cgroup,
> builtin vs the 2x example model):
> 
>  - per-IO charge: 2882us -> 5722us, a factor of 1.985x; the
>    completed IO count halves and total cost.usage is conserved,
>    i.e. the model output drives both charging and budgeting
>  - the same ratio held across four hosts and 4k/64k/1M block sizes
>    in the v1 measurements (2.00-2.03x on flash-backed hosts, within
>    2% of 2x on a real HDD behind a loaded host); the charging
>    measurement is consistent with the v1 mechanism test, while v2
>    additionally dispatches the request sizing path through the
>    model
>  - edge cases: binding an unknown model name fails with ENOENT;
>    unregistering a bound model leaves the device correctly priced
>    until it is switched back to the builtin model; the readback
>    shows the bound model name; the selftest runner checks the
>    write error and errno of every step, including the restoration
> 
> Payoff, demonstrated with the multi-stream example model (4/5) on
> the same setup, 4k IOs at weight 1000, builtin vs the model:
> 
>  - two sequential readers in one cgroup: priced 1961us/op by builtin
>    (both judged random by the single cursor) and 23us/op by the
>    model (each stream keeps its own slot); the completed IO count
>    rises by two orders of magnitude
>  - random IO inside an 8M window: priced 24us/op by builtin
>    (undercharge, an accounting escape) and 2607us/op by the model
>  - single-stream sequential and whole-disk random pricing are
>    unchanged, so the model fixes both directions of mispricing
>    without introducing a new one
> 
> Non-interference, measured on enterprise NVMe: no measurable
> overhead when the BPF model is not attached.
> 
> ---
> Changes in v2:
> - struct_ops models are now registered by name and bound per
>   device through io.cost.model; the previous ctrl=bpf selection
>   mechanism, the system-wide single-instance limit and its mutex
>   are gone
> - a bound model fully owns pricing: the return-0 delegation to the
>   builtin formula is gone, the request-level sizing path dispatches
>   to the model too, and the builtin cursor is no longer exposed
> - iocg_id is replaced by the blkcg kptr; per-cgroup state uses
>   cgroup storage with its lifetime, plus optional
>   blkcg_online/offline callbacks
> - the full bio->bi_opf including PREFLUSH/FUA is preserved in
>   opf, while model_flags carries iocost-specific metadata
> - sleepable models are rejected in .check_member
> - Kconfig depends on DEBUG_INFO_BTF
> - tracepoint renamed to iocost_ioc_tick; the example model fixes
>   the merged-bio stream advancement and the map exhaustion
>   limitation (cgroup storage), the selftest checks real write
>   errors and the selftest kernel config carries the new options
> - the interface, registration, dispatch and configuration changes
>   are folded into one patch
> 
> Tao Cui (5):
>   blk-iocost: add BPF struct_ops cost model support
>   selftests/bpf: add iocost cost model test
>   blk-iocost: add iocost_ioc_tick tracepoint for per-period device
>     summary
>   selftests/bpf: add multi-stream sequentiality example model
>   docs: cgroup-v2: document io.cost model=<name> binding
> 
>  Documentation/admin-guide/cgroup-v2.rst       |  11 +
>  block/Kconfig                                 |   9 +
>  block/Makefile                                |   1 +
>  block/blk-cgroup.c                            |   3 +
>  block/blk-iocost-bpf.c                        | 252 ++++++++++++++++++
>  block/blk-iocost.c                            | 138 +++++++++-
>  include/linux/blk-iocost.h                    |  82 ++++++
>  include/trace/events/iocost.h                 |  40 +++
>  tools/testing/selftests/bpf/config            |   2 +
>  .../selftests/bpf/prog_tests/iocost_model.c   | 194 ++++++++++++++
>  .../selftests/bpf/progs/iocost_model.c        | 117 ++++++++
>  tools/testing/selftests/bpf/progs/iocost_ms.c | 137 ++++++++++
>  12 files changed, 979 insertions(+), 7 deletions(-)
>  create mode 100644 block/blk-iocost-bpf.c
>  create mode 100644 include/linux/blk-iocost.h
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
>  create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c
>  create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c
> 

