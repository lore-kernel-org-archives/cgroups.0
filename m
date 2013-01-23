From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Date: Tue, 22 Jan 2013 16:35:26 -0800
Message-ID: <20130122163526.6c4ea765.akpm@linux-foundation.org>
References: <50F7B040.2020906@huawei.com>
	<20130123002754.GB5359@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130123002754.GB5359-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, 22 Jan 2013 16:27:54 -0800
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> (cc'ing Andrew as scheduler folks are difficult to get response from
>  these days and I can't think of anyone else to bother :)
> 
> Hello, Li.
> 
> The cgroup part looks good to me but it would be great if the
> descriptions are more detailed, especially, about why the change is
> beneficial or what it's aiming at.  I take it that the shed changes
> are necessary to facilitate the later cgroup changes?  Can you please
> elaborate how?
> 
> The scheduler part of changes are mostly mechanical, so it would be
> great if we can get ack from scheduler people and route these together.
> 

The sched parts do look pretty innocuous and could be viewed as "cgroup
stuff which happens to reside in kernel/sched/".

If you like the code, I think the best you can do is to merge it up,
make sure the sched guys are fully cc'ed then send it in to Linus.
