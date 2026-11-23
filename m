Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795410926;
	b=Sp3xgjnfxHuGhTmLP2Ma505fPA7/LLH4U9ot22I3MzZOqisP4btmJ8qrLuNxN7VhNfVH
	 RnsMusXpEf6bGSO7kkvMx3TEfN58yVCg1Pyf7D8+V17N3JH1mirORZNkxgDNu0+8fi/bZ
	 1+eNffqAnME4qt4VtVa6iU2MeKmHgBHQAnP0x3qc41lIyd5oTpa9GTUAPCwWJb+Kb4mM6
	 u166ouEie+KTYS/0unmToW0ZG8XWFjinOKclhm9Gr9SvqwfIsJHG0p6X3yZyc12ESzdXi
	 NvSpBLaQz9R4wxg1ZJRRPpLv4MkXfSfaoxgxixauCGq6NYRzJm2SuzA5EHb6VjezNVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795410926;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:X-CPGS-Detection:X-Drm-Type:X-Msg-Generator:
	 X-Msg-Type:X-Reply-Demand:Message-ID:Date:X-CMS-MailID:
	 Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:CMS-TYPE:
	 X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:
	 References;
	bh=WSL0PpZL8lyfGMXRe4lS1H2Z/npyzNFI+yLAETxkfdc=;
	b=jqe/L3ZVtlYbpocPkaEH3NXWrZPXFHB+CAn4m+rsHkFZxAblmgszwwUehnDA35WCK4dp
	 pnIN/ja/F0eSsTtBLJLbcuaYOKhuRiXn3z9W7cvcxirAfUnaA55Ijq5igrl3SGvrmN/I/
	 n6yHs7vgZI6xOehcVTLx7Lx5RG/CQQC9KjK4BBWAg6n4qAsAwkKIUwd4PEp8mBpj1/LlL
	 emVryMhbx/61bS6ywvK6TxFGhTt7ItJj3i6ffSK3YtFRjRGujJjW5n1xKiKNRhugibbq5
	 uQVePVX2Rmct93K4TAR2tF3oipVzhT0NMYdCLqQzGSuhWfRO9sszku3AdM5gC7pPMqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=r7oURB1C;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF65606A31F
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 05:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DF65606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=r7oURB1C
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261123051523epoutp03796027da0d7c9dbd0e931b44c7782ad2~qlLjdcqOo1801518015epoutp03J
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 05:15:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261123051523epoutp03796027da0d7c9dbd0e931b44c7782ad2~qlLjdcqOo1801518015epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795410923;
	bh=WSL0PpZL8lyfGMXRe4lS1H2Z/npyzNFI+yLAETxkfdc=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=r7oURB1C2V+r6jMr4yC2MblTgHGpr1zjpAIf3QzRNOG93I/GxVvHGmXuEW2JyrieL
	 YH9oMAkZ3kAroF2hPOiOgvW4SDgfh7zLuWlr9B/tmLSc15goHva0Eh9y+1db/7SwGH
	 mD5EemUIJu5n4bIs7/kQGayNJ2rHeyKWqe57GWNg=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261123051522epcas2p32103811faa2a1f97ae61ecd4bee71c7e~qlLi-s1GR2060120601epcas2p3E;
	Mon, 23 Nov 2026 05:15:22 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.206]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jXvK62QJKz6B9mK; Mon, 23 Nov
	2026 05:15:22 +0000 (GMT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: [RFC PATCH RESEND 0/3] block: cgroup-based and explicit write
 stream placement for NVMe FDP
Reply-To: suho.son@samsung.com
Sender: Suho Son <suho.son@samsung.com>
From: Suho Son <suho.son@samsung.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
CC: "tj@kernel.org" <tj@kernel.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "mkoutny@suse.com" <mkoutny@suse.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "skhan@linuxfoundation.org"
	<skhan@linuxfoundation.org>, "rdunlap@infradead.org"
	<rdunlap@infradead.org>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "ngeol564@gmail.com" <ngeol564@gmail.com>,
	KiYoung Lee <kiyoung77.lee@samsung.com>, JinHeon Kim
	<jinheon09.kim@samsung.com>, Suho Son <suho.son@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p2>
Date: Mon, 23 Nov 2026 14:15:21 +0900
X-CMS-MailID: 20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e
References: <CGME20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p2>

Hello,

Resending: my earlier posting of this cover letter went out without
the patches threaded to it.  Sorry for the noise.

This RFC proposes an operator- and application-controlled write stream
interface on top of the existing write stream plumbing
(sqe->write_stream, bio->bi_write_stream, and the NVMe FDP placement
translation, which are unchanged by this series):

  1/3 block: distinguish unspecified and explicit device-default write streams
  2/3 io_uring: add IORING_WRITE_STREAM_DEFAULT for explicit device-default placement
  3/3 blk-cgroup: add cgroup-based write stream placement

The series is based on the block tree's for-next branch (see the
base-commit below).

Motivation and background are described in our HotStorage '26 paper:

  Link: https://doi.org/10.1145/3837053.3837343

Motivation

NVMe Flexible Data Placement reduces write amplification by grouping
similarly-aged data into per-reclaim-unit placement handles, and the
kernel already lets a single application tag writes through io_uring.
Two gaps remain:

  (a) an operator cannot place whole workloads per cgroup without
      modifying applications, and
  (b) an application cannot force the device-default placement and be
      sure that no policy overrides that choice.

The series addresses the root cause shared by both: write stream zero
currently means both "unspecified" and "device default", so lower-
precedence producers cannot tell whether a stream was requested.  The
resulting precedence, most specific first, is:

  explicit io_uring stream (including DEFAULT)
    > inode write hint
    > cgroup io.stream
    > device default (0)

Patch 1 introduces the WRITE_STREAM_NONE sentinel for unspecified
streams, resolves it centrally before the bio reaches the driver, and
carries ki_write_stream through kiocb_clone() used by forwarded direct
I/O.  Patch 2 adds the explicit-default UAPI value, decided at prep
time so it survives async re-issues.  Patch 3 adds the io.stream cgroup
v2 interface: per-device upsert entries, "inherit" reset, explicit 0,
validation against device queue limits, lazy policy activation, and a
single-word policy state read locklessly under RCU, with writers
serialized by the queue lock held across blkg_conf_prep().

Runtime verification

We exercised the series, as posted, on an NVMe 2.0 FDP device (8 RUHs)
with bpftrace observers at blkcg_set_iostream() entry/return,
__submit_bio() and the nvme_setup_cmd() dsmgmt export:

  - explicit streams 2/5/8 -> placement IDs 1/4/7 (tracepoint-verified)
  - IORING_WRITE_STREAM_DEFAULT -> concrete 0, no placement exported,
    not overridable by an io.stream policy
  - stream > max_write_streams -> -EINVAL, no bio issued
  - io.stream explicit value observed end-to-end; nested cgroup
    inherits the parent's entry; explicit io.stream 0 resolves the
    sentinel to 0
  - io.stream rejects streams above the device limit and the reserved
    255 with -EINVAL, and devices without write streams with
    -EOPNOTSUPP; the root cgroup has no io.stream file
  - the inode write hint beats the io.stream value, as documented
  - IOSQE_ASYNC: an explicit stream, IORING_WRITE_STREAM_DEFAULT and
    the submitting task's cgroup association all survive io-wq
    deferral
  - a 512K direct write splits into multiple bios; all keep the stream
  - 64 concurrent writers with a common stream: 64/64 tagged, stable,
    no warnings
  - buffered writeback on a mounted ext4: writeback bios adopt the
    first-dirtying cgroup via wbc_init_bio() and carry the resulting
    placement ID to the device; the nested cgroup inherits the
    parent's entry, explicit 0 and the child's own entry override it,
    and "inherit" restores the parent's value

Each patch builds without warnings at W=1, with
CONFIG_BLK_CGROUP_IOSTREAM both enabled and disabled.

Not yet verified (please treat accordingly)

  - WAF improvements on a production multi-tenant workload are not yet
    measured; device-level fdp status counters moved consistently with
    the placement IDs, but per-case deltas were below the background
    noise of the test setup

RFC aspects we would like feedback on

  - the API shape of io.stream (per-device "MAJ:MIN <stream>" string,
    upsert and inherit semantics, explicit 0 as a real entry)
  - the WRITE_STREAM_NONE sentinel as a u8 reservation, which caps
    addressable streams at 254 through the io_uring interface and
    excludes 255 from io.stream
  - whether io.stream belongs in io.* under cgroup v2, and its
    interaction with the existing io controller file hierarchy
  - buffered writeback semantics: attribution to the writeback owner is
    arguably what an operator wants, but degenerate share cases deserve
    a second opinion

No MAINTAINERS update is needed: block/ is covered by the BLOCK LAYER
entry, and the io_uring paths by the IO_URING entry.

Tool use

This series was developed with substantial help from LLM coding
assistants, in an interactive session rather than from a single prompt.
The assistant drafted a large part of the implementation (the
WRITE_STREAM_NONE sentinel and its central resolution, the fops.c
precedence rework, the kiocb_clone() propagation, and the io.stream
single-word policy state and its RCU lifetime), the changelogs, the
cgroup-v2.rst section and this cover letter.  It also wrote the
io_uring and bpftrace test harnesses used for the runtime verification
above, and rebased the series onto the current tree.  I made the design
decisions, directed and reviewed the testing, and reviewed, revised and
take responsibility for all of the code and text.

Suho Son (3):
  block: distinguish unspecified and explicit device-default write
    streams
  io_uring: add IORING_WRITE_STREAM_DEFAULT for explicit device-default
    placement
  blk-cgroup: add cgroup-based write stream placement

 Documentation/admin-guide/cgroup-v2.rst |  58 ++++-
 block/Kconfig                           |  16 ++
 block/Makefile                          |   1 +
 block/bio.c                             |   3 +-
 block/blk-core.c                        |  14 ++
 block/blk-iostream.c                    | 315 ++++++++++++++++++++++++
 block/blk-iostream.h                    |  18 ++
 block/fops.c                            |  25 +-
 include/linux/blk_types.h               |  13 +
 include/linux/fs.h                      |  11 +-
 include/linux/io_uring_types.h          |   4 +
 include/uapi/linux/io_uring.h           |  26 ++
 io_uring/rw.c                           |  16 ++
 13 files changed, 510 insertions(+), 10 deletions(-)
 create mode 100644 block/blk-iostream.c
 create mode 100644 block/blk-iostream.h


base-commit: d09b6d9d1fcce0770c1824c8b2b8ab153f2672d2
-- 
2.43.0

