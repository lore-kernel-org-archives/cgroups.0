From: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG in v3.18 ?] Seems to be triggered from cgroup code
Date: Thu, 12 Feb 2015 09:30:54 -0800
Message-ID: <54DCE34E.1010307@oracle.com>
References: <54D402BA.2030307@oracle.com> <54DC439F.2080703@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DC439F.2080703-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



On 2/11/2015 10:09 PM, Zefan Li wrote:
> On 2015/2/6 7:54, santosh shilimkar wrote:
>> Hi Tejun and all,
>>
>> We observed a BUG (stack is end of the email) while trying do some
>> ceph testing. I looked at pidlist_free(), pidlist_array_load() for
>> any potential leak but those functions looked fine to me.
>> The BUG is not 100% reproducible either so though of reporting
>> to the list to get some more pointers.
>>
>
> By saying not 100% reproducible, do you mean it's reproducible but
> not very easy to trigger?
>
Right. We saw it only once in 20+ attempts.

> I have to clue how this can happen...This reminds me another bug
> report which also happend in pidlist code and it's not reproducible.
>
> https://lkml.org/lkml/2014/9/16/710
>
I was just trying my luck if I can get some more ideas about the
potential cause.

Thanks for the response !!

Regards,
Santosh
