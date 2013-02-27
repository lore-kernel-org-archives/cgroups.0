From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Wed, 27 Feb 2013 18:49:12 +0800
Message-ID: <512DE4A8.5050303@huawei.com>
References: <512B01FA.5020506@huawei.com> <512B020D.9040504@huawei.com> <20130226022703.GA13837@htj.dyndns.org> <512C8D84.7090707@huawei.com> <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/2/26 21:26, Tejun Heo wrote:
> Hello,
> 
> On Tue, Feb 26, 2013 at 2:25 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> Sure we can. We'll have to allocate cgrp->name in cgroup_remount() and
>> cgroup_init(), and free cgrp->name in cgroup_kill_sb(). It looks to me
>> the current version is a bit simpler.
> 
> Can't we just set it to constant "/"?  Root cgroup init is a separate
> path anyway.
> 

Well, cgrp->name is a pointer to struct cgroup_name.

At first I tried to declare cgrp->name as char *, and use container_of()
to get struct cgroup_name, but it didn't result in simpler code.

So seems there's no way that is a pure win over another.
