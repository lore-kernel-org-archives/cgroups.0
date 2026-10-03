Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D488A2E7179
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 01:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991062; cv=none; b=BO6CSvT4aPgkooUnd7Ir1dQbWh0sV+PbkdiROqKig67qTYQNrISnBOtoHeVsi3b6RGiJW5ZKvpYHPjMisHIfF5NrttF8ZxnctOFFi4gs4eW83vKLPl4to+58iMHubiaNUQvjzS7Ad6W7qNE0DQo2wjK1CW5of/pBRRvOVaDohQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991062; c=relaxed/simple;
	bh=bT6KCjiIQFGCgiDSw4PiZWiOJVW/59NIfnejQEbHHWc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZYWUctKS6dO8TkS0uzcb2Kyv20DHyn6lUc8YIW/4iQLVY/hvhpHyzx05Z23acEEjRaFSy3mLApj8rYOl8VVZr02IWDsDDsmDQA+/B29ci9DunKCjTb1AxO8Z99smbLYlyzCYacwL/k858cYUrsJuHd+mfxjliNEwfhBZAHp4lbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H0zc9TPi; arc=none smtp.client-ip=91.218.175.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H0zc9TPi"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bT6KCjiIQFGCgiDSw4PiZWiOJVW/59NIfnejQEbHHWc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790991058; v=1; x=1791595858;
 b=H0zc9TPiEwVkG2usuHrKklvkKGLaEmZRSRsla6q77uJc1qg1VW1X8TsWUosvdwyHzgHcXSod
 wLL5pe696uPBThvXRoNMyXzFcbqtRjrvESHJ4a+uWEz0IgSxI63R2Mv5HQTImUqY4+rjEtzRbQG
 xdeTVVKG+vQSClKP6fuXkhcc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9ae44dfa17eba4dc;
	Sat, 03 Oct 2026 01:30:48 +0000
X-Mizu-Trace-ID: 9ae44dfa17eba4dc
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
Subject: [RFC PATCH v9 0/4] blk-iocost: add BPF struct_ops cost model support
Date: Sat,  3 Oct 2026 09:30:29 +0800
Message-ID: <20261003013033.149288-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

This is v9 of the RFC.  A BPF program can now take over the cost
model of one device: attaching an iocost_model_ops struct_ops creates
the ioc if needed and switches the device to the model, io.cost.model
selects between the attached and the builtin model, and detaching or
device removal restores the builtin one.  The attachment, the cgroup
callback pairing and the removal paths are serialized with what blkg
creation and destruction actually use.

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
in the dev member of the struct_ops from userspace before load; the
device is looked up with blkdev_get_no_open() and disk_live() is
checked under rq_qos_mutex, like blkg_conf_open_bdev().  Attaching
creates the ioc if needed, like an io.cost.model write does, and
switches the model under the same freeze and quiesce those writes
go through; enabling stays with io.cost.qos and wbt stays with it
too.  When the disk goes away, the model is ejected completely.

Attachment is independent of the model selection and of the
controller state: while a model is attached, "model" selects between
it and the builtin model - "model=bpf" switches to the attached
model, "model=linear" switches back to the builtin model, and
neither detaches the struct_ops; only detaching removes the model,
after which "model=bpf" fails.  "ctrl" keeps describing the builtin
coefficients, which are kept while the BPF model is in use and take
effect again when switched back.  Enabling and disabling the
controller, and with it the wbt handover, remains with io.cost.qos.

A bound model in use owns pricing for every charged IO on the
device: it is called from the bio charging path and prices every
operation including flushes.  The completion-time request sizing
which feeds the latency met/missed accounting uses the transfer cost
coefficients the struct_ops carries (vtime per page for reads and
writes), so the builtin latency tracking and vrate adjustment
follow the model's pricing while it is in use; extending the
model to the QoS side itself is left for a later interface.

The cgroup callbacks are bound to the iocg policy lifetime and pair
up: iocg_init() is delivered to every cgroup which already has a
blkg on the device when the model is attached, and to each one
appearing afterwards; iocg_free() is delivered to the cgroups which
still exist when the model is detached.  The existing iocgs are
walked over q->blkg_list under q->blkcg_mutex, the same walk the
blkcg policy teardown uses; cgroups without a blkg on the device
yet are not missed, as their callbacks are delivered at blkg
creation and destruction.

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
 - attachment: model=bpf readback while in use (ctrl keeps
   describing the builtin coefficients), EBUSY for a second model
   on the same device, a second device attaches an independent
   model, "model=linear"/"model=bpf" switch between the attached
   model and the builtin without detaching, detaching removes the
   model and "model=bpf" fails afterwards
 - edge cases: writing an unknown device fails and nothing is
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

Changes in v9:
- the attach holds rq_qos_mutex from the disk_live() check through
  the unfreeze, like an io.cost.model write does, instead of
  releasing it between creating the ioc and switching the model;
  the queue reference, the second q_to_ioc() and the lockless
  traversal it needed are gone
- the attachment is published, cleared and the blkg list is walked
  under blkcg_mutex and queue_lock: blkg creation runs ioc_pd_init()
  and adds to q->blkg_list under queue_lock only, so the previous
  blkcg_mutex-only serialization could double-deliver iocg_init() or
  deliver iocg_free() without iocg_init().  The init walk now goes
  parents first, like blkcg_activate_policy()
- the device removal ejection reads ops->bdev before clearing ops->q:
  once q is NULL .unreg returns without a lock and the map can be
  freed, so touching ops afterwards was a use-after-free window.  The
  ejection moved to an ioc_bpf_eject() helper
- .unreg only detaches when the closing link is the one which owns
  the attachment, so a map re-attached to a new device through a
  newer link is not torn down by an old link; the v8 ops->q re-entry
  guard at .reg is gone, a second attach of an attached map now
  fails with -EBUSY like any other model would
- the ioc->attached and ioc->model pointers are unconditional and
  blk_get_queue_rcu() is declared in block/blk.h without an export,
  which drops the local prototypes and the remaining #ifdefs
- the unused struct_ops .init name lookup, the bdev/q cases in
  .init_member (the core already rejects nonzero non-function members
  it does not claim) and the unused write_cost_model() buffers are
  gone; the -EOPNOTSUPP selftest paths call test__skip()
- the selftest writes the dev member through the skeleton's typed
  struct_ops access instead of assuming it is the first member, and
  the maps are ".struct_ops.link" so closing the fd detaches; the
  example model's seek judgement is gated on a non-zero IO size so a
  dataless flush is priced sequentially, and write_cost_model()
  returns the negated errno ASSERT_ERR() expects
- the tick tracepoint's running field reports the active iocg list
  instead of ioc->running, which has not transitioned to IOC_IDLE at
  the emit point, so the final tick reads active=0 running=0
- the attach and detach take the queue freeze before rq_qos_mutex,
  like ioc_qos_write() does; taking the mutex around the freeze
  instead formed a lockdep cycle with the io.cost.qos write path,
  and .unreg's link recheck moved under the mutex inside
  ioc_bpf_detach()
- the io.cost.model documentation states that detaching restores the
  builtin model and that ctrl only accepts "auto" and "user" and
  never selects the model, says attaching rather than loading binds
  the model, and that removing the device removes the model as well,
  with the struct_ops link still having to be closed afterwards
Link: https://lore.kernel.org/r/20260908100143.47598-1-cui.tao@linux.dev # v1
Link: https://lore.kernel.org/r/20260910125817.223354-1-cui.tao@linux.dev # v2
Link: https://lore.kernel.org/r/20260914073356.791518-1-cui.tao@linux.dev # v3
Link: https://lore.kernel.org/r/20260916072302.1068871-1-cui.tao@linux.dev # v4
Link: https://lore.kernel.org/r/20260918031751.1255420-1-cui.tao@linux.dev # v5
Link: https://lore.kernel.org/r/20260918055001.1273840-1-cui.tao@linux.dev # v6
Link: https://lore.kernel.org/r/20260924054549.2271705-1-cui.tao@linux.dev # v7
Link: https://lore.kernel.org/r/20260930075154.189958-1-cui.tao@linux.dev # v8
Tao Cui (4):
  blk-iocost: add BPF struct_ops cost model support
  selftests/bpf: add iocost cost model test
  blk-iocost: add iocost_ioc_tick tracepoint for per-period device
    summary
  docs: cgroup-v2: document the iocost BPF cost model attachment










