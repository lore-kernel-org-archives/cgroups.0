Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB78388E55
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 05:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790228773; cv=none; b=k3DIDJjO16LWGmn8McuBBV9AH3eoVpHSpMKWKETHTSmy2xyZZmdVmiSo13+TVBxsTu6TJsnf36c4L12nNJJ72nKhW0f68njf7zuUFWSrZms0q3gLEnoTxnTjez8S79KjiLuafhZ1DlQJus5Xs5xdLH9XdYIDS0K2CGKnIFICIiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790228773; c=relaxed/simple;
	bh=tEQ8Q1W7gSw55462EP0lBM27v6vipFnTl1J5kO4BJM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=psylHy6GEcCN2nXq28sV6fnd32U8C2v4Z5L2eJ9dFQ83soObJ3krH1j7TH27xs//OmoGRtBq25vMfAL8Vr3KCm+JXNLlQ5p6FwVWmZ3qSyrYX3D7YAsjn2zbkwVF8E7kJUfsxU+2xZPvE6/Ucqr4CRAqKWgsUiS+xysst/b8N5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dT+8XSd+; arc=none smtp.client-ip=95.215.58.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dT+8XSd+"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tEQ8Q1W7gSw55462EP0lBM27v6vipFnTl1J5kO4BJM8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790228767; v=1; x=1790833567;
 b=dT+8XSd+EBiHNcxP7lZwomRzJYCUz8PVvVJyx+gS6Pe3p1TChb42PNF+KDElAwKMFee6J2p5
 G23cP2wpfBbXnEPQn55CZYLtjv9nqfwnh6tFsz3OGN4x/Ny6MCMS944y4kEmCCwf3hSpGlE8Kr/
 YqQvK04ENFPPkCI/hFsRpToA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b3da0b78ad99a148;
	Thu, 24 Sep 2026 05:46:06 +0000
X-Mizu-Trace-ID: b3da0b78ad99a148
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
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
	cuitao@kylinos.cn,
	ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: [RFC PATCH v7 0/4] blk-iocost: BPF struct_ops cost model
Date: Thu, 24 Sep 2026 13:45:45 +0800
Message-ID: <20260924054549.2271705-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v7 of the RFC.  The attachment model is reworked: the
struct_ops instance is now per-device, following the hid_bpf_ops
pattern.  The name registry, the binding through io.cost.model
writes, the lifecycle list and the refcounting are gone.

Why a pluggable model at all
----------------------------

When iocost landed in 2019, its commit message already promised that
"a later patch will also allow using bpf progs for cost models", and
the code has carried the split for it ever since: calc_vtime_cost()
is a dispatcher whose only implementation is calc_vtime_cost_builtin().
Seven years later the builtin linear model is still the only one.
This series fills that slot: builtin algorithms remain the default
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

Attachment follows the hid_bpf_ops model: the target device is set
in the dev member of the struct_ops from userspace before load, as
a major:minor in the usual userspace encoding (decoded with
new_decode_dev() on the kernel side); loading attaches the model to
that device and switches it away from the builtin linear model,
detaching the struct_ops restores the builtin model, and the
struct_ops core owns the program lifetime.  There is no registry
and no bound-state bookkeeping; attaching a second model to a device
with one already attached fails with -EBUSY.

A bound model fully owns pricing for every IO on the device: it is
called from the bio charging path and prices every operation
including flushes.  The completion-time request sizing which feeds
the latency met/missed accounting uses the transfer cost
coefficients the struct_ops carries (vtime per page for reads and
writes), so the builtin latency tracking and vrate adjustment
follow the model's pricing while it is attached; extending the
model to the QoS side itself is left for a later interface.  The
builtin cursor is not exposed; a model is expected to track its own
stream state.  Model state keyed by the blkcg alone is shared
across every device the model is attached to, unlike the builtin
cursor which is per (cgroup, device); iocg_init()/iocg_free()
callbacks, invoked from the iocg policy init and free paths with
the same per (cgroup, device) lifetime, let models manage their own
per-cgroup state.

While a model is attached, "model" reads back "bpf" and "ctrl"
keeps describing the builtin coefficients, which are inert then:
coefficient writes are stored and take effect again after detach,
and the automatic profile stepping does not switch profiles.
Writing "ctrl=bpf" or "model=bpf" is accepted as a no-op so a saved
configuration still parses; re-attaching the model requires loading
the struct_ops again, not writing to this file.

    u64 calc_cost(struct bio *bio, u64 model_flags)

The model reads whatever it needs from the bio itself: the
operation flags (the operation must be extracted with a mask, and
the REQ_* flag bits, including PREFLUSH/FUA, are part of it), the
size, the start sector and the issuing cgroup through
bio->bi_blkg.  model_flags carries iocost-specific metadata which
is not a property of the bio, such as whether the cost calculation
is for a merged request; the return value is vtime, clamped to 1
second of device time per IO.  Per-cgroup state can be stored in
BPF_MAP_TYPE_CGRP_STORAGE keyed by the cgroup of bi_blkg; it
follows the cgroup lifetime.  Sleepable models are rejected at
verification, since calc_cost() runs under RCU read lock.

Patch overview:

 1/4: the BPF struct_ops cost model support: Kconfig, ops
      definition, per-device attachment, unified dispatch and
      verifier checks
 2/4: selftests with two example models (the full builtin linear
      HDD formula at double cost, and a multi-stream sequentiality
      model) plus a runner and the selftest kernel config entries
 3/4: add an iocost_ioc_tick tracepoint emitting the per-period
      controller state, so model quality can be evaluated without
      drgn (existing events are state-change driven and silent in
      steady state)
 4/4: document the attachment in cgroup-v2.rst

Does it work
------------

Mechanism, verified functionally on a virtio-blk device (HDD
profile, sequential-read workload from a 1%-weight cgroup, builtin
vs the 2x example model):

 - per-IO charge: 2882us -> 5722us, a factor of 1.985x; the
   completed IO count halves and total cost.usage is conserved,
   i.e. the model output drives both charging and budgeting
 - attachment: model=bpf readback while attached (ctrl keeps
   describing the inert builtin coefficients), EBUSY for a second
   model on the same device, a second device attaches an independent
   model, detaching restores the builtin readback
 - edge cases: binding an unknown device fails and nothing is
   applied; the selftest runner checks the write error and errno
   of every step, including the restoration

Workload-shape verification (same setup, 4k IOs at weight 1000,
builtin vs the 2x example model):

 - flush-heavy workload (read/write/fsync alternating): priced
   1.99x the builtin, i.e. flushes no longer reset the cursor
   and misjudge the following IO as random
 - non-page-multiple IO (6 KiB): priced ~2x, matching the
   builtin's truncating page count
 - first IO from a high LBA (past 16 MiB): priced 2.01x, i.e.
   a fresh cgroup's zero cursor no longer misjudges the first IO
   as random

Payoff, demonstrated with the multi-stream example model (2/4) on
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

Changes in v7:
- the attachment model is reworked along the lines of the v1 review
  feedback: the struct_ops instance is per-device following
  hid_bpf_ops, with the device in the dev member set from
  userspace before load, binding in .reg, unbinding in .unreg and
  the struct_ops core owning the lifetime; the name registry, the
  model-name handling in io.cost.model writes, the lifecycle list
  and the refcounting are removed
- calc_cost() receives the bio itself and reads the operation
  flags, size, sector and issuing cgroup from it; only the merge
  indicator stays in the separate flags argument
- the cgroup callbacks are bound to the iocg policy init/free
  paths instead of the blkcg css, giving the model the builtin
  cursor's per (cgroup, device) lifetime and dropping the global
  mutex from the cgroup online/offline paths
- the struct_ops carries the transfer cost coefficients (vtime per
  page for reads and writes), used by the completion-time request
  sizing so the builtin latency tracking and vrate adjustment
  follow the model's pricing while it is attached
- the tick tracepoint is emitted at the end of the period it
  reports, before the refresh, and the temporary snapshots are
  dropped
- the two selftest patches are combined

Link: https://lore.kernel.org/r/20260908100143.47598-1-cui.tao@linux.dev # v1
Link: https://lore.kernel.org/r/20260910125817.223354-1-cui.tao@linux.dev # v2
Link: https://lore.kernel.org/r/20260914073356.791518-1-cui.tao@linux.dev # v3
Link: https://lore.kernel.org/r/20260916072302.1068871-1-cui.tao@linux.dev # v4
Link: https://lore.kernel.org/r/20260918031751.1255420-1-cui.tao@linux.dev # v5
Link: https://lore.kernel.org/r/20260918055001.1273840-1-cui.tao@linux.dev # v6

Tao Cui (4):
  blk-iocost: add BPF struct_ops cost model support
  selftests/bpf: add iocost cost model test
  blk-iocost: add iocost_ioc_tick tracepoint for per-period device
    summary
  docs: cgroup-v2: document the iocost BPF cost model attachment

 Documentation/admin-guide/cgroup-v2.rst       |  17 ++
 block/Kconfig                                 |  10 +
 block/Makefile                                |   1 +
 block/blk-iocost-bpf.c                        | 165 ++++++++++
 block/blk-iocost.c                            | 283 +++++++++++++++++-
 include/linux/blk-iocost.h                    |  96 ++++++
 include/trace/events/iocost.h                 |  45 +++
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/iocost_model.c   | 180 +++++++++++
 .../selftests/bpf/progs/iocost_model.c        | 138 +++++++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 159 ++++++++++
 11 files changed, 1092 insertions(+), 4 deletions(-)
 create mode 100644 block/blk-iocost-bpf.c
 create mode 100644 include/linux/blk-iocost.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

-- 
2.43.0

