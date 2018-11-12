From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Mon, 12 Nov 2018 16:45:39 +0100
Message-ID: <F0F86365-D4EC-43F0-AE13-CC8FA6CC3D97@linaro.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <9e8adb3271680165d85994a225713391@natalenko.name>
 <E8A20452-A73C-4A31-B5EC-48EFB9937832@linaro.org>
 <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk>
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=55QFRFUvRfh4s8lMP72i9VKG2NQo1PeSCd4v8X03l1s=;
        b=Cg+/tbgLzq+Uzkg938noZNEn1LCD9sJAXkKZzsiYc3p5RBkX1/4CymIcshUSS5TVv2
         7cKLMZlI5570npRbXvEvNjW6QnsVX/7/PNhw8p93VM1bRFqC2gHpRvbzpRKLXaS86brd
         sErHlyh9WhcMfyPj/w7ARhrTbOA7e43VTqCyA=
In-Reply-To: <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jens Axboe <axboe@kernel.dk>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, lennart@poettering.net



> Il giorno 12 nov 2018, alle ore 16:35, Jens Axboe <axboe@kernel.dk> ha =
scritto:
>=20
> On 11/12/18 3:17 AM, Paolo Valente wrote:
>>=20
>>=20
>>> Il giorno 12 nov 2018, alle ore 11:00, Oleksandr Natalenko =
<oleksandr@natalenko.name> ha scritto:
>>>=20
>>> On 12.11.2018 10:56, Paolo Valente wrote:
>>>> Hi Jens, Tejun, all,
>>>> about nine months ago, we agreed on a solution for unifying the
>>>> interface of the proportional-share policy in blkio/io [1].  Angelo
>>>> and I finally completed it.  Let me briefly recall the problem and =
the
>>>> solution.
>>>> The current implementation of cgroups doesn't allow two or more
>>>> entities, e.g., I/O schedulers, to share the same files.  So, if =
CFQ
>>>> creates its files for the proportional-share policy, such as, e.g,
>>>> weight files for blkio/io groups, BFQ cannot attach somehow to =
them.
>>>> Thus, to enable people to set group weights with BFQ, I resorted to
>>>> making BFQ create its own version of these common files, by =
prepending
>>>> a bfq prefix.
>>>> Actually, no legacy code uses these different names, or is likely =
to
>>>> do so.  Having these two sets of names is simply a source of
>>>> confusion, as pointed out also, e.g., by Lennart Poettering (CCed
>>>> here), and acknowledged by Tejun [2].
>>>> In [1] we agreed on a solution that solves this problem, by =
actually
>>>> making it possible to share cgroups files.  Both writing to and
>>>> reading from a shared file trigger the appropriate operation for =
each
>>>> of the entities that share the file.  In particular, in case of
>>>> reading,
>>>> - if all entities produce the same output, the this common output =
is
>>>> shown only once;
>>>> - if the outputs differ, then every per-entity output is shown,
>>>> preceded by the name of the entity that produced that output.
>>>> With this solution, legacy code that, e.g., sets group weights, =
just
>>>> works, regardless of the I/O scheduler actually implementing
>>>> proportional share.
>>>> But note that this extension is not restricted to only blkio/io.  =
The
>>>> general group interface now enables files to be shared among =
multiple
>>>> entities of any kind.
>>>> (I have also added a patch to fix some clerical errors in bfq doc,
>>>> which I found while making the latter consistent with the new
>>>> interface.)
>>>> Thanks,
>>>> Paolo
>>>> [1] https://lkml.org/lkml/2018/1/4/667
>>>> [2] https://github.com/systemd/systemd/issues/7057
>>>> Angelo Ruocco (7):
>>>> kernfs: add function to find kernfs_node without increasing ref
>>>>   counter
>>>> cgroup: link cftypes of the same subsystem with the same name
>>>> cgroup: add owner name to cftypes
>>>> block, bfq: align min and default weights with cfq
>>>> cgroup: make all functions of all cftypes be invoked
>>>> block, cfq: allow cgroup files to be shared
>>>> block, throttle: allow sharing cgroup statistic files
>>>> Paolo Valente (5):
>>>> cgroup: add hook seq_show_cft with also the owning cftype as =
parameter
>>>> block, cgroup: pass cftype to functions that need to use it
>>>> block, bfq: use standard file names for the proportional-share =
policy
>>>> doc, bfq-iosched: fix a few clerical errors
>>>> doc, bfq-iosched: make it consistent with the new cgroup interface
>>>> Documentation/block/bfq-iosched.txt |  31 +++--
>>>> block/bfq-cgroup.c                  | 148 +++++++++++++-------
>>>> block/bfq-iosched.h                 |   4 +-
>>>> block/blk-cgroup.c                  |  22 +--
>>>> block/blk-throttle.c                |  24 ++--
>>>> block/cfq-iosched.c                 | 105 +++++++++++----
>>>> fs/kernfs/dir.c                     |  13 ++
>>>> include/linux/blk-cgroup.h          |  10 +-
>>>> include/linux/cgroup-defs.h         |  14 +-
>>>> include/linux/cgroup.h              |  13 ++
>>>> include/linux/kernfs.h              |   7 +
>>>> kernel/cgroup/cgroup.c              | 262 =
+++++++++++++++++++++++++++++-------
>>>> 12 files changed, 483 insertions(+), 170 deletions(-)
>>>> --
>>>> 2.16.1
>>>=20
>>> I thought all the legacy stuff including CFS et al. is going to be =
removed in v4.21 completely=E2=80=A6
>>>=20
>>=20
>> Thanks for pointing this out.
>>=20
>> People with a lower kernel version than the future 4.21 just cannot
>> and will not be able to use the proportional share policy on blk-mq
>> (with legacy code), because of the name issue highlighted in this
>> email.  If this patch series gets accepted, a backport will solve the
>> problem.  In this respect, such a backport might even happen
>> 'automatically', as most bfq commit seem to get backported to older,
>> stable kernels.
>>=20
>> In addition, this extension
>> - extends the whole cgroups interface, in a seamless and
>>  backward-compatible way, to prevent future issues like these;
>> - solves a similar issue with throttle (which AFAIK won't go away
>>  with 4.21).
>=20
> There's no way this series can get accepted, since you've made the
> mistake of basing it on something that won't apply to the block
> tree for 4.21.

Of course, sorry :(

We'll rebase V2.

BTW, since this patch series is probably even more useful for older
than for future kernels, might it make sense to also propose it for
stable/longterm kernels (provided that such a possibility exists)?

Thanks,
Paolo

> I've outlined these rules before, but here they are
> again:
>=20
> 1) Patches destined for the CURRENT kernel version should be
>   against my for-linus branch. That means that right now, any
>   patches that should to into 4.20 should be against that.
>=20
> 2) Patches destined for the NEXT kernel version should be against
>   my for-x.y/block branch, where x.y is the next version. As of
>   right now, patches for 4.21 should be against my for-4.21/bloc
>   branch.
>=20
> I'd encourage you to respin against that, particularly in this case
> since we've both got a lot of churn, and also removal of various
> items that you are patching here.
>=20
> --=20
> Jens Axboe

