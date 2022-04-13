From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next 00/11] support concurrent sync io for bfq on a
 specail occasion
Date: Wed, 13 Apr 2022 19:33:28 +0800
Message-ID: <36f0923c-bb9b-12f1-b3bc-cdbe0bbcca55@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
 <20220413111216.npgrdzaubsvjsmy3@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220413111216.npgrdzaubsvjsmy3-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/04/13 19:12, Jan Kara =D0=B4=B5=C0:
> On Sat 05-03-22 17:11:54, Yu Kuai wrote:
>> Currently, bfq can't handle sync io concurrently as long as they
>> are not issued from root group. This is because
>> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
>> bfq_asymmetric_scenario().
>>
>> This patchset tries to support concurrent sync io if all the sync ios
>> are issued from the same cgroup:
>>
>> 1) Count root_group into 'num_groups_with_pending_reqs', patch 1-5;
>=20
> Seeing the complications and special casing for root_group I wonder: Won't
> we be better off to create fake bfq_sched_data in bfq_data and point
> root_group->sched_data there? AFAICS it would simplify the code

Hi,

That sounds an good idel, in this case we only need to make sure the
fake service tree will always be empty, which means we only need to
special casing bfq_active/idle_insert to the fake service tree.

Thanks,
Kuai
> considerably as root_group would be just another bfq_group, no need to
> special case it in various places, no games with bfqg->my_entity, etc.
> Paolo, do you see any problem with that?
>=20
> 								Honza
>=20
