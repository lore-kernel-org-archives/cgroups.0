From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write functions
Date: Wed, 14 Aug 2013 10:01:32 +0800
Message-ID: <520AE4FC.5090702@huawei.com>
References: <5209892D.8070502@huawei.com> <52098941.4070600@huawei.com> <20130813150549.GF26596@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130813150549.GF26596-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/8/13 23:05, Tejun Heo wrote:
> On Tue, Aug 13, 2013 at 09:17:53AM +0800, Li Zefan wrote:
>> Now cgroup core gets a reference to the css when a cgroup file is
>> opened(), and the reference is dropped at file release. so it's
>> guaranteed the cpuset is online during the write function.
> 
> Hmmm... it doesn't really guarantee that as css's can be offlined with
> residual css refcnts, os the css may well be offlined by the time it
> reaches the rw functions.  What's guaranteed is that their refcnts
> wouldn't be zero.

Oh, right.

But most controllers don't check this in those read/write functions.
It shoudn't do any harm not checking online/offline status.

> Eventually we need to implement proper sever
> semantics (probably by replacing the custom fs implementation with
> sysfs) but right now controllers still need to deal with offline
> css's.
> 
> Thanks.
> 
