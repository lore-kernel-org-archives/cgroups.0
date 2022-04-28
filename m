From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v3 2/3] block, bfq: refactor the counting of
 'num_groups_with_pending_reqs'
Date: Thu, 28 Apr 2022 09:09:36 +0800
Message-ID: <d36b4904-3db8-537c-5040-b496272ccf70@huawei.com>
References: <20220427124722.48465-1-yukuai3@huawei.com>
 <20220427124722.48465-3-yukuai3@huawei.com>
 <20220427124908.o3cl72h2uflmufso@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220427124908.o3cl72h2uflmufso-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/04/27 20:49, Jan Kara =D0=B4=B5=C0:
> On Wed 27-04-22 20:47:21, Yu Kuai wrote:
>> Currently, bfq can't handle sync io concurrently as long as they
>> are not issued from root group. This is because
>> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
>> bfq_asymmetric_scenario().
>>
>> The way that bfqg is counted into 'num_groups_with_pending_reqs':
>>
>> Before this patch:
>>   1) root group will never be counted.
>>   2) Count if bfqg or it's child bfqgs have pending requests.
>>   3) Don't count if bfqg and it's child bfqgs complete all the requests.
>>
>> After this patch:
>>   1) root group is counted.
>>   2) Count if bfqg have at least one bfqq that is marked busy.
>>   3) Don't count if bfqg doesn't have any busy bfqqs.
>>
>> With this change, the occasion that only one group is activated can be
>> detected, and next patch will support concurrent sync io in the
>> occasion.
>>
>> This patch also rename 'num_groups_with_pending_reqs' to
>> 'num_groups_with_busy_queues'.
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Looks good. Just I think you forgot to remove in_groups_with_pending_reqs,
> which is now unused, from bfq_entity.

Will remove it in the next iteration.

Thanks,
Kuai
