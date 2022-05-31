From: Paolo VALENTE <paolo.valente@unimore.it>
Subject: Re: [PATCH -next v7 2/3] block, bfq: refactor the counting of
 'num_groups_with_pending_reqs'
Date: Tue, 31 May 2022 10:36:15 +0200
Message-ID: <1803FD7E-9FB1-4A1E-BD6D-D6657006589A@unimore.it>
References: <20220528095020.186970-1-yukuai3@huawei.com>
 <20220528095020.186970-3-yukuai3@huawei.com>
 <0D9355CE-F85B-4B1A-AEC3-F63DFC4B3A54@linaro.org>
 <b9a4ea60-28e5-b7aa-0154-ad7481eafbd3@huawei.com>
 <efe01dd1-0f99-dadf-956d-b0e80e1e602c@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unimore.it; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=FIJm64zSOV70KcmATQ1QKKdd03bwiTpTbvXIZEBOtyU=;
        b=XAUy8Fy8mFRUhRv9O+rzT5F0TRfZRlE1gqkce0PLn2tBFnDoJXg9NnOl20ZvpeBleX
         Pd3EwavEBA+X5OJVCi9qFYtKXBjUT3kqUhLoWp78FP1WQEZ9oi6NW6tegoAj9TT5Mo+y
         Z0LoNo7mtMgpknC7BukFxusRJyrrYBvSvY/I0=
In-Reply-To: <efe01dd1-0f99-dadf-956d-b0e80e1e602c@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai3@huawei.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com



> Il giorno 30 mag 2022, alle ore 10:40, Yu Kuai <yukuai3@huawei.com> ha =
scritto:
>=20
> =E5=9C=A8 2022/05/30 16:34, Yu Kuai =E5=86=99=E9=81=93:
>> =E5=9C=A8 2022/05/30 16:10, Paolo Valente =E5=86=99=E9=81=93:
>>>=20
>>>=20
>>>> Il giorno 28 mag 2022, alle ore 11:50, Yu Kuai <yukuai3@huawei.com> =
ha scritto:
>>>>=20
>>>> Currently, bfq can't handle sync io concurrently as long as they
>>>> are not issued from root group. This is because
>>>> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
>>>> bfq_asymmetric_scenario().
>>>>=20
>>>> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>>>>=20
>>>> Before this patch:
>>>> 1) root group will never be counted.
>>>> 2) Count if bfqg or it's child bfqgs have pending requests.
>>>> 3) Don't count if bfqg and it's child bfqgs complete all the =
requests.
>>>>=20
>>>> After this patch:
>>>> 1) root group is counted.
>>>> 2) Count if bfqg have at least one bfqq that is marked busy.
>>>> 3) Don't count if bfqg doesn't have any busy bfqqs.
>>>=20
>>> Unfortunately, I see a last problem here. I see a double change:
>>> (1) a bfqg is now counted only as a function of the state of its =
child
>>>      queues, and not of also its child bfqgs
>>> (2) the state considered for counting a bfqg moves from having =
pending
>>>      requests to having busy queues
>>>=20
>>> I'm ok with with (1), which is a good catch (you are lady explained
>>> the idea to me some time ago IIRC).
>>>=20
>>> Yet I fear that (2) is not ok.  A bfqq can become non busy even if =
it
>>> still has in-flight I/O, i.e.  I/O being served in the drive.  The
>>> weight of such a bfqq must still be considered in the weights_tree,
>>> and the group containing such a queue must still be counted when
>>> checking whether the scenario is asymmetric.  Otherwise service
>>> guarantees are broken.  The reason is that, if a scenario is deemed =
as
>>> symmetric because in-flight I/O is not taken into account, then =
idling
>>> will not be performed to protect some bfqq, and in-flight I/O may
>>> steal bandwidth to that bfqq in an uncontrolled way.
>> Hi, Paolo
>> Thanks for your explanation.
>> My orginal thoughts was using weights_tree insertion/removal, =
however,
>> Jan convinced me that using bfq_add/del_bfqq_busy() is ok.
>> =46rom what I see, when bfqq dispatch the last request,
>> bfq_del_bfqq_busy() will not be called from __bfq_bfqq_expire() if
>> idling is needed, and it will delayed to when such bfqq get scheduled =
as
>> in-service queue again. Which means the weight of such bfqq should =
still
>> be considered in the weights_tree.
>> I also run some tests on null_blk with "irqmode=3D2
>> completion_nsec=3D100000000(100ms) hw_queue_depth=3D1", and tests =
show
>> that service guarantees are still preserved on slow device.
>> Do you this is strong enough to cover your concern?

Unfortunately it is not.  Your very argument is what made be believe
that considering busy queues was enough, in the first place.  But, as
I found out, the problem is caused by the queues that do not enjoy
idling.  With your patch (as well as in my initial version) they are
not counted when they remain without requests queued.  And this makes
asymmetric scenarios be considered erroneously as symmetric.  The
consequence is that idling gets switched off when it had to be kept
on, and control on bandwidth is lost for the victim in-service queues.

Thanks,
Paolo

>> Thanks,
>> Kuai
>>>=20
>>> I verified this also experimentally a few years ago, when I added =
this
>>> weights_tree stuff.  That's the rationale behind the part of
>>> bfq_weights_tree_remove that this patch eliminates.  IOW,
>>> for a bfqq and its parent bfqg to be out of the count for symmetry,
>>> all bfqq's requests must also be completed.
>>>=20
>>> Thanks,
>>> Paolo
>=20
> I forgot to cc Jan for this patchset... This is a reply for Jan.

