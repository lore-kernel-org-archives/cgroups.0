From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC 0/9] support concurrent sync io for bfq on a specail
 occasion
Date: Fri, 10 Dec 2021 17:50:34 +0800
Message-ID: <809b90cc-20ba-c4fd-8c29-b9e3123c1cef@huawei.com>
References: <20211127101132.486806-1-yukuai3@huawei.com>
 <D3FF0820-6A51-46A1-A363-8FFA8CCD2851@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <D3FF0820-6A51-46A1-A363-8FFA8CCD2851@linaro.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2021/12/10 17:20, Paolo Valente =D0=B4=B5=C0:
>=20
>=20
>> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai <yukuai3@huawei.com> ha s=
critto:
>>
>> Bfq can't handle sync io concurrently as long as the io are not issued
>> from root group currently.
>>
>> Previous patch set:
>> https://lore.kernel.org/lkml/20211014014556.3597008-2-yukuai3@huawei.com=
/t/
>>
>> During implemting the method mentioned by the above patch set, I found
>> more problems that will block implemting concurrent sync io. The
>> modifications of this patch set are as follows:
>>
>> 1) count root group into 'num_groups_with_pending_reqs';
>> 2) don't idle if 'num_groups_with_pending_reqs' is 1;
>> 3) If the group doesn't have pending requests while it's child groups
>> have pending requests, don't count the group.
>=20
> Why don't yo count the parent group? It seems to me that we should count =
it.
Hi, Paolo

For example, we only issue io in child group c2(root->c1->c2),
'num_groups_with_pending_reqs' will end up greater than 1, thus it's
impossible to handle sync io concurrently. Thus I don't count root and
c1, only count c2.
>=20
>> 4) Once the group doesn't have pending requests, decrease
>> 'num_groups_with_pending_reqs' immediately. Don't delay to when all
>> it's child groups don't have pending requests.
>>
>=20
> I guess this action is related to 3).
Yes, if c1, c2 are both active, and then c1 don't have any pending reqs,
I want to decrease num_groups_with_pending_reqs to 1 immediately. So
that sync io on c2 can be handled concurrently.

Thanks,
Kuai

>=20
> Thanks,
> Paolo
>=20
>> Noted that I just tested basic functionality of this patchset, and I
>> think it's better to see if anyone have suggestions or better
>> solutions.
>>
>> Yu Kuai (9):
>>   block, bfq: add new apis to iterate bfq entities
>>   block, bfq: apply news apis where root group is not expected
>>   block, bfq: handle the case when for_each_entity() access root group
>>   block, bfq: count root group into 'num_groups_with_pending_reqs'
>>   block, bfq: do not idle if only one cgroup is activated
>>   block, bfq: only count group that the bfq_queue belongs to
>>   block, bfq: record how many queues have pending requests in bfq_group
>>   block, bfq: move forward __bfq_weights_tree_remove()
>>   block, bfq: decrease 'num_groups_with_pending_reqs' earlier
>>
>> block/bfq-cgroup.c  |  3 +-
>> block/bfq-iosched.c | 92 +++++++++++++++++++++++----------------------
>> block/bfq-iosched.h | 41 +++++++++++++-------
>> block/bfq-wf2q.c    | 44 +++++++++++++++-------
>> 4 files changed, 106 insertions(+), 74 deletions(-)
>>
>> --=20
>> 2.31.1
>>
>=20
> .
>=20
