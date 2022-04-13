From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next 02/11] block, bfq: apply news apis where root group
 is not expected
Date: Wed, 13 Apr 2022 19:11:23 +0800
Message-ID: <7b99bbcb-9d65-387f-0c1e-4377a7beff58@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
 <20220305091205.4188398-3-yukuai3@huawei.com>
 <20220413095044.uwxeqli2ytcdanem@quack3.lan>
 <20220413105932.lzvlafeilinuqcw3@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220413105932.lzvlafeilinuqcw3-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/04/13 18:59, Jan Kara =D0=B4=B5=C0:
> On Wed 13-04-22 11:50:44, Jan Kara wrote:
>> On Sat 05-03-22 17:11:56, Yu Kuai wrote:
>>> 'entity->sched_data' is set to parent group's sched_data, thus it's NULL
>>> for root group. And for_each_entity() is used widely to access
>>> 'entity->sched_data', thus aplly news apis if root group is not
>>                               ^^ apply
>>
Hi,

Thanks for spotting this.
>>> expected. Prepare to count root group into 'num_groups_with_pending_req=
s'.
>>>
>>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>> ---
>>>   block/bfq-iosched.c |  2 +-
>>>   block/bfq-iosched.h | 22 ++++++++--------------
>>>   block/bfq-wf2q.c    | 10 +++++-----
>>>   3 files changed, 14 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
>>> index 69ddf6b0f01d..3bc7a7686aad 100644
>>> --- a/block/bfq-iosched.c
>>> +++ b/block/bfq-iosched.c
>>> @@ -4393,7 +4393,7 @@ void bfq_bfqq_expire(struct bfq_data *bfqd,
>>>   	 * service with the same budget.
>>>   	 */
>>>   	entity =3D entity->parent;
>>> -	for_each_entity(entity)
>>> +	for_each_entity_not_root(entity)
>>>   		entity->service =3D 0;
>>>   }
>>
>> So why is it a problem to clear the service for root cgroup here?

This is not a problem in theory, however 'entity->service' should always
be 0 for root_group. Thus I think there is no need to do this.

>>
>>> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
>>> index f8eb340381cf..c4cb935a615a 100644
>>> --- a/block/bfq-wf2q.c
>>> +++ b/block/bfq-wf2q.c
>>> @@ -815,7 +815,7 @@ void bfq_bfqq_served(struct bfq_queue *bfqq, int se=
rved)
>>>   		bfqq->service_from_wr +=3D served;
>>>  =20
>>>   	bfqq->service_from_backlogged +=3D served;
>>> -	for_each_entity(entity) {
>>> +	for_each_entity_not_root(entity) {
>>>   		st =3D bfq_entity_service_tree(entity);
>>
>> Hum, right so how come this was not crashing? Because entity->sched_data=
 is
>> indeed NULL for bfqd->root_group->entity and so bfq_entity_service_tree()
>> returned some bogus pointer? Similarly for the cases you are changing
>> below?
>=20
> Oh, I see now. Because for_each_entity() currently does not iterate throu=
gh
> root cgroup because it has root_group->my_entity set to NULL and thus as a
> result immediate children of root_group will have their parent set to NULL
> as well.

Yes, currently for_each_entity() and for_each_entity_not_root() are the
same, they will stop before root_group.

With patch 5, for_each_entity_not_root() will stay the same, while
for_each_entity() will access root_group's entity in addition. And
because bfq_entity_service_tree() will access 'entity->sched_data', thus
I change to the new api here to avoid null-ptr-deref after patch 5.

Same reasons for below changes.

Thanks,
Kuai
