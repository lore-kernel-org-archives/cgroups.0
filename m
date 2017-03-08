From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: counting file descriptors with a cgroup controller
Date: Wed, 08 Mar 2017 11:19:31 +0100
Message-ID: <607306a7-c075-b2e0-777d-d5a4c790527e@samsung.com>
References: <CGME20170217093725eucas1p12478baf297d25303f3020f4973fbf3b0@eucas1p1.samsung.com>
 <87poihtaya.fsf%l.stelmach@samsung.com>
 <9a57890c-d9e9-5719-e155-ce1161795a02@samsung.com>
 <20170306185820.GA19696@htj.duckdns.org>
 <7fbd9c4c-76ca-4073-9afa-1ab54364ec79@samsung.com>
 <20170307194134.GE31179@htj.duckdns.org>
 <9ee62e45-6645-454b-11b5-85be746bc81a@samsung.com>
 <20170307204825.GH31179@htj.duckdns.org>
 <CAG53R5VQrm-c-F8GdqJ9fx4n+=QU5n3gT-9adx4HqRO_R8BOaw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <CAG53R5VQrm-c-F8GdqJ9fx4n+=QU5n3gT-9adx4HqRO_R8BOaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 03/08/2017 03:59 AM, Parav Pandit wrote:
> Hi,
>
> On Tue, Mar 7, 2017 at 2:48 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>
>> Hello,
>>
>> On Tue, Mar 07, 2017 at 09:06:49PM +0100, Krzysztof Opasiak wrote:
>>> Personally, I don't want to use rlimit for this as it ends up returning
>>> error code from for example open() when we hit the limit. This may lead to
>>> some unpredictable crashes in  services (esp. those poor proprietary binary
>>> blobs). Instead of injecting errors to service we would like to just get
>>> notification that this service has more opened fds than it should and ask it
>>> to restart in a polite way.
>>>
>
> How does those poor proprietary binary blobs remain polite after restart?

They wont.

> Do you mean you want to keep restarting them when it reaches the limit?

We'd like to restart them each time when they reach limit declared by 
developer.

Best regards,
-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
