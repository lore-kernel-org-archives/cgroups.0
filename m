From: Angelo Ruocco <angelo.ruocco.90@gmail.com>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Thu, 15 Nov 2018 12:54:06 +0100
Message-ID: <CADiTV-37tqWsbxmeZJsqq+pqSqxN-_L9+T9R+PmBBJhfO-G09g@mail.gmail.com>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <9e8adb3271680165d85994a225713391@natalenko.name> <E8A20452-A73C-4A31-B5EC-48EFB9937832@linaro.org>
 <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ne/gKok03c+t2wIlYobLMtqWA8EHB+C5F4esFvKV5fg=;
        b=s4MXEazTgXrCHOtZb7+ZK74ej4S7kBY7cLcqPnZumsPRJEz2Gt84zay4HCqQuXaz8K
         cNyXegpmc96lihXX5GnpzWC0arwQJOhWN371ttpS0w69Nz6svPAkp8G13SXTfssxm2J9
         y/9l2qWUrudzs/xQlghRQWEjhLu3R25FUDEV/z58SIWsf9GnhOYiJB7w2+DBoJKG1UQl
         Ase1az+Qv+d5yPPRF5py3lrHoifMyI3lRIQ6fITlu1epHcV+UrtWIImd9fC/i2xCrTh3
         n+oigf3pD21kO3a1CcTpLvCCXnDq2wHnI+x/shj/EVkNx6u/G8ThncKe4O/DQXlWRpub
         IQ7w==
In-Reply-To: <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbe>

Hi Jens,

I have rebased the patchset against the for-4.21/block branch, but I
can't test them properly because the compiling process has an error on
a different file. In particular:

include/net/xfrm.h:1465:3 error: unknown type 'spruct'
include/net/xfrm.h:1465:30 error: expected ':', ',', ';', '}' or
'__attribute__' before 'auth'

To be clear, and so that you can check I haven't made some trivial
mistakes: I have added/fetched the remote [1] and then simply rebased
against the for-4.21/block branch.

[1] git://git.kernel.dk/linux-block

Angelo

2018-11-12 16:35 GMT+01:00, Jens Axboe <axboe@kernel.dk>:
> On 11/12/18 3:17 AM, Paolo Valente wrote:
>>
>>
>>> Il giorno 12 nov 2018, alle ore 11:00, Oleksandr Natalenko
>>> <oleksandr@natalenko.name> ha scritto:
>>>
>>> On 12.11.2018 10:56, Paolo Valente wrote:
>>>> Hi Jens, Tejun, all,
>>>> about nine months ago, we agreed on a solution for unifying the
>>>> interface of the proportional-share policy in blkio/io [1].  Angelo
>>>> and I finally completed it.  Let me briefly recall the problem and the
>>>> solution.
>>>> The current implementation of cgroups doesn't allow two or more
>>>> entities, e.g., I/O schedulers, to share the same files.  So, if CFQ
>>>> creates its files for the proportional-share policy, such as, e.g,
>>>> weight files for blkio/io groups, BFQ cannot attach somehow to them.
>>>> Thus, to enable people to set group weights with BFQ, I resorted to
>>>> making BFQ create its own version of these common files, by prepending
>>>> a bfq prefix.
>>>> Actually, no legacy code uses these different names, or is likely to
>>>> do so.  Having these two sets of names is simply a source of
>>>> confusion, as pointed out also, e.g., by Lennart Poettering (CCed
>>>> here), and acknowledged by Tejun [2].
>>>> In [1] we agreed on a solution that solves this problem, by actually
>>>> making it possible to share cgroups files.  Both writing to and
>>>> reading from a shared file trigger the appropriate operation for each
>>>> of the entities that share the file.  In particular, in case of
>>>> reading,
>>>> - if all entities produce the same output, the this common output is
>>>>  shown only once;
>>>> - if the outputs differ, then every per-entity output is shown,
>>>>  preceded by the name of the entity that produced that output.
>>>> With this solution, legacy code that, e.g., sets group weights, just
>>>> works, regardless of the I/O scheduler actually implementing
>>>> proportional share.
>>>> But note that this extension is not restricted to only blkio/io.  The
>>>> general group interface now enables files to be shared among multiple
>>>> entities of any kind.
>>>> (I have also added a patch to fix some clerical errors in bfq doc,
>>>> which I found while making the latter consistent with the new
>>>> interface.)
>>>> Thanks,
>>>> Paolo
>>>> [1] https://lkml.org/lkml/2018/1/4/667
>>>> [2] https://github.com/systemd/systemd/issues/7057
>>>> Angelo Ruocco (7):
>>>>  kernfs: add function to find kernfs_node without increasing ref
>>>>    counter
>>>>  cgroup: link cftypes of the same subsystem with the same name
>>>>  cgroup: add owner name to cftypes
>>>>  block, bfq: align min and default weights with cfq
>>>>  cgroup: make all functions of all cftypes be invoked
>>>>  block, cfq: allow cgroup files to be shared
>>>>  block, throttle: allow sharing cgroup statistic files
>>>> Paolo Valente (5):
>>>>  cgroup: add hook seq_show_cft with also the owning cftype as paramete=
r
>>>>  block, cgroup: pass cftype to functions that need to use it
>>>>  block, bfq: use standard file names for the proportional-share policy
>>>>  doc, bfq-iosched: fix a few clerical errors
>>>>  doc, bfq-iosched: make it consistent with the new cgroup interface
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
>>>> kernel/cgroup/cgroup.c              | 262
>>>> +++++++++++++++++++++++++++++-------
>>>> 12 files changed, 483 insertions(+), 170 deletions(-)
>>>> --
>>>> 2.16.1
>>>
>>> I thought all the legacy stuff including CFS et al. is going to be
>>> removed in v4.21 completely=E2=80=A6
>>>
>>
>> Thanks for pointing this out.
>>
>> People with a lower kernel version than the future 4.21 just cannot
>> and will not be able to use the proportional share policy on blk-mq
>> (with legacy code), because of the name issue highlighted in this
>> email.  If this patch series gets accepted, a backport will solve the
>> problem.  In this respect, such a backport might even happen
>> 'automatically', as most bfq commit seem to get backported to older,
>> stable kernels.
>>
>> In addition, this extension
>> - extends the whole cgroups interface, in a seamless and
>>   backward-compatible way, to prevent future issues like these;
>> - solves a similar issue with throttle (which AFAIK won't go away
>>   with 4.21).
>
> There's no way this series can get accepted, since you've made the
> mistake of basing it on something that won't apply to the block
> tree for 4.21. I've outlined these rules before, but here they are
> again:
>
> 1) Patches destined for the CURRENT kernel version should be
>    against my for-linus branch. That means that right now, any
>    patches that should to into 4.20 should be against that.
>
> 2) Patches destined for the NEXT kernel version should be against
>    my for-x.y/block branch, where x.y is the next version. As of
>    right now, patches for 4.21 should be against my for-4.21/bloc
>    branch.
>
> I'd encourage you to respin against that, particularly in this case
> since we've both got a lot of churn, and also removal of various
> items that you are patching here.
>
> --
> Jens Axboe
>
>
