From: Yu Kuai <yukuai3@huawei.com>
Subject: Re: [patch v11 0/6] support concurrent sync io for bfq on a specail
 occasion
Date: Wed, 28 Sep 2022 09:07:46 +0800
Message-ID: <ab662add-6880-ffdb-98cc-7a947374489d@huawei.com>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
 <29348B39-94AE-4D76-BD2E-B759056264B6@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <29348B39-94AE-4D76-BD2E-B759056264B6@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Paolo Valente <paolo.valente@linaro.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, Jan Kara <jack@suse.cz>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Paolo

=D4=DA 2022/09/28 0:38, Paolo Valente =D0=B4=B5=C0:
>=20
>=20
>> Il giorno 16 set 2022, alle ore 09:19, Yu Kuai <yukuai1@huaweicloud.com>=
 ha scritto:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Changes in v11:
>> - keep the comments in bfq_weights_tree_remove() and move it to the
>> caller where bfqq can be freed.
>> - add two followed up cleanup patches.
>>
>> Changes in v10:
>> - Add reviewed-tag for patch 2
>>
>> Changes in v9:
>> - also update how many bfqqs have pending_reqs bfq_bfqq_move().
>> - fix one language in patch 4
>> - Add reviewed-tag for patch 1,3,4
>>
>> Changes in v8:
>> - Instead of using whether bfqq is busy, using whether bfqq has pending
>> requests. As Paolo pointed out the former way is problematic.
>>
>> Changes in v7:
>> - fix mismatch bfq_inc/del_busy_queues() and bfqq_add/del_bfqq_busy(),
>> also retest this patchset on v5.18 to make sure functionality is
>> correct.
>> - move the updating of 'bfqd->busy_queues' into new apis
>>
>> Changes in v6:
>> - add reviewed-by tag for patch 1
>>
>> Changes in v5:
>> - rename bfq_add_busy_queues() to bfq_inc_busy_queues() in patch 1
>> - fix wrong definition in patch 1
>> - fix spelling mistake in patch 2: leaset -> least
>> - update comments in patch 3
>> - add reviewed-by tag in patch 2,3
>>
>> Changes in v4:
>> - split bfq_update_busy_queues() to bfq_add/dec_busy_queues(),
>>    suggested by Jan Kara.
>> - remove unused 'in_groups_with_pending_reqs',
>>
>> Changes in v3:
>> - remove the cleanup patch that is irrelevant now(I'll post it
>>    separately).
>> - instead of hacking wr queues and using weights tree insertion/removal,
>>    using bfq_add/del_bfqq_busy() to count the number of groups
>>    (suggested by Jan Kara).
>>
>> Changes in v2:
>> - Use a different approch to count root group, which is much simple.
>>
>> Currently, bfq can't handle sync io concurrently as long as they
>> are not issued from root group. This is because
>> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
>> bfq_asymmetric_scenario().
>>
>> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>>
>> Before this patchset:
>> 1) root group will never be counted.
>> 2) Count if bfqg or it's child bfqgs have pending requests.
>> 3) Don't count if bfqg and it's child bfqgs complete all the requests.
>>
>> After this patchset:
>> 1) root group is counted.
>> 2) Count if bfqg has pending requests.
>> 3) Don't count if bfqg complete all the requests.
>>
>> With the above changes, concurrent sync io can be supported if only
>> one group is activated.
>>
>> fio test script(startdelay is used to avoid queue merging):
>> [global]
>> filename=3D/dev/sda
>> allow_mounted_write=3D0
>> ioengine=3Dpsync
>> direct=3D1
>> ioscheduler=3Dbfq
>> offset_increment=3D10g
>> group_reporting
>> rw=3Drandwrite
>> bs=3D4k
>>
>> [test1]
>> numjobs=3D1
>>
>> [test2]
>> startdelay=3D1
>> numjobs=3D1
>>
>> [test3]
>> startdelay=3D2
>> numjobs=3D1
>>
>> [test4]
>> startdelay=3D3
>> numjobs=3D1
>>
>> [test5]
>> startdelay=3D4
>> numjobs=3D1
>>
>> [test6]
>> startdelay=3D5
>> numjobs=3D1
>>
>> [test7]
>> startdelay=3D6
>> numjobs=3D1
>>
>> [test8]
>> startdelay=3D7
>> numjobs=3D1
>>
>> test result:
>> running fio on root cgroup
>> v5.18:	   112 Mib/s
>> v5.18-patched: 112 Mib/s
>>
>> running fio on non-root cgroup
>> v5.18:	   51.2 Mib/s
>> v5.18-patched: 112 Mib/s
>>
>> Note that I also test null_blk with "irqmode=3D2
>> completion_nsec=3D100000000(100ms) hw_queue_depth=3D1", and tests show
>> that service guarantees are still preserved.
>>
>=20
> Your patches seem ok to me now (thanks for you contribution and, above al=
l, for your patience). I have only a high-level concern: what do you mean w=
hen you say that service guarantees are still preserved? What test did you =
run exactly? This point is very important to me. I'd like to see some convi=
ncing test with differentiated weights. In case you don't have other tools =
for executing such tests quickly, you may want to use the bandwidth-latency=
 test in my simple S benchmark suite (for which I'm willing to help).

I'm runnnig some tests manually, just issuing same io to two cgroups,
and changing weights manually, specifically (1:10, 2:8, ..., 5:5),
then observe bandwidth from two cgroups.

Of course I'm glad to try your benchmark suite.

Thanks,
Kuai
>=20
> Thanks,
> Paolo
>=20
>> Previous versions:
>> RFC: https://lore.kernel.org/all/20211127101132.486806-1-yukuai3@huawei.=
com/
>> v1: https://lore.kernel.org/all/20220305091205.4188398-1-yukuai3@huawei.=
com/
>> v2: https://lore.kernel.org/all/20220416093753.3054696-1-yukuai3@huawei.=
com/
>> v3: https://lore.kernel.org/all/20220427124722.48465-1-yukuai3@huawei.co=
m/
>> v4: https://lore.kernel.org/all/20220428111907.3635820-1-yukuai3@huawei.=
com/
>> v5: https://lore.kernel.org/all/20220428120837.3737765-1-yukuai3@huawei.=
com/
>> v6: https://lore.kernel.org/all/20220523131818.2798712-1-yukuai3@huawei.=
com/
>> v7: https://lore.kernel.org/all/20220528095020.186970-1-yukuai3@huawei.c=
om/
>>
>>
>> Yu Kuai (6):
>>   block, bfq: support to track if bfqq has pending requests
>>   block, bfq: record how many queues have pending requests
>>   block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
>>   block, bfq: do not idle if only one group is activated
>>   block, bfq: cleanup bfq_weights_tree add/remove apis
>>   block, bfq: cleanup __bfq_weights_tree_remove()
>>
>> block/bfq-cgroup.c  | 10 +++++++
>> block/bfq-iosched.c | 71 +++++++--------------------------------------
>> block/bfq-iosched.h | 30 +++++++++----------
>> block/bfq-wf2q.c    | 69 ++++++++++++++++++++++++++-----------------
>> 4 files changed, 76 insertions(+), 104 deletions(-)
>>
>> --=20
>> 2.31.1
>>
>=20
> .
>=20
