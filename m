From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 9/9] block, bfq: decrease
 'num_groups_with_pending_reqs' earlier
Date: Sat, 11 Dec 2021 10:10:50 +0800
Message-ID: <4765e7f8-48b7-3bc6-5eb6-1dc0a569233d@huawei.com>
References: <20211127101132.486806-1-yukuai3@huawei.com>
 <20211127101132.486806-10-yukuai3@huawei.com>
 <AA66019E-FD14-4821-B53D-0C56EEC38828@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AA66019E-FD14-4821-B53D-0C56EEC38828-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2021/12/10 18:21, Paolo Valente =D0=B4=B5=C0:
>=20
>> Il giorno 27 nov 2021, alle ore 11:11, Yu Kuai<yukuai3-hv44wF8Li93QT0dZR=
+AlfA@public.gmane.org>  ha scritto:
>>
>> Currently 'num_groups_with_pending_reqs' won't be decreased when
>> the group doesn't have any pending requests, while any child group
>> have any pending requests. The decrement is delayed to when all the
>> child groups doesn't have any pending requests.
>>
>> For example:
>> 1) t1 issue sync io on root group, t2 and t3 issue sync io on the same
>> child group. num_groups_with_pending_reqs is 2 now.
>> 2) t1 stopped, num_groups_with_pending_reqs is still 2. io from t2 and
>> t3 still can't be handled concurrently.
>>
>> Fix the problem by decreasing 'num_groups_with_pending_reqs'
>> immediately upon the deactivation of last entity of the group.
>>
> I don't understand this patch clearly.
>=20
> I understand your proposal not to count a group as with pending requests,=
 in case no child process of the group has IO, but only its child groups ha=
ve pending requests.
>=20
> So, entities here are only queues for this patch?
>=20
> If they are only queues, I think it is still incorrect to remove the grou=
p from the count of groups with pending IO when all its child queues are de=
activated, because there may still be unfinished IO for those queues.

Hi, Paolo

bfq_weights_tree_remove() will be called when all requests are completed
in bfq_queue, thus I recored how many queues have pending requests
through weights tree insertion and removal.(Details in patch 7)

Thus when calling bfq_weights_tree_remove() for bfqq, I can check if
there are no queues have pending requests for parent bfqg:

if (!bfqg->num_entities_with_pending_reqs && -> no queues with pending reqs
     entity->in_groups_with_pending_reqs) {   -> the group is counted

Thanks,
Kuai
>=20
> Am I missing something?
>=20
> Thanks,
> Paolo
>=20
