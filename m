From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH V2 00/10] unify the interface of the proportional-share policy in blkio/io
Date: Mon, 19 Nov 2018 11:34:14 +0100
Message-ID: <20181119103424.3853-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=iL05uSSIvpNAEkXjPa4LLsPBFMnCpnvcdfAc7Vp2A5U=;
        b=J2hxaN5CgQwX3XH/86Da0A57BLs8NYJ8juPTSrnowTgszBdtNhDye09DYxM78q2BE+
         +ZHxy5iCAg9M4JKk1wT00JAcjorZhunK9l42+pYRJuPsgH6GZFCS5IXb0Hy8SVdgc/Mk
         SD9HgD6PUDRerWtSHLriKPYP1sBOyjQxUVX0o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

Hi,
here is the V2 of this patch series. Let me rephrase the description
of the series, in view of the fact that CFQ will be gone with legacy
block.

The current implementation of cgroups doesn't allow two or more
entities, e.g., I/O schedulers, to share the same files.  Thus, to
enable people to set group weights with BFQ, I resorted to making BFQ
create its own version of the same interface files used by CFQ (before
going away with legacy block), by prepending a bfq prefix.

Actually, no legacy code uses these different names, or is likely to
do so.  Having these two sets of names is simply a source of
confusion, as pointed out also, e.g., by Lennart Poettering (CCed
here), and acknowledged by Tejun [2].

In [1] we agreed on a solution that solves this problem, by actually
making it possible to share cgroups files.  Both writing to and
reading from a shared file trigger the appropriate operation for each
of the entities that share the file.  In particular, in case of
reading,
- if all entities produce the same output, the this common output is
 shown only once;
- if the outputs differ, then every per-entity output is shown,
 followed by the name of the entity that produced that output.

With this solution, legacy code that, e.g., sets group weights, just
works, regardless of the I/O scheduler actually implementing
proportional share.

But note that this extension is not restricted to only blkio/io.  The
general group interface now enables files to be shared among multiple
entities of any kind.

(I have also added a patch to fix some clerical errors in bfq doc,
which I found while making the latter consistent with the new
interface.)

CHANGES FROM V1:
- Removed patch that introduced a function to only find kernfs nodes,
  without increasing ref counters
- Changed commit messages and BFQ documentation, to comply with the
  fact that there won't be CFQ any longer

Thanks,
Paolo

Angelo Ruocco (5):
  cgroup: link cftypes of the same subsystem with the same name
  cgroup: add owner name to cftypes
  block, bfq: align min and default weights with the old cfq default
  cgroup: make all functions of all cftypes be invoked
  block, throttle: allow sharing cgroup statistic files

Paolo Valente (5):
  cgroup: add hook seq_show_cft with also the owning cftype as parameter
  block, cgroup: pass cftype to functions that need to use it
  block, bfq: use standard file names for the proportional-share policy
  doc, bfq-iosched: fix a few clerical errors
  doc, bfq-iosched: make it consistent with the new cgroup interface

 Documentation/block/bfq-iosched.txt |  34 ++---
 block/bfq-cgroup.c                  | 148 +++++++++++++-------
 block/bfq-iosched.h                 |   4 +-
 block/blk-cgroup.c                  |  22 +--
 block/blk-throttle.c                |  24 ++--
 include/linux/blk-cgroup.h          |  10 +-
 include/linux/cgroup-defs.h         |  14 +-
 include/linux/cgroup.h              |  13 ++
 kernel/cgroup/cgroup.c              | 262 +++++++++++++++++++++++++++++-------
 9 files changed, 390 insertions(+), 141 deletions(-)

--
2.16.1
