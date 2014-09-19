From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: remove CGRP_RELEASABLE flag
Date: Fri, 19 Sep 2014 16:58:06 +0800
Message-ID: <541BF01E.5020803@huawei.com>
References: <541BEE74.6020008@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541BEE74.6020008-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The subject should be "[PATCH] ...".

On 2014/9/19 16:51, Zefan Li wrote:
> We call put_css_set() after setting CGRP_RELEASABLE flag in
> cgroup_task_migrate(), but in other places we call it without setting
> the flag. I don't see the necessity of this flag.
> 

