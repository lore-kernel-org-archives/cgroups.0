From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH ] cgroup: rename cont to cgrp
Date: Wed, 19 Jun 2013 09:31:10 +0800
Message-ID: <51C109DE.8010607@huawei.com>
References: <51BA8B3F.3060606@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51BA8B3F.3060606-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

Hi Tejun,

Could you apply this patch?

On 2013/6/14 11:17, Li Zefan wrote:
> Cont is short for container. control group was named process container
> at first, but then people found container already has a meaning in
> linux kernel.
> 
> Clean up the leftover variable name @cont.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> 
> I'll clean up this for memcg later.
> 
> ---
>  include/linux/cgroup.h |  4 ++--
>  kernel/cgroup.c        | 22 +++++++++++-----------
>  2 files changed, 13 insertions(+), 13 deletions(-)
> 
