From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write functions
Date: Fri, 16 Aug 2013 14:48:43 +0800
Message-ID: <520DCB4B.6070808@huawei.com>
References: <5209892D.8070502@huawei.com> <52098941.4070600@huawei.com> <20130813150549.GF26596@mtj.dyndns.org> <520AE4FC.5090702@huawei.com> <20130814133048.GC28628@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130814133048.GC28628-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/8/14 21:30, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Aug 14, 2013 at 10:01:32AM +0800, Li Zefan wrote:
>> But most controllers don't check this in those read/write functions.
>> It shoudn't do any harm not checking online/offline status.
> 
> It depends on the specific controller.  For controllers which make
> clear distinction between online and offline states for, say,
> hierarchical config propagation, it could lead to buggy behavior if
> the function body afterwards assume that the current node is online.

In those cases, there must be some comments, otherwise it would be
confusing if and when one needs to check the online/offline states.

> I don't know whether this is the case for the functions converted here
> but even if so the patch needs to update the description.
> 

I'll check for sure.
