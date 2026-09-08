Received: from mta0.migadu.com (out-124.mta0.migadu.com [91.218.175.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC2C34A77D
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861739; cv=none; b=jdElliXAwqH4MxlBdWp8bTY3EmS3/L+udW7VyZKLsU10dCHKP6MBotc3IQrcu5/qx+Fjz17RLTkeYJDcDvTWiCHCLGyuUGy9Esn4AmKBvXVpVeCjP/HkZ5J/o6dIaYhybrvfVn5Q/1wbx4ZnHN/Ba9lGI4HmkLmf/4Oe/M2DEZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861739; c=relaxed/simple;
	bh=NaZjtoXPlnUMK40knB5HRLM8L7qIzudaPFX6dseAb8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=thmGMs8SJGGlbuNr98AIMpY7zCdggPdbiYvHJEfJvf+PkE6tPhwH2dURdfeIGbSw1Jt/Z8+6BFQSWhRwvuX48JlVdfG9/qc6w8UH/EX64NNuhGeLggIeAoEvO4bDrkyq1EMlFa9rF50uFBg31M0EsCSYa13YXsM/ezBmDhoNcX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gk9bEeBn; arc=none smtp.client-ip=91.218.175.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gk9bEeBn"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NaZjtoXPlnUMK40knB5HRLM8L7qIzudaPFX6dseAb8A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788861733; v=1; x=1789466533;
 b=Gk9bEeBnGk5s3686roTD611EnN3xpL4p45DUBfbktLzoLxXf8Dtrn3LUsgmhb8hiGw++Dmx4
 IrfwQ6Te7OwFMlyaVf6PdGHMjttqLfhgUv6aT6zeD470x5aKLUUmLLC5K1ynLGmtvOuBl+gIj1X
 8MMHkF8QHZ/bC6uFHh2Zbzrg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id aba7fee861943fea;
	Tue, 08 Sep 2026 10:02:03 +0000
X-Mizu-Trace-ID: aba7fee861943fea
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
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [RFC PATCH 0/8] blk-iocost: BPF struct_ops cost model
Date: Tue,  8 Sep 2026 18:01:35 +0800
Message-ID: <20260908100143.47598-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Why a pluggable model at all
----------------------------

When iocost landed in 2019, its commit message already promised that
"a later patch will also allow using bpf progs for cost models", and
the code has carried the split for it ever since: calc_vtime_cost()
is a dispatcher whose only implementation is calc_vtime_cost_builtin().
Seven years later the builtin linear model is still the only one.
This RFC fills that slot, following the bpf_tcp_ca and sched_ext
precedent: builtin algorithms stay as the default, new algorithms are
prototyped in BPF behind a struct_ops.

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
    ping-pong the single cursor and are all priced random: measured
    89x overcharge, 12.9x throughput collapse under the same weight.
    Random IO within a hot window smaller than the 16MB threshold is
    priced sequential: measured 107x undercharge, an accounting
    escape for hotspot workloads.  No setting of the six builtin
    parameters seems able to fix this: telling the streams apart
    requires per-IO state tracking, which looks like logic rather
    than coefficients.

 2. Device nonlinearity.  SLC-cache phases, SMR band placement and
    shared controllers (multiple NVMe namespaces multiplexing one
    device) make the real cost of an identical IO vary by an order of
    magnitude over time or across namespaces.  A static
    6-parameter linear model has no way to express that.

 3. Unpriced operations.  Flush and zone append fall through to a
    cost of zero and bypass throttling entirely (fixed in a separate
    series already posted), but the same pattern extends to device
    quirks the builtin model was never taught.

Mispricing feeds directly into the control loop: vtime budgets,
surplus donation and the vrate feedback all consume the model's
output, so a wrong model can skew the whole controller.

How
---

A new "iocost_model_ops" struct_ops with a single callback:

    u64 calc_cost(op, nbytes, sector, cursor, iocg_id, flags)

scalar arguments only, no kernel pointers exposed; the return value
is vtime (2^37 per second of device time), clamped to 1s per IO; a
return value of 0 delegates the IO back to the builtin formula, so a
model which only handles some IO types cannot make the rest free.
iocg_id identifies the issuing cgroup so a model can keep
per-cgroup state; struct_ops signatures are frozen once merged, so
it is part of the initial interface.  Devices opt in per queue with
"echo $dev ctrl=bpf > io.cost.model"; everything else keeps the
builtin model unchanged.  Patch overview:

 1/8: add an iocost_ioc_tick tracepoint emitting the per-period
      controller state, so model quality can be evaluated without
      drgn (existing events are state-change driven and silent in
      steady state)
 2/8: define the iocost_model_ops interface (above); the model is
      called from the IO submission path under RCU and must not
      sleep
 3/8: register the struct_ops; at most one model system-wide (EBUSY),
      registration serialized with a mutex, base helper set allowed
      so models can use maps for per-cgroup state
 4/8: dispatch cost calculation to the registered model in
      calc_vtime_cost(), falling back to the builtin formula; the
      request-level sizing path keeps the builtin formula
 5/8: per-device opt-in via ctrl=bpf
 6/8: selftest with an example model (the builtin linear HDD formula
      at double cost, mirroring bpf_dctcp as the in-tree reference
      implementation) plus a runner verifying registration and
      ctrl=bpf readback, including the rejected-without-model case
 7/8: a second example model which replaces the single-cursor
      sequentiality heuristic with per-cgroup multi-stream detection
      keyed by iocg_id, the first consumer of that argument
 8/8: document ctrl=bpf in cgroup-v2.rst

Does it work
------------

Mechanism, verified functionally (QEMU, virtio-blk with the HDD
profile, same 8s sequential-read workload from a 1%-weight cgroup,
builtin vs the 2x example model):

 - per-IO charge: 2854us -> 5728us, a factor of 2.001-2.007x; the
   completed IO count halves (2634 -> 1332) and total cost.usage is
   conserved (7.51s vs 7.63s of device time), i.e. the model output
   drives both charging and budgeting
 - the same ratio holds across four hosts (local disk, enterprise
   NVMe, NVMe-backed root on an idle k8s master, and a real 7.3T HDD
   behind a loaded host) and across 4k/64k/1M block sizes: 2.00-2.03x
   on the flash-backed hosts, and within 2% of 2x on the real HDD,
   where the host load adds variance
 - edge cases: ctrl=bpf without a registered model is rejected; a
   second registration fails with EBUSY; unregistering the model or
   returning 0 (delegation) both fall back to the builtin price; a
   model using a map keyed by iocg_id records distinct ids per
   cgroup
 - iocost_ioc_tick fires every period in steady state and emits one
   final tick with running=0 before the controller goes idle

Payoff, demonstrated with the multi-stream example model (7/8) on
the same setup, 4k IOs at weight 1000, builtin vs the model:

 - two sequential readers in one cgroup: priced 2064us/op by builtin
   (both judged random by the single cursor) and 23us/op by the model
   (each stream keeps its own slot), a throughput recovery from 7.2
   to 511 MiB/s
 - random IO inside an 8M window: priced 22.9us/op by builtin
   (undercharge, an accounting escape) and 2643us/op by the model
 - single-stream sequential and whole-disk random pricing are
   unchanged, so the model fixes both directions of mispricing
   without introducing a new one

Non-interference, measured on enterprise NVMe (MEMBLAZE P6541,
passthrough to KVM guest, 8 proc x 128k sequential read, 7.5M
aggregate IOPS):

 - no measurable overhead when not in use: builtin vs BPF-patched kernel
   (no model registered) within noise (30180 vs 30314 ops/proc);
   the one indirect call per bio is not measurable at this rate
 - 12-hour stress (870 iterations, 3 cgroups at 1000/100/10 weights,
   read + write + flush concurrent, 87 iocost disable/enable cycles,
   870 model switches): zero errors, zero memory drift (0.03% over
   32GB)

Open questions for discussion:

 1. Interface: scalar args (as here) vs passing struct bio * for
    CO-RE access?  Is a cold-path model_refresh() callback needed so
    models can track vrate?
 2. Per-cgroup state lifetime: iocg_id is the css id and is recycled
    once the cgroup is removed, so models must treat it as a
    transient key.  Does the interface need a release(iocg_id)
    callback so models can clean up per-cgroup state instead of
    detecting reuse, or is per-cgroup bpf local storage, which
    carries its own lifetime, the better home for model state?
 3. Request-level asymmetry: the request-based sizing path
    (calc_size_vtime_cost, which feeds the latency QoS met/missed
    decision) still uses the builtin formula when a model is
    registered, while bio charging goes through the model.  Should
    the request path dispatch too, or is builtin sizing with a BPF
    charge model acceptable?
 4. One model system-wide vs named models selectable per device (as
    tcp-cc names are per-socket)?

Tao Cui (8):
  blk-iocost: add iocost_ioc_tick tracepoint for per-period device
    summary
  blk-iocost: define iocost_model_ops cost model interface
  blk-iocost: implement BPF struct_ops registration
  blk-iocost: dispatch cost calculation to registered BPF model
  blk-iocost: add ctrl=bpf per-device opt-in
  selftests/bpf: add iocost cost model test
  selftests/bpf: add multi-stream sequentiality example model
  docs: cgroup-v2: document io.cost ctrl=bpf option

 Documentation/admin-guide/cgroup-v2.rst       |  16 +-
 block/Kconfig                                 |   9 +
 block/Makefile                                |   1 +
 block/blk-iocost-bpf.c                        | 152 +++++++++++++++++
 block/blk-iocost.c                            |  46 +++++-
 include/linux/blk-iocost.h                    |  56 +++++++
 include/trace/events/iocost.h                 |  40 +++++
 .../selftests/bpf/prog_tests/iocost_model.c   | 155 ++++++++++++++++++
 .../selftests/bpf/progs/iocost_model.c        |  91 ++++++++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 122 ++++++++++++++
 10 files changed, 682 insertions(+), 6 deletions(-)
 create mode 100644 block/blk-iocost-bpf.c
 create mode 100644 include/linux/blk-iocost.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

-- 
2.43.0

