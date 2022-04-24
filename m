From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v2 0/5] support concurrent sync io for bfq on a
 specail occasion
Date: Sun, 24 Apr 2022 10:44:28 +0800
Message-ID: <c120ed31-860d-99d2-5c97-4023766fea96@huawei.com>
References: <20220416093753.3054696-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220416093753.3054696-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

friendly ping ...

=D4=DA 2022/04/16 17:37, Yu Kuai =D0=B4=B5=C0:
> Changes in v2:
>   - Use a different aporch to count root group, which is much simple.
>=20
> Currently, bfq can't handle sync io concurrently as long as they
> are not issued from root group. This is because
> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
> bfq_asymmetric_scenario().
>=20
> The way that bfqg is counted to 'num_groups_with_pending_reqs':
>=20
> Before this patchset:
>   1) root group will never be counted.
>   2) Count if bfqg or it's child bfqgs have pending requests.
>   3) Don't count if bfqg and it's child bfqgs complete all the requests.
>=20
> After this patchset:
>   1) root group is counted.
>   2) Count if bfqg have pending requests.
> This is because, for example:
> if sync ios are issued from cgroup /root/c1/c2, root, c1 and c2 will all
> be counted into 'num_groups_with_pending_reqs', which makes it impossible
> to handle sync ios concurrently.
>=20
>   3) Don't count if bfqg complete all the requests.
> This is because, for example:
> t1 issue sync io on root group, t2 and t3 issue sync io on the same child
> group. num_groups_with_pending_reqs is 2 now. After t1 stopped,
> num_groups_with_pending_reqs is still 2. sync io from t2 and t3 still can=
't
> be handled concurrently.
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
> v5.18-rc1:	   550 Mib/s
> v5.18-rc1-patched: 550 Mib/s
>=20
> running fio on non-root cgroup
> v5.18-rc1:	   349 Mib/s
> v5.18-rc1-patched: 550 Mib/s
>=20
> Yu Kuai (5):
>    block, bfq: cleanup bfq_weights_tree add/remove apis
>    block, bfq: add fake weight_counter for weight-raised queue
>    bfq, block: record how many queues have pending requests in bfq_group
>    block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
>    block, bfq: do not idle if only one cgroup is activated
>=20
>   block/bfq-cgroup.c  |  1 +
>   block/bfq-iosched.c | 90 +++++++++++++++++++--------------------------
>   block/bfq-iosched.h | 26 ++++++-------
>   block/bfq-wf2q.c    | 30 +++------------
>   4 files changed, 56 insertions(+), 91 deletions(-)
>=20
