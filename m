From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] blk-throttle: enable io throttle for root in cgroup
 v2
Date: Tue, 8 Feb 2022 09:38:33 +0800
Message-ID: <32b6949d-60b1-82ce-ae44-1cf089a78276@huawei.com>
References: <20220114093000.3323470-1-yukuai3@huawei.com>
 <YfGE9L4i7DtNTo08@slm.duckdns.org>
 <235b0757-d322-2b6e-3ab6-ecc8c82f8f1e@huawei.com>
 <Yflr4FzUTWsiLTC/@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yflr4FzUTWsiLTC/@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/02/02 1:20, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Thu, Jan 27, 2022 at 10:36:38AM +0800, yukuai (C) wrote:
>> In our case, the disk is provided by server, and such disk can be shared
>> by multipul clients. Thus for the client side, the server is a higher
>> level parent.
>>
>> Theoretically, limit the io from server for each client is feasible,
>> however, the main reason we don't want to do this is the following
>> shortcoming:
>>
>> client can still send io to server unlimited, we can just limit the
>> amount of io that can complete from server, which might cause too much
>> pressure on the server side.
>=20
> I don't quite follow the "send io to server unlimited" part. Doesn't that
> get limited by available number of requests?=20

Hi, Tejun

Here I mean that io is not limited through io throttle from client. Of
course io must be limited by avaliable number of requests.

> ie. if the server throttles,
> the in-flight requests will take longer to complete which exhausts the
> available requests and thus slows down the client.

For example, if we have 8 clients, and available requests is 64.

1) If we don't limit iops, and each client send 64 io to server, some
client might have performance issue.

2) If we limit iops to 8 from clients, then server can receive 64 io at
most at the same time, both client and server should work fine.

3) If we limit iops to 8 for each client from server, client should work
fine, however, server can receive 64 x 8 =3D 512 io at most at the same
time, which might cause too much pressure on the server.(maybe bps is
more appropriate to explain the high pressure).

Thus I prefer to limit io from client.

Thanks,
Kuai
> That's how it's supposed
> to work on the local machine too.
>=20
> Thanks.
>=20
