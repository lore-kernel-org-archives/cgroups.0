From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG in v3.18 ?] Seems to be triggered from cgroup code
Date: Thu, 12 Feb 2015 14:09:35 +0800
Message-ID: <54DC439F.2080703@huawei.com>
References: <54D402BA.2030307@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D402BA.2030307-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2015/2/6 7:54, santosh shilimkar wrote:
> Hi Tejun and all,
> 
> We observed a BUG (stack is end of the email) while trying do some
> ceph testing. I looked at pidlist_free(), pidlist_array_load() for
> any potential leak but those functions looked fine to me.
> The BUG is not 100% reproducible either so though of reporting
> to the list to get some more pointers.
> 

By saying not 100% reproducible, do you mean it's reproducible but
not very easy to trigger?

I have to clue how this can happen...This reminds me another bug
report which also happend in pidlist code and it's not reproducible.

https://lkml.org/lkml/2014/9/16/710
