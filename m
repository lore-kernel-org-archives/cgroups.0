From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [patch v11 0/6] support concurrent sync io for bfq on a specail
 occasion
Date: Tue, 11 Oct 2022 10:21:56 +0200
Message-ID: <A9D22DB6-6481-46BA-9D4C-5A828D19CB61@linaro.org>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
 <29348B39-94AE-4D76-BD2E-B759056264B6@linaro.org>
 <011d479f-644f-0013-40bf-664b62f93bec@huaweicloud.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bj0xYgysArWLPqW0WEMYDYsbaIBaqVxoq6u3lZ4Lwck=;
        b=X64aMQ30USDaS6YeCWAbTV5gDuf6RDdUddRq9OV4gOQ1EG/6NpE3h5wSmvlCUH5Mv4
         ZV3jRdJDykwJWTTxetGmadEy2rwG1rUnHHlcN5fGVo1MCHd1LZdHtPp1z3wuVHRhvckP
         K8XCYGzeo5JT6fuzzLvfnsSan797kDJKjFuCzKV65ugJrV/ETWIf4KgNHnLBJ9nK8gWx
         h8blJjdaR086z5bup0+RcvzP+bEZzh7WCMvTiOrNr+7klIA3YMH5tJ9Sc4qxt2szn+/U
         k9zGFg5X3XPjTYfWbq8ZNRNpaFeEzVa1TesXi32mOEffldg0+UBmuZQlWh/6FRIIxmSF
         T05w==
In-Reply-To: <011d479f-644f-0013-40bf-664b62f93bec@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, cgroups@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>



> Il giorno 11 ott 2022, alle ore 10:11, Yu Kuai =
<yukuai1@huaweicloud.com> ha scritto:
>=20
> Hi, paolo
>=20
> =E5=9C=A8 2022/09/28 0:38, Paolo Valente =E5=86=99=E9=81=93:
>>> Il giorno 16 set 2022, alle ore 09:19, Yu Kuai =
<yukuai1@huaweicloud.com> ha scritto:
>>>=20
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>=20
>>> Changes in v11:
>>> - keep the comments in bfq_weights_tree_remove() and move it to the
>>> caller where bfqq can be freed.
>>> - add two followed up cleanup patches.
>>>=20
>>> Changes in v10:
>>> - Add reviewed-tag for patch 2
>>>=20
>>> Changes in v9:
>>> - also update how many bfqqs have pending_reqs bfq_bfqq_move().
>>> - fix one language in patch 4
>>> - Add reviewed-tag for patch 1,3,4
>>>=20
>>> Changes in v8:
>>> - Instead of using whether bfqq is busy, using whether bfqq has =
pending
>>> requests. As Paolo pointed out the former way is problematic.
>>>=20
>>> Changes in v7:
>>> - fix mismatch bfq_inc/del_busy_queues() and =
bfqq_add/del_bfqq_busy(),
>>> also retest this patchset on v5.18 to make sure functionality is
>>> correct.
>>> - move the updating of 'bfqd->busy_queues' into new apis
>>>=20
>>> Changes in v6:
>>> - add reviewed-by tag for patch 1
>>>=20
>>> Changes in v5:
>>> - rename bfq_add_busy_queues() to bfq_inc_busy_queues() in patch 1
>>> - fix wrong definition in patch 1
>>> - fix spelling mistake in patch 2: leaset -> least
>>> - update comments in patch 3
>>> - add reviewed-by tag in patch 2,3
>>>=20
>>> Changes in v4:
>>> - split bfq_update_busy_queues() to bfq_add/dec_busy_queues(),
>>>   suggested by Jan Kara.
>>> - remove unused 'in_groups_with_pending_reqs',
>>>=20
>>> Changes in v3:
>>> - remove the cleanup patch that is irrelevant now(I'll post it
>>>   separately).
>>> - instead of hacking wr queues and using weights tree =
insertion/removal,
>>>   using bfq_add/del_bfqq_busy() to count the number of groups
>>>   (suggested by Jan Kara).
>>>=20
>>> Changes in v2:
>>> - Use a different approch to count root group, which is much simple.
>>>=20
>>> Currently, bfq can't handle sync io concurrently as long as they
>>> are not issued from root group. This is because
>>> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
>>> bfq_asymmetric_scenario().
>>>=20
>>> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>>>=20
>>> Before this patchset:
>>> 1) root group will never be counted.
>>> 2) Count if bfqg or it's child bfqgs have pending requests.
>>> 3) Don't count if bfqg and it's child bfqgs complete all the =
requests.
>>>=20
>>> After this patchset:
>>> 1) root group is counted.
>>> 2) Count if bfqg has pending requests.
>>> 3) Don't count if bfqg complete all the requests.
>>>=20
>>> With the above changes, concurrent sync io can be supported if only
>>> one group is activated.
>>>=20
>>> fio test script(startdelay is used to avoid queue merging):
>>> [global]
>>> filename=3D/dev/sda
>>> allow_mounted_write=3D0
>>> ioengine=3Dpsync
>>> direct=3D1
>>> ioscheduler=3Dbfq
>>> offset_increment=3D10g
>>> group_reporting
>>> rw=3Drandwrite
>>> bs=3D4k
>>>=20
>>> [test1]
>>> numjobs=3D1
>>>=20
>>> [test2]
>>> startdelay=3D1
>>> numjobs=3D1
>>>=20
>>> [test3]
>>> startdelay=3D2
>>> numjobs=3D1
>>>=20
>>> [test4]
>>> startdelay=3D3
>>> numjobs=3D1
>>>=20
>>> [test5]
>>> startdelay=3D4
>>> numjobs=3D1
>>>=20
>>> [test6]
>>> startdelay=3D5
>>> numjobs=3D1
>>>=20
>>> [test7]
>>> startdelay=3D6
>>> numjobs=3D1
>>>=20
>>> [test8]
>>> startdelay=3D7
>>> numjobs=3D1
>>>=20
>>> test result:
>>> running fio on root cgroup
>>> v5.18:	   112 Mib/s
>>> v5.18-patched: 112 Mib/s
>>>=20
>>> running fio on non-root cgroup
>>> v5.18:	   51.2 Mib/s
>>> v5.18-patched: 112 Mib/s
>>>=20
>>> Note that I also test null_blk with "irqmode=3D2
>>> completion_nsec=3D100000000(100ms) hw_queue_depth=3D1", and tests =
show
>>> that service guarantees are still preserved.
>>>=20
>> Your patches seem ok to me now (thanks for you contribution and, =
above all, for your patience). I have only a high-level concern: what do =
you mean when you say that service guarantees are still preserved? What =
test did you run exactly? This point is very important to me. I'd like =
to see some convincing test with differentiated weights. In case you =
don't have other tools for executing such tests quickly, you may want to =
use the bandwidth-latency test in my simple S benchmark suite (for which =
I'm willing to help).
>=20
> Is there any test that you wish me to try?
>=20
> By the way, I think for the case that multiple groups are activaced, (
> specifically num_groups_with_pendind_rqs > 1), io path in bfq is the
> same with or without this patchset.
>=20

The tests cases you mentioned are ok for me (whatever tool or personal
code you use to run them).  Just show me your results with and without
your patchset applied.

Thanks,
Paolo

> Thanks,
> Kuai
>> Thanks,
>> Paolo
>>> Previous versions:
>>> RFC: =
https://lore.kernel.org/all/20211127101132.486806-1-yukuai3@huawei.com/
>>> v1: =
https://lore.kernel.org/all/20220305091205.4188398-1-yukuai3@huawei.com/
>>> v2: =
https://lore.kernel.org/all/20220416093753.3054696-1-yukuai3@huawei.com/
>>> v3: =
https://lore.kernel.org/all/20220427124722.48465-1-yukuai3@huawei.com/
>>> v4: =
https://lore.kernel.org/all/20220428111907.3635820-1-yukuai3@huawei.com/
>>> v5: =
https://lore.kernel.org/all/20220428120837.3737765-1-yukuai3@huawei.com/
>>> v6: =
https://lore.kernel.org/all/20220523131818.2798712-1-yukuai3@huawei.com/
>>> v7: =
https://lore.kernel.org/all/20220528095020.186970-1-yukuai3@huawei.com/
>>>=20
>>>=20
>>> Yu Kuai (6):
>>>  block, bfq: support to track if bfqq has pending requests
>>>  block, bfq: record how many queues have pending requests
>>>  block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
>>>  block, bfq: do not idle if only one group is activated
>>>  block, bfq: cleanup bfq_weights_tree add/remove apis
>>>  block, bfq: cleanup __bfq_weights_tree_remove()
>>>=20
>>> block/bfq-cgroup.c  | 10 +++++++
>>> block/bfq-iosched.c | 71 =
+++++++--------------------------------------
>>> block/bfq-iosched.h | 30 +++++++++----------
>>> block/bfq-wf2q.c    | 69 ++++++++++++++++++++++++++-----------------
>>> 4 files changed, 76 insertions(+), 104 deletions(-)
>>>=20
>>> --=20
>>> 2.31.1
>>>=20
>> .

