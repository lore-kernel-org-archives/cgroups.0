From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Mon, 12 Nov 2018 10:58:29 +0100
Message-ID: <A25880F5-BA4E-4BF3-8AD2-1AB528551FC0@linaro.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9fSKAzP9ruRBEA1MT9Z13pRnkDRt7j8j4EnmxP10Ums=;
        b=PCZFuQEnWqBGooqnIOMnX/hRrLxg2cS/5rByMG9iV8msjbZWdJqOweg452LQc/NV+n
         IDjltLKRCB3UVBn8nvUqb5TsYJ+U2sGuvj1BPAYLWwg1H/iZLkatkttOs5E+ukee07H4
         QMcdsTA6dgj2iuYNuC16+mA852flmhuC3Kf1c=
In-Reply-To: <20181112095632.69114-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, lennart@poettering.net

Forgot to CC Lennart, sorry.

> Il giorno 12 nov 2018, alle ore 10:56, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
> Hi Jens, Tejun, all,
> about nine months ago, we agreed on a solution for unifying the
> interface of the proportional-share policy in blkio/io [1].  Angelo
> and I finally completed it.  Let me briefly recall the problem and the
> solution.
>=20
> The current implementation of cgroups doesn't allow two or more
> entities, e.g., I/O schedulers, to share the same files.  So, if CFQ
> creates its files for the proportional-share policy, such as, e.g,
> weight files for blkio/io groups, BFQ cannot attach somehow to them.
> Thus, to enable people to set group weights with BFQ, I resorted to
> making BFQ create its own version of these common files, by prepending
> a bfq prefix.
>=20
> Actually, no legacy code uses these different names, or is likely to
> do so.  Having these two sets of names is simply a source of
> confusion, as pointed out also, e.g., by Lennart Poettering (CCed
> here), and acknowledged by Tejun [2].
>=20
> In [1] we agreed on a solution that solves this problem, by actually
> making it possible to share cgroups files.  Both writing to and
> reading from a shared file trigger the appropriate operation for each
> of the entities that share the file.  In particular, in case of
> reading,
> - if all entities produce the same output, the this common output is
>  shown only once;
> - if the outputs differ, then every per-entity output is shown,
>  preceded by the name of the entity that produced that output.
>=20
> With this solution, legacy code that, e.g., sets group weights, just
> works, regardless of the I/O scheduler actually implementing
> proportional share.
>=20
> But note that this extension is not restricted to only blkio/io.  The
> general group interface now enables files to be shared among multiple
> entities of any kind.
>=20
> (I have also added a patch to fix some clerical errors in bfq doc,
> which I found while making the latter consistent with the new
> interface.)
>=20
> Thanks,
> Paolo
>=20
> [1] https://lkml.org/lkml/2018/1/4/667
> [2] https://github.com/systemd/systemd/issues/7057
>=20
> Angelo Ruocco (7):
>  kernfs: add function to find kernfs_node without increasing ref
>    counter
>  cgroup: link cftypes of the same subsystem with the same name
>  cgroup: add owner name to cftypes
>  block, bfq: align min and default weights with cfq
>  cgroup: make all functions of all cftypes be invoked
>  block, cfq: allow cgroup files to be shared
>  block, throttle: allow sharing cgroup statistic files
>=20
> Paolo Valente (5):
>  cgroup: add hook seq_show_cft with also the owning cftype as =
parameter
>  block, cgroup: pass cftype to functions that need to use it
>  block, bfq: use standard file names for the proportional-share policy
>  doc, bfq-iosched: fix a few clerical errors
>  doc, bfq-iosched: make it consistent with the new cgroup interface
>=20
> Documentation/block/bfq-iosched.txt |  31 +++--
> block/bfq-cgroup.c                  | 148 +++++++++++++-------
> block/bfq-iosched.h                 |   4 +-
> block/blk-cgroup.c                  |  22 +--
> block/blk-throttle.c                |  24 ++--
> block/cfq-iosched.c                 | 105 +++++++++++----
> fs/kernfs/dir.c                     |  13 ++
> include/linux/blk-cgroup.h          |  10 +-
> include/linux/cgroup-defs.h         |  14 +-
> include/linux/cgroup.h              |  13 ++
> include/linux/kernfs.h              |   7 +
> kernel/cgroup/cgroup.c              | 262 =
+++++++++++++++++++++++++++++-------
> 12 files changed, 483 insertions(+), 170 deletions(-)
>=20
> --
> 2.16.1

