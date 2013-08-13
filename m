From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write functions
Date: Tue, 13 Aug 2013 10:07:01 +0800
Message-ID: <520994C5.5050503@huawei.com>
References: <5209892D.8070502@huawei.com> <52098941.4070600@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52098941.4070600-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/8/13 9:17, Li Zefan wrote:
> Now cgroup core gets a reference to the css when a cgroup file is
> opened(), and the reference is dropped at file release. so it's
> guaranteed the cpuset is online during the write function.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cpuset.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 

Please don't apply this patch. I'll send a new one when the bug
fix I just sent is accepted.
