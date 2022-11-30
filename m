From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 8/8] block: fix null-pointer dereference in
 ioc_pd_init
Date: Wed, 30 Nov 2022 09:32:58 +0800
Message-ID: <e46fdde5-f320-9276-72ec-0f5fb5b48ffd@huaweicloud.com>
References: <20221128154434.4177442-1-linan122@huawei.com>
 <20221128154434.4177442-9-linan122@huawei.com>
 <Y4YWQcb4PMmIdzIM@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y4YWQcb4PMmIdzIM-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2022/11/29 22:25, Christoph Hellwig =D0=B4=B5=C0:
> On Mon, Nov 28, 2022 at 11:44:34PM +0800, Li Nan wrote:
>> Fix problem by moving rq_qos_exit() to disk_release().
>=20
> No, that now means it is removed to later.  You need to add proper
> synchronization.
> .
>=20

Can you explain a bit more? Maybe I'm being noob, here disk is about to
be freed, and I can think of any contention.

Thanks,
Kuai

