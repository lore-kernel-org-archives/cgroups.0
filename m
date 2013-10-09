From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup attach task - slogging cpu
Date: Wed, 9 Oct 2013 15:30:47 +0200
Message-ID: <20131009133047.GA12414@redhat.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com> <20131004130207.GA9338@redhat.com> <20131007184507.GD27396@htj.dyndns.org> <20131008145833.GA15600@redhat.com> <5254EB2A.7090803@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5254EB2A.7090803-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/09, Li Zefan wrote:
>
> Anjana, could you revise the patch and send it out with proper changelog
> and Signed-off-by? And please add "Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+"

Yes, Anjana, please!

> > check in the main loop. So Anjana was right (sorry again!), and we
> > should probably do
> > 
> > 		ent.cgrp = task_cgroup_from_root(...);
> > 		if (ent.cgrp != cgrp) {
> > 			retval = flex_array_put(...);
> > 			...
> > 		}
> > 
> > 		if (!threadgroup)
> > 			break;
> > 
> 
> Or
> 
> do {
> 	...
> 	if (ent.cgrp == cgrp)
> 		goto next;

Or this, agreed.

> > Or I am wrong again?
>
> No, you are not! :)

Thanks ;)

Oleg.
