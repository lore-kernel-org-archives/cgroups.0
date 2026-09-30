Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E604446E6
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 07:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754739; cv=none; b=o7FsXEyhGtN9AqEU2qZ7zF3QLUJ7N+9hA7QP2ovhvomxaAEpM3vQdtl37z6J/zWfBIchu/ZApCKXxBhY4/Dbz8wQcqSTOjYodaR0JKDi/yRy3N+/yxtL0RxyuvDR/QJJ6oLS4sMGWAF4c7MnOCOSLc1YjBlSAPEeDj7h5Oxxwz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754739; c=relaxed/simple;
	bh=ZjfefV9snQ1ih4zTfEBMqJAhu+p8KVvNDSCMrnypdPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NZobvwqa9r2mW+Xcw8Pebm8q5DYMMTzwSaDrFHXj/5rYU8gKyYUc9sBEvCUi1uSRjM9MUcQHXQSEDc/q3zGROSU1aa4WpCtI2QUvmvmdhp+u/IoqtJ+QAlwAbsTzxGW/7HWQBuewEQNHr+dYAdbv3h/snctTGU3aYFUy+N3UYhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ejvgW95f; arc=none smtp.client-ip=91.218.175.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ejvgW95f"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZjfefV9snQ1ih4zTfEBMqJAhu+p8KVvNDSCMrnypdPk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790754733; v=1; x=1791359533;
 b=ejvgW95fYPcvKJ/C5/xE1eBtJMInjcSy+D8E8p056Wx3uW9nqMh8DD2jiF20x88adifkurvA
 XsSSS1sxIDVO7VeKXPr+MWEfEEnce2VO8g+e/luXuBG6ogTBGja5qy50ElGxLhVLBkbcxlGp0EF
 DA0q75EwSV+jpQU/VB1MyDCo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 114f3b97191ecc8b;
	Wed, 30 Sep 2026 07:52:03 +0000
X-Mizu-Trace-ID: 114f3b97191ecc8b
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
Subject: [RFC PATCH v8 0/4] blk-iocost: add BPF struct_ops cost model support
Date: Wed, 30 Sep 2026 15:51:50 +0800
Message-ID: <20260930075154.189958-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v8 of the RFC.  The attachment model is independent of
controller enablement: attaching creates the ioc if needed and
switches the model under the same queue freeze and quiesce as
io.cost.model writes, while enabling stays with io.cost.qos; the
cgroup callbacks now pair up across attach/detach.

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

Changes in v8:
- attachment no longer enables the controller: attaching creates
  the ioc under rq_qos_mutex (with the disk_live() check
  blkg_conf_open_bdev() does) and switches the model under the
  same freeze and quiesce as the io.cost.model writes; the implicit
  enable and the wbt handover are gone, and "model=bpf"/
  "model=linear" switch between the attached model and the builtin
  model without detaching, per the v7 review
- iocg_init()/iocg_free() now pair up: the existing iocgs are
  walked over q->blkg_list under q->blkcg_mutex on attach and the
  remaining ones on detach, the same walk the blkcg policy teardown
  uses; cgroups without a blkg on the device yet get their
  callbacks at blkg creation
- ctrl=bpf is rejected (it never reads back), model=bpf fails when
  no model is attached
- a helper returning the model in use (stubbed to NULL when
  !CONFIG_BLK_CGROUP_IOCOST_BPF) replaces the scattered #ifdefs
  and unifies the duplicated seq_printf() in ioc_cost_model_prfill()
- the completion-time sizing is back to a plain pages * coeff like
  the builtin, which also removes the 64-bit division
- the bdev file pin is gone: the attach instead holds a no_open bdev
  reference, dropped by the removal ejection or by .unreg, whichever
  detaches the model first, mirroring hid_bpf's per-ops device
  reference without pinning the driver module.  The device is looked
  up with
  blkdev_get_no_open() and disk_live() under rq_qos_mutex, .reg
  rejects re-attach, and ioc_rqos_exit() ejects the model
  completely on device removal
- the tick tracepoint passes only ioc, &now, nr_active and
  usage_us_sum, and reads the rest from ioc in TP_fast_assign() like
  the other iocost events
- .unreg takes a queue reference before waiting on rq_qos_mutex,
  with an RCU tryget helper so a reference can be taken on a queue
  read locklessly, and re-checks whether the removal ejection already
  detached the model; the model clearing and the iocg_free() walk on
  detach are synchronized against ioc_pd_init()/ioc_pd_free() with
  q->blkcg_mutex
- the attach holds a queue reference across the window where it is
  off rq_qos_mutex between creating the ioc and switching the model,
  so concurrent device removal cannot free the queue from under it
- the two bpf-ci reported attach issues (re-attach check,
  disk_live()) and the bot selftest findings (endianness of the
  dev write, comment fixes) are addressed

Link: https://lore.kernel.org/r/20260908100143.47598-1-cui.tao@linux.dev # v1
Link: https://lore.kernel.org/r/20260910125817.223354-1-cui.tao@linux.dev # v2
Link: https://lore.kernel.org/r/20260914073356.791518-1-cui.tao@linux.dev # v3
Link: https://lore.kernel.org/r/20260916072302.1068871-1-cui.tao@linux.dev # v4
Link: https://lore.kernel.org/r/20260918031751.1255420-1-cui.tao@linux.dev # v5
Link: https://lore.kernel.org/r/20260918055001.1273840-1-cui.tao@linux.dev # v6
Link: https://lore.kernel.org/r/20260924054549.2271705-1-cui.tao@linux.dev # v7
Tao Cui (4):
  blk-iocost: add BPF struct_ops cost model support
  selftests/bpf: add iocost cost model test
  blk-iocost: add iocost_ioc_tick tracepoint for per-period device
    summary
  docs: cgroup-v2: document the iocost BPF cost model attachment

 Documentation/admin-guide/cgroup-v2.rst       |  19 +
 block/Kconfig                                 |  10 +
 block/Makefile                                |   1 +
 block/blk-iocost-bpf.c                        | 198 +++++++++++
 block/blk-iocost.c                            | 334 +++++++++++++++++-
 include/linux/blk-iocost.h                    | 110 ++++++
 include/trace/events/iocost.h                 |  43 +++
 tools/testing/selftests/bpf/config            |   2 -
 .../selftests/bpf/prog_tests/iocost_model.c   | 233 ++++++++++++
 .../selftests/bpf/progs/iocost_model.c        | 138 ++++++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 159 +++++++++
 11 files changed, 1237 insertions(+), 10 deletions(-)
 create mode 100644 block/blk-iocost-bpf.c
 create mode 100644 include/linux/blk-iocost.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

-- 
2.43.0
