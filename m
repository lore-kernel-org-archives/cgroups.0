Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED81239CD08
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 05:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710631; cv=none; b=ZBwE1sOq2CsCaDpyrloUYjUz5mUEtZQbyOs8BIaMWaA28Kp6SmXEnLM3dpchoPZyBwDdjV/BXs274pjgeKhy+JYQ2mrsdyd67Gs9Iz97PWN3lgn3wde8sj+cKTuQsvqfKrK/kjeEGo1++RpKt81pmmiBYszWkA9OAar+GnXf4VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710631; c=relaxed/simple;
	bh=Z6p28FiFvwrdbcCcOGzSwcZjLjqiPC8+vsZtlKp8cHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CU8228eznhJqNHjQaO0oc5TRNCYR3rz1KeYU2slJZcQg1F9FnuwLBSXCHb0H5Q7acRZOz+enWX2rWqDI170eiqsvHitzpUUcmhETnQZGqaP0vNvRiCUbIVB298sfAfds/0UhSRfuxcqRBDUqlGPtfs3Zt27WT/AjlUajMbzSmD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nE+exSyK; arc=none smtp.client-ip=91.218.175.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nE+exSyK"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Z6p28FiFvwrdbcCcOGzSwcZjLjqiPC8+vsZtlKp8cHQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789710626; v=1; x=1790315426;
 b=nE+exSyKwCI2SFNVPpe0Bbd7jPWGi5h0qGVyz9ki2SZsyv4we+t9hB5053cNnUTM6/5MaFGl
 jtJJWm7ILqUyiPhOv+2CZqNOmXWIaq0kqNXLEA0/5WFuSaMatYLZH12X/FI7q5KzOlJ92a4ohA7
 /sp+bPmToSieCWNzaEDXTRqc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9d3e9250253033c7;
	Fri, 18 Sep 2026 05:50:18 +0000
X-Mizu-Trace-ID: 9d3e9250253033c7
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	ameryhung@gmail.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [RFC PATCH v6 0/5] blk-iocost: BPF struct_ops cost model
Date: Fri, 18 Sep 2026 13:49:56 +0800
Message-ID: <20260918055001.1273840-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

This is v6 of the RFC.  The changes since v5 are listed in the
changelog at the bottom.

Why a pluggable model at all
----------------------------

When iocost landed in 2019, its commit message already promised that
"a later patch will also allow using bpf progs for cost models", and
the code has carried the split for it ever since: calc_vtime_cost()
is a dispatcher whose only implementation is calc_vtime_cost_builtin().
Seven years later the builtin linear model is still the only one.
This series fills that slot, following the TCP congestion control
model registration pattern: builtin algorithms remain the default
while new ones can be prototyped in BPF.

The measured problems
---------------------

The builtin model prices each IO with a binary sequential/random base
picked by a single per-cgroup cursor and a 16MB seek threshold, plus
a per-page cost.  On a virtio-blk device with the HDD autop profile,
a 4k IO costs ~24us when judged sequential and ~2.7ms when judged
random, a 112x spread, so a wrong judgement becomes a wrong price.
Three classes of mispricing, all measured:

 1. Heuristic rigidity.  Two legitimate sequential readers in one
    cgroup (a database with multiple tablespaces, a threaded backup)
    ping-pong the single cursor and are all priced random: a
    measured 89x overcharge collapses throughput under the same
    weight.  Random IO within a hot window smaller than the 16MB
    threshold is priced sequential: measured 107x undercharge, an
    accounting escape for hotspot workloads.  No setting of the six
    builtin parameters seems able to fix this: telling the streams
    apart requires per-IO state tracking, which looks like logic
    rather than coefficients.

 2. Device nonlinearity.  SLC-cache phases, SMR band placement and
    shared controllers (multiple NVMe namespaces multiplexing one
    device) make the real cost of an identical IO vary by an order
    of magnitude over time or across namespaces.  A static
    6-parameter linear model has no way to express that.

 3. Unpriced operations.  Flush and zone append fall through to a
    cost of zero and bypass throttling entirely, and the same pattern
    extends to device quirks the builtin model was never taught.

Mispricing feeds directly into the control loop: vtime budgets,
surplus donation and the vrate feedback all consume the model's
output, so a wrong model can skew the whole controller.

How
---

A bound BPF model fully owns pricing for every IO on the device:
it is called from the bio charging path and prices every operation
including flushes.  The completion-time request sizing for the
latency met/missed accounting still uses the builtin coefficients
(the request's bio, and with it the issuing cgroup, is gone by then);
extending the model there is left open by this interface.  The builtin
cursor is not exposed; a model is expected to track its own stream
state.  Model state keyed by the blkcg alone is shared across every
device the model is bound to, unlike the builtin cursor which is
per (cgroup, device).

    u64 calc_cost(u64 opf, u64 nbytes, sector_t sector,
		  struct blkcg *blkcg, u64 model_flags)

opf is the full bio->bi_opf (the operation must be extracted with a
mask, and the REQ_* flag bits, including PREFLUSH/FUA, are part of
it); model_flags carries iocost-specific metadata which is not part
of the bio operation flags, such as whether the cost calculation
is for a merged request; the return value is vtime, clamped to 1
second of device time per IO.  blkcg is passed so the model can key
per-cgroup state; state stored in BPF_MAP_TYPE_CGRP_STORAGE
follows the cgroup lifetime, and optional blkcg_online()/
blkcg_offline() callbacks mirror the css lifecycle for models
which want eager setup or teardown.

The registration and binding model follows the TCP congestion
control model registration pattern: registering a struct_ops makes
the model available by its name, while io.cost.model binds one
registered model to a device with "model=<name>" and restores the
builtin model with "model=linear".  Unregistering a model removes
it from the registry so it can no longer be selected by name;
devices already using the model keep using it until they are
switched back to the builtin model, at which point the reference
is released.  A model which does not implement calc_cost is
rejected at load.  Sleepable models are rejected at verification,
since calc_cost() runs under RCU read lock.  Patch overview:

 1/5: the BPF struct_ops cost model support: Kconfig, ops
      definition, name registry, registration, io.cost.model
      binding, unified dispatch and verifier checks
 2/5: selftest with the 2x example model (the full builtin linear
      HDD formula at double cost) plus a runner and the selftest
      kernel config entries
 3/5: add an iocost_ioc_tick tracepoint emitting the per-period
      controller state, so model quality can be evaluated without
      drgn (existing events are state-change driven and silent in
      steady state)
 4/5: a second example model which replaces the single-cursor
      sequentiality heuristic with per-cgroup multi-stream detection
      keyed by the cgroup, the first consumer of the state interface
 5/5: document the model=<name> binding in cgroup-v2.rst

Does it work
------------

Mechanism, verified functionally (QEMU, virtio-blk with the HDD
profile, sequential-read workload from a 1%-weight cgroup, builtin
vs the 2x example model):

 - per-IO charge: 2882us -> 5722us, a factor of 1.985x; the
   completed IO count halves and total cost.usage is conserved,
   i.e. the model output drives both charging and budgeting
 - edge cases: binding an unknown model name fails with ENOENT
   and nothing is applied; unregistering a bound model leaves the
   device correctly priced (2x) until it is switched back; the
   readback shows the bound model name; the selftest runner
   checks the write error and errno of every step, including the
   restoration

Workload-shape verification added in this revision (same setup,
4k IOs at weight 1000, builtin vs the 2x example model):

 - flush-heavy workload (read/write/fsync alternating): priced
   1.99x the builtin, i.e. flushes no longer reset the cursor
   and misjudge the following IO as random
 - non-page-multiple IO (6 KiB): priced ~2x, matching the
   builtin's truncating page count
 - first IO from a high LBA (past 16 MiB): priced 2.01x, i.e.
   a fresh cgroup's zero cursor no longer misjudges the first IO
   as random

Payoff, demonstrated with the multi-stream example model (4/5) on
the same setup, 4k IOs at weight 1000, builtin vs the model:

 - two sequential readers in one cgroup: priced 1961us/op by builtin
   (both judged random by the single cursor) and 23us/op by the
   model (each stream keeps its own slot); the completed IO count
   rises by two orders of magnitude
 - random IO inside an 8M window: priced 24us/op by builtin
   (undercharge, an accounting escape) and 2607us/op by the model
 - single-stream sequential and whole-disk random pricing are
   unchanged, so the model fixes both directions of mispricing
   without introducing a new one

Non-interference, measured on enterprise NVMe: no measurable
overhead when the BPF model is not attached.

Changes in v6 (fixes from the v5 review):
- the extra reference drop added in v5 for racing io.cost.model
  writes resolving the same model is removed: each resolved
  reference is either transferred to the device by the commit or
  dropped by replacing the previous one, so the single
  iocost_bpf_model_put(old) was already balanced, and the extra drop
  undercounted a model written by name while bound, freeing it while
  the device still used it

Link: https://lore.kernel.org/r/20260908100143.47598-1-cui.tao@linux.dev # v1
Link: https://lore.kernel.org/r/20260910125817.223354-1-cui.tao@linux.dev # v2
Link: https://lore.kernel.org/r/20260914073356.791518-1-cui.tao@linux.dev # v3
Link: https://lore.kernel.org/r/20260916072302.1068871-1-cui.tao@linux.dev # v4
Link: https://lore.kernel.org/r/20260918031751.1255420-1-cui.tao@linux.dev # v5
Tao Cui (5):
  blk-iocost: add BPF struct_ops cost model support
  selftests/bpf: add iocost cost model test
  blk-iocost: add iocost_ioc_tick tracepoint for per-period device
    summary
  selftests/bpf: add multi-stream sequentiality example model
  docs: cgroup-v2: document io.cost model=<name> binding

 Documentation/admin-guide/cgroup-v2.rst       |  19 +
 block/Kconfig                                 |   9 +
 block/Makefile                                |   1 +
 block/blk-cgroup.c                            |   4 +
 block/blk-iocost-bpf.c                        | 321 ++++++++++++++++++
 block/blk-iocost.c                            | 220 +++++++++++++--
 include/linux/blk-iocost.h                    |  86 +++++
 include/trace/events/iocost.h                 |  45 +++
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/iocost_model.c   | 200 ++++++++++++
 .../selftests/bpf/progs/iocost_model.c        | 135 ++++++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 156 +++++++++
  12 files changed, 1190 insertions(+), 19 deletions(-)
 create mode 100644 block/blk-iocost-bpf.c
 create mode 100644 include/linux/blk-iocost.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

-- 
2.43.0

