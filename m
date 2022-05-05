From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v5 0/3] support concurrent sync io for bfq on a
 specail occasion
Date: Thu, 5 May 2022 09:00:42 +0800
Message-ID: <d50df657-d859-79cf-c292-412eaa383d2c@huawei.com>
References: <20220428120837.3737765-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220428120837.3737765-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi, Paolo

Can you take a look at this patchset? It has been quite a long time
since we spotted this problem...

Thanks,
Kuai

=D4=DA 2022/04/28 20:08, Yu Kuai =D0=B4=B5=C0:
> Changes in v5:
>   - rename bfq_add_busy_queues() to bfq_inc_busy_queues() in patch 1
>   - fix wrong definition in patch 1
>   - fix spelling mistake in patch 2: leaset -> least
>   - update comments in patch 3
>   - add reviewed-by tag in patch 2,3
>=20
> Changes in v4:
>   - split bfq_update_busy_queues() to bfq_add/dec_busy_queues(),
>     suggested by Jan Kara.
>   - remove unused 'in_groups_with_pending_reqs',
>=20
> Changes in v3:
>   - remove the cleanup patch that is irrelevant now(I'll post it
>     separately).
>   - instead of hacking wr queues and using weights tree insertion/removal,
>     using bfq_add/del_bfqq_busy() to count the number of groups
>     (suggested by Jan Kara).
>=20
> Changes in v2:
>   - Use a different approch to count root group, which is much simple.
>=20
> Currently, bfq can't handle sync io concurrently as long as they
> are not issued from root group. This is because
> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
> bfq_asymmetric_scenario().
>=20
> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>=20
> Before this patchset:
>   1) root group will never be counted.
>   2) Count if bfqg or it's child bfqgs have pending requests.
>   3) Don't count if bfqg and it's child bfqgs complete all the requests.
>=20
> After this patchset:
>   1) root group is counted.
>   2) Count if bfqg have at least one bfqq that is marked busy.
>   3) Don't count if bfqg doesn't have any busy bfqqs.
>=20
> The main reason to use busy state of bfqq instead of 'pending requests'
> is that bfqq can stay busy after dispatching the last request if idling
> is needed for service guarantees.
>=20
> With the above changes, concurrent sync io can be supported if only
> one group is activated.
>=20
> fio test script(startdelay is used to avoid queue merging):
> [global]
> filename=3D/dev/nvme0n1
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
> v5.18-rc1:	   550 Mib/s
> v5.18-rc1-patched: 550 Mib/s
>=20
> running fio on non-root cgroup
> v5.18-rc1:	   349 Mib/s
> v5.18-rc1-patched: 550 Mib/s
>=20
> Note that I also test null_blk with "irqmode=3D2
> completion_nsec=3D100000000(100ms) hw_queue_depth=3D1", and tests show
> that service guarantees are still preserved.
>=20
> Previous versions:
> RFC: https://lore.kernel.org/all/20211127101132.486806-1-yukuai3-hv44wF8L=
i93QT0dZR+AlfA@public.gmane.org/
> v1: https://lore.kernel.org/all/20220305091205.4188398-1-yukuai3-hv44wF8L=
i93QT0dZR+AlfA@public.gmane.org/
> v2: https://lore.kernel.org/all/20220416093753.3054696-1-yukuai3-hv44wF8L=
i93QT0dZR+AlfA@public.gmane.org/
> v3: https://lore.kernel.org/all/20220427124722.48465-1-yukuai3-hv44wF8Li9=
3QT0dZR+AlfA@public.gmane.org/
> v4: https://lore.kernel.org/all/20220428111907.3635820-1-yukuai3-hv44wF8L=
i93QT0dZR+AlfA@public.gmane.org/
>=20
> Yu Kuai (3):
>    block, bfq: record how many queues are busy in bfq_group
>    block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
>    block, bfq: do not idle if only one group is activated
>=20
>   block/bfq-cgroup.c  |  1 +
>   block/bfq-iosched.c | 48 +++-----------------------------------
>   block/bfq-iosched.h | 57 +++++++--------------------------------------
>   block/bfq-wf2q.c    | 35 +++++++++++++++++-----------
>   4 files changed, 35 insertions(+), 106 deletions(-)
>=20
