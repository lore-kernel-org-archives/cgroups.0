From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next 10/11] block, bfq: decrease
 'num_groups_with_pending_reqs' earlier
Date: Wed, 13 Apr 2022 19:40:32 +0800
Message-ID: <f3ed507a-7c85-cd69-3ad5-3e9c0e75c372@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
 <20220305091205.4188398-11-yukuai3@huawei.com>
 <20220413112816.fwobg4cp6ttpnpk6@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220413112816.fwobg4cp6ttpnpk6-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/04/13 19:28, Jan Kara =D0=B4=B5=C0:
> On Sat 05-03-22 17:12:04, Yu Kuai wrote:
>> Currently 'num_groups_with_pending_reqs' won't be decreased when
>> the group doesn't have any pending requests, while some child group
>> still have pending requests. The decrement is delayed to when all the
>> child groups doesn't have any pending requests.
>>
>> For example:
>> 1) t1 issue sync io on root group, t2 and t3 issue sync io on the same
>> child group. num_groups_with_pending_reqs is 2 now.
>> 2) t1 stopped, num_groups_with_pending_reqs is still 2. io from t2 and
>> t3 still can't be handled concurrently.
>>
>> Fix the problem by decreasing 'num_groups_with_pending_reqs'
>> immediately upon the weights_tree removal of last bfqq of the group.
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> So I'd find the logic easier to follow if you completely removed
> entity->in_groups_with_pending_reqs and did updates of
> bfqd->num_groups_with_pending_reqs like:
>=20
> 	if (!bfqg->num_entities_with_pending_reqs++)
> 		bfqd->num_groups_with_pending_reqs++;
>=20
Hi,

Indeed, this is an excellent idle, and much better than the way I did.

Thanks,
Kuai

> and similarly on the remove side. And there would we literally two places
> (addition & removal from weight tree) that would need to touch these
> counters. Pretty obvious and all can be done in patch 9.
>=20
> 								Honza
>=20

