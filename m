From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [patch v11 0/6] support concurrent sync io for bfq on a specail
 occasion
Date: Tue, 27 Sep 2022 18:38:18 +0200
Message-ID: <29348B39-94AE-4D76-BD2E-B759056264B6@linaro.org>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=F2goyNpyd3IXhayCEGATlVULW4jrbgSh4ZPgZuwoLUY=;
        b=VufMgnwF8XYZxQrCy+h78oyt/89LDSA/P6+xgdHgQp1Jb1Wn+VwztMpPMIP+EK7F22
         s4v39KDbH5rzEXL0glxq9/BuT9m75v0rHl9dCqBy1alkRvgh4wfDE3AaQ1Ygw6IvtWB3
         476zV6duj7KCxwM3Nj2ABXwvPaitFT+jH81XWw/ZVH5JzYgv8nwJesdqsWYhNK5YliG4
         8BwhvRCtAAwPf5djmV6BSTu3/+qORqY0uB9d/qGU429lJk/8XRkUAInHp7DE50h+lymT
         Q5WnKLOMZVHwiMfS5IWtQ5g/R9yAMp8MXt5AI+1yiOlck0dY7NXhVTYub2iTFGgRwrxs
         nt9g==
In-Reply-To: <20220916071942.214222-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



> Il giorno 16 set 2022, alle ore 09:19, Yu Kuai =
<yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org> ha scritto:
>=20
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Changes in v11:
> - keep the comments in bfq_weights_tree_remove() and move it to the
> caller where bfqq can be freed.
> - add two followed up cleanup patches.
>=20
> Changes in v10:
> - Add reviewed-tag for patch 2
>=20
> Changes in v9:
> - also update how many bfqqs have pending_reqs bfq_bfqq_move().
> - fix one language in patch 4
> - Add reviewed-tag for patch 1,3,4
>=20
> Changes in v8:
> - Instead of using whether bfqq is busy, using whether bfqq has =
pending
> requests. As Paolo pointed out the former way is problematic.
>=20
> Changes in v7:
> - fix mismatch bfq_inc/del_busy_queues() and bfqq_add/del_bfqq_busy(),
> also retest this patchset on v5.18 to make sure functionality is
> correct.
> - move the updating of 'bfqd->busy_queues' into new apis
>=20
> Changes in v6:
> - add reviewed-by tag for patch 1
>=20
> Changes in v5:
> - rename bfq_add_busy_queues() to bfq_inc_busy_queues() in patch 1
> - fix wrong definition in patch 1
> - fix spelling mistake in patch 2: leaset -> least
> - update comments in patch 3
> - add reviewed-by tag in patch 2,3
>=20
> Changes in v4:
> - split bfq_update_busy_queues() to bfq_add/dec_busy_queues(),
>   suggested by Jan Kara.
> - remove unused 'in_groups_with_pending_reqs',
>=20
> Changes in v3:
> - remove the cleanup patch that is irrelevant now(I'll post it
>   separately).
> - instead of hacking wr queues and using weights tree =
insertion/removal,
>   using bfq_add/del_bfqq_busy() to count the number of groups
>   (suggested by Jan Kara).
>=20
> Changes in v2:
> - Use a different approch to count root group, which is much simple.
>=20
> Currently, bfq can't handle sync io concurrently as long as they
> are not issued from root group. This is because
> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
> bfq_asymmetric_scenario().
>=20
> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>=20
> Before this patchset:
> 1) root group will never be counted.
> 2) Count if bfqg or it's child bfqgs have pending requests.
> 3) Don't count if bfqg and it's child bfqgs complete all the requests.
>=20
> After this patchset:
> 1) root group is counted.
> 2) Count if bfqg has pending requests.
> 3) Don't count if bfqg complete all the requests.
>=20
> With the above changes, concurrent sync io can be supported if only
> one group is activated.
>=20
> fio test script(startdelay is used to avoid queue merging):
> [global]
> filename=3D/dev/sda
> allow_mounted_write=3D0
> ioengine=3Dpsync
> direct=3D1
> ioscheduler=3Dbfq
> offset_increment=3D10g
> group_reporting
> rw=3Drandwrite
> bs=3D4k
>=20
> [test1]
> numjobs=3D1
>=20
> [test2]
> startdelay=3D1
> numjobs=3D1
>=20
> [test3]
> startdelay=3D2
> numjobs=3D1
>=20
> [test4]
> startdelay=3D3
> numjobs=3D1
>=20
> [test5]
> startdelay=3D4
> numjobs=3D1
>=20
> [test6]
> startdelay=3D5
> numjobs=3D1
>=20
> [test7]
> startdelay=3D6
> numjobs=3D1
>=20
> [test8]
> startdelay=3D7
> numjobs=3D1
>=20
> test result:
> running fio on root cgroup
> v5.18:	   112 Mib/s
> v5.18-patched: 112 Mib/s
>=20
> running fio on non-root cgroup
> v5.18:	   51.2 Mib/s
> v5.18-patched: 112 Mib/s
>=20
> Note that I also test null_blk with "irqmode=3D2
> completion_nsec=3D100000000(100ms) hw_queue_depth=3D1", and tests show
> that service guarantees are still preserved.
>=20

Your patches seem ok to me now (thanks for you contribution and, above =
all, for your patience). I have only a high-level concern: what do you =
mean when you say that service guarantees are still preserved? What test =
did you run exactly? This point is very important to me. I'd like to see =
some convincing test with differentiated weights. In case you don't have =
other tools for executing such tests quickly, you may want to use the =
bandwidth-latency test in my simple S benchmark suite (for which I'm =
willing to help).

Thanks,
Paolo

> Previous versions:
> RFC: =
https://lore.kernel.org/all/20211127101132.486806-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v1: =
https://lore.kernel.org/all/20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v2: =
https://lore.kernel.org/all/20220416093753.3054696-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v3: =
https://lore.kernel.org/all/20220427124722.48465-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v4: =
https://lore.kernel.org/all/20220428111907.3635820-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v5: =
https://lore.kernel.org/all/20220428120837.3737765-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v6: =
https://lore.kernel.org/all/20220523131818.2798712-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v7: =
https://lore.kernel.org/all/20220528095020.186970-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
>=20
>=20
> Yu Kuai (6):
>  block, bfq: support to track if bfqq has pending requests
>  block, bfq: record how many queues have pending requests
>  block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
>  block, bfq: do not idle if only one group is activated
>  block, bfq: cleanup bfq_weights_tree add/remove apis
>  block, bfq: cleanup __bfq_weights_tree_remove()
>=20
> block/bfq-cgroup.c  | 10 +++++++
> block/bfq-iosched.c | 71 +++++++--------------------------------------
> block/bfq-iosched.h | 30 +++++++++----------
> block/bfq-wf2q.c    | 69 ++++++++++++++++++++++++++-----------------
> 4 files changed, 76 insertions(+), 104 deletions(-)
>=20
> --=20
> 2.31.1
>=20

