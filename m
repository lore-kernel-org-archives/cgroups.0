From: Paolo VALENTE <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Subject: Re: [patch v11 0/6] support concurrent sync io for bfq on a specail
 occasion
Date: Tue, 25 Oct 2022 08:34:44 +0200
Message-ID: <A1E2F76F-2D27-4DCE-9B97-C8011CBE2A9E@unimore.it>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
 <29348B39-94AE-4D76-BD2E-B759056264B6@linaro.org>
 <011d479f-644f-0013-40bf-664b62f93bec@huaweicloud.com>
 <A9D22DB6-6481-46BA-9D4C-5A828D19CB61@linaro.org>
 <bcd07062-5a3b-563e-fb2d-2fa8e4c8bba5@huaweicloud.com>
 <82f1e969-742d-d3c3-63ca-961c755b5c35@huaweicloud.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unimore.it; s=google;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pB6QUffw7MUyfYFBflqjkQA18+gYo2TkZv4lf52ehhI=;
        b=o6MxM0eQ5rIC1kkuN5yBdwj4wborrB0lJOkj0b8dk5ojPaN+PP8sjp8ic3I/voPTpR
         qW9s1fl24u4A2uBQqYiAI/f41m5gSkAknOYHt9MG7lWHRDiaKLTHp0hnLFeWIa/NiGmx
         8Wc40vyPfGO+6Sh6D5/HvvuVwBq4TRpcufXR8=
In-Reply-To: <82f1e969-742d-d3c3-63ca-961c755b5c35-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>



> Il giorno 18 ott 2022, alle ore 06:00, Yu Kuai =
<yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org> ha scritto:
>=20
> Hi, Paolo
>=20
> =E5=9C=A8 2022/10/11 17:36, Yu Kuai =E5=86=99=E9=81=93:
>>>>> Your patches seem ok to me now (thanks for you contribution and, =
above all, for your patience). I have only a high-level concern: what do =
you mean when you say that service guarantees are still preserved? What =
test did you run exactly? This point is very important to me. I'd like =
to see some convincing test with differentiated weights. In case you =
don't have other tools for executing such tests quickly, you may want to =
use the bandwidth-latency test in my simple S benchmark suite (for which =
I'm willing to help).
>>>>=20
>>>> Is there any test that you wish me to try?
>>>>=20
>>>> By the way, I think for the case that multiple groups are =
activaced, (
>>>> specifically num_groups_with_pendind_rqs > 1), io path in bfq is =
the
>>>> same with or without this patchset.
>> I just ran the test for one time, result is a liiter inconsistent, do
>> you think it's in the normal fluctuation range?
>=20
> I rerun the manually test for 5 times, here is the average result:
>=20
> without this patchset / with this patchset:
>=20
> | --------------- | ------------- | ------------ | -------------- | =
------------- | -------------- |
> | cg1 weight      | 10            | 20           | 30             | 40 =
         | 50             |
> | cg2 weight      | 90            | 80           | 70             | 60 =
         | 50             |
> | cg1 bw MiB/s    | 21.4 / 21.74  | 42.72 / 46.6 | 63.82 / 61.52  | =
94.74 / 90.92 | 140 / 138.2    |
> | cg2 bw MiB/s    | 197.2 / 197.4 | 182 / 181.2  | 171.2 / 173.44 | =
162 / 156.8   | 138.6 / 137.04 |
> | cg2 bw / cg1 bw | 9.22 / 9.08   | 4.26 / 3.89  | 2.68 / 2.82    | =
1.71 / 1.72   | 0.99 / 0.99    |

Great!  Results are (statistically) the same, with and without your
patchset.  For me your patches are ok.  Thank you very much for this
contribution, and sorry again for my delay.

Acked-by: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks,
Paolo

>=20
>> test script:
>> fio -filename=3D/dev/nullb0 -ioengine=3Dlibaio -ioscheduler=3Dbfq =
-jumjobs=3D1 -iodepth=3D64 -direct=3D1 -bs=3D4k -rw=3Drandread =
-runtime=3D60 -name=3Dtest
>> without this patchset:
>> |                 |      |      |      |      |      |
>> | --------------- | ---- | ---- | ---- | ---- | ---- |
>> | cg1 weight      | 10   | 20   | 30   | 40   | 50   |
>> | cg2 weight      | 90   | 80   | 70   | 60   | 50   |
>> | cg1 bw MiB/s    | 25.8 | 51.0 | 80.1 | 90.5 | 138  |
>> | cg2 bw MiB/s    | 193  | 179  | 162  | 127  | 136  |
>> | cg2 bw / cg1 bw | 7.48 | 3.51 | 2.02 | 1.40 | 0.98 |
>> with this patchset
>> |                 |      |      |      |      |      |
>> | --------------- | ---- | ---- | ---- | ---- | ---- |
>> | cg1 weight      | 10   | 20   | 30   | 40   | 50   |
>> | cg2 weight      | 90   | 80   | 70   | 60   | 50   |
>> | cg1 bw MiB/s    | 21.5 | 43.9 | 62.7 | 87.4 | 136  |
>> | cg2 bw MiB/s    | 195  | 185  | 173  | 138  | 141  |
>> | cg2 bw / cg1 bw | 9.07 | 4.21 | 2.75 | 1.57 | 0.96 |
>>>>=20
>>>=20
>>> The tests cases you mentioned are ok for me (whatever tool or =
personal
>>> code you use to run them).  Just show me your results with and =
without
>>> your patchset applied.
>>>=20
>>> Thanks,
>>> Paolo
>>>=20
>>>> Thanks,
>>>> Kuai
>>>>> Thanks,
>>>>> Paolo
>>>>>> Previous versions:
>>>>>> RFC: =
https://lore.kernel.org/all/20211127101132.486806-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/=20=

>>>>>> v1: =
https://lore.kernel.org/all/20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/=20=

>>>>>> v2: =
https://lore.kernel.org/all/20220416093753.3054696-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/=20=

>>>>>> v3: =
https://lore.kernel.org/all/20220427124722.48465-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
>>>>>> v4: =
https://lore.kernel.org/all/20220428111907.3635820-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/=20=

>>>>>> v5: =
https://lore.kernel.org/all/20220428120837.3737765-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/=20=

>>>>>> v6: =
https://lore.kernel.org/all/20220523131818.2798712-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/=20=

>>>>>> v7: =
https://lore.kernel.org/all/20220528095020.186970-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/=20=

>>>>>>=20
>>>>>>=20
>>>>>> Yu Kuai (6):
>>>>>>   block, bfq: support to track if bfqq has pending requests
>>>>>>   block, bfq: record how many queues have pending requests
>>>>>>   block, bfq: refactor the counting of =
'num_groups_with_pending_reqs'
>>>>>>   block, bfq: do not idle if only one group is activated
>>>>>>   block, bfq: cleanup bfq_weights_tree add/remove apis
>>>>>>   block, bfq: cleanup __bfq_weights_tree_remove()
>>>>>>=20
>>>>>> block/bfq-cgroup.c  | 10 +++++++
>>>>>> block/bfq-iosched.c | 71 =
+++++++--------------------------------------
>>>>>> block/bfq-iosched.h | 30 +++++++++----------
>>>>>> block/bfq-wf2q.c    | 69 =
++++++++++++++++++++++++++-----------------
>>>>>> 4 files changed, 76 insertions(+), 104 deletions(-)
>>>>>>=20
>>>>>> --=20
>>>>>> 2.31.1
>>>>>>=20
>>>>> .
>>>=20
>>> .
>>>=20
>> .
>=20

