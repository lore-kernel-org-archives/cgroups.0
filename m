From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/2] block: cancel all throttled bios in del_gendisk()
Date: Mon, 24 Jan 2022 11:50:11 +0800
Message-ID: <b416e6a6-f2c9-caf3-dacd-f937746207da@huawei.com>
References: <20220110134758.2233758-1-yukuai3@huawei.com>
 <20220110134758.2233758-3-yukuai3@huawei.com> <Yd5FkuhYX9YcgQkZ@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yd5FkuhYX9YcgQkZ@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/01/12 11:05, Ming Lei =D0=B4=B5=C0:
> Hello Yu Kuai,
>=20
> On Mon, Jan 10, 2022 at 09:47:58PM +0800, Yu Kuai wrote:
>> Throttled bios can't be issued after del_gendisk() is done, thus
>> it's better to cancel them immediately rather than waiting for
>> throttle is done.
>>
>> For example, if user thread is throttled with low bps while it's
>> issuing large io, and the device is deleted. The user thread will
>> wait for a long time for io to return.
>>
>> Noted this patch is mainly from revertion of commit 32e3374304c7
>> ("blk-throttle: remove tg_drain_bios") and commit b77412372b68
>> ("blk-throttle: remove blk_throtl_drain").
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   block/blk-throttle.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
>>   block/blk-throttle.h |  2 ++
>>   block/genhd.c        |  2 ++
>>   3 files changed, 81 insertions(+)
>=20
> Just wondering why not take the built-in way in throtl_upgrade_state() for
> canceling throttled bios? Something like the following, then we can avoid
> to re-invent the wheel.

Hi, Tejun

Both ways can fix the problem, which way do you prefer?

Thanks,
Kuai
