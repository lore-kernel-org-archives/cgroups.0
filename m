From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: Killing cgroups
Date: Mon, 19 Apr 2021 09:15:16 -0700
Message-ID: <YH2slGErZ7s4t6DC@carbon.dhcp.thefacebook.com>
References: <20210419155607.gmwu376cj4nyagyj@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qUUJkXQGPRLgHK3O0aTtQROA0Wm0eIL3Cj9nkoLiah8=;
 b=CBgQcPt1G+HWkrTxESJ+eldJsVR4bTD5DjK7I0HbZISRB7wxh+q0EhvsZF9OyB6g8SNq
 bNaYilQkFgWOcBrxgNp8Q1BdCCHz0D1OV4XnsFLt0ttv0ivX3uJXJF37Sa3z93qmYUYL
 fv5LWOCbg2xlPd5uk5gpqP8BA0wmorvfV+s= 
Content-Disposition: inline
In-Reply-To: <20210419155607.gmwu376cj4nyagyj@wittgenstein>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 19, 2021 at 05:56:07PM +0200, Christian Brauner wrote:
> Hey,
> 
> It's not as dramatic as it sounds but I've been mulling a cgroup feature
> for some time now which I would like to get some input on. :)
> 
> So in container-land assuming a conservative layout where we treat a
> container as a separate machine we tend to give each container a
> delegated cgroup. That has already been the case with cgroup v1 and now
> even more so with cgroup v2.
> 
> So usually you will have a 1:1 mapping between container and cgroup. If
> the container in addition uses a separate pid namespace then killing a
> container becomes a simple kill -9 <container-init-pid> from an ancestor
> pid namespace.
> 
> However, there are quite a few scenarios where one or two of those
> assumptions aren't true, i.e. there are containers that share the cgroup
> with other processes on purpose that are supposed to be bound to the
> lifetime of the container but are not in the same pidns of the
> container. Containers that are in a delegated cgroup but share the pid
> namespace with the host or other containers.
> 
> This is just the container use-case. There are additional use-cases from
> systemd services for example.
> 
> For such scenarios it would be helpful to have a way to kill/signal all
> processes in a given cgroup.
> 
> It feels to me that conceptually this is somewhat similar to the freezer
> feature. Freezer is now nicely implemented in cgroup.freeze. I would
> think we could do something similar for the signal feature I'm thinking
> about. So we add a file cgroup.signal which can be opened with O_RDWR
> and can be used to send a signal to all processes in a given cgroup:
> 
> int fd = open("/sys/fs/cgroup/my/delegated/cgroup", O_RDWR);
> write(fd, "SIGKILL", sizeof("SIGKILL") - 1);
> 
> with SIGKILL being the only signal supported for a start and we can in
> the future extend this to more signals.
> 
> I'd like to hear your general thoughts about a feature like this or
> similar to this before prototyping it.

Hello Christian!

Tejun and me discussed a feature like this during my work on the freezer
controller, and we both thought it might be useful. But because there is
a relatively simple userspace way to do it (which is implemented many times),
and systemd and other similar control daemons will need to keep it in a
working state for a quite some time anyway (to work on older kernels),
it was considered a low-prio feature, and it was somewhere on my to-do list
since then.
I'm not sure we need anything beyond SIGKILL and _maybe_ SIGTERM.
Indeed it can be implemented re-using a lot from the freezer code.
Please, let me know if I can help.

Thanks!
