From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next 00/11] support concurrent sync io for bfq on a
 specail occasion
Date: Fri, 11 Mar 2022 14:31:58 +0800
Message-ID: <e299180e-cdbd-0837-8478-5e397ac8166b@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

friendly ping ...

=D4=DA 2022/03/05 17:11, Yu Kuai =D0=B4=B5=C0:
> Currently, bfq can't handle sync io concurrently as long as they
> are not issued from root group. This is because
> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
> bfq_asymmetric_scenario().
>=20
> This patchset tries to support concurrent sync io if all the sync ios
> are issued from the same cgroup:
>=20
> 1) Count root_group into 'num_groups_with_pending_reqs', patch 1-5;
>=20
> 2) Don't idle if 'num_groups_with_pending_reqs' is 1, patch 6;
>=20
> 3) Don't count the group if the group doesn't have pending requests,
> while it's child groups may have pending requests, patch 7;
>=20
> This is because, for example:
> if sync ios are issued from cgroup /root/c1/c2, root, c1 and c2
> will all be counted into 'num_groups_with_pending_reqs',
> which makes it impossible to handle sync ios concurrently.
>=20
> 4) Decrease 'num_groups_with_pending_reqs' when the last queue completes
> all the requests, while child groups may still have pending
> requests, patch 8-10;
>=20
> This is because, for example:
> t1 issue sync io on root group, t2 and t3 issue sync io on the same
> child group. num_groups_with_pending_reqs is 2 now.
> After t1 stopped, num_groups_with_pending_reqs is still 2. sync io from
> t2 and t3 still can't be handled concurrently.
>=20
> fio test script: startdelay is used to avoid queue merging
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
> v5.17-rc6:	   550 Mib/s
> v5.17-rc6-patched: 550 Mib/s
>=20
> running fio on non-root cgroup
> v5.17-rc6:	   349 Mib/s
> v5.17-rc6-patched: 550 Mib/s
>=20
> Yu Kuai (11):
>    block, bfq: add new apis to iterate bfq entities
>    block, bfq: apply news apis where root group is not expected
>    block, bfq: cleanup for __bfq_activate_requeue_entity()
>    block, bfq: move the increasement of 'num_groups_with_pending_reqs' to
>      it's caller
>    block, bfq: count root group into 'num_groups_with_pending_reqs'
>    block, bfq: do not idle if only one cgroup is activated
>    block, bfq: only count parent bfqg when bfqq is activated
>    block, bfq: record how many queues have pending requests in bfq_group
>    block, bfq: move forward __bfq_weights_tree_remove()
>    block, bfq: decrease 'num_groups_with_pending_reqs' earlier
>    block, bfq: cleanup bfqq_group()
>=20
>   block/bfq-cgroup.c  | 13 +++----
>   block/bfq-iosched.c | 87 +++++++++++++++++++++++----------------------
>   block/bfq-iosched.h | 41 +++++++++++++--------
>   block/bfq-wf2q.c    | 56 +++++++++++++++--------------
>   4 files changed, 106 insertions(+), 91 deletions(-)
>=20
