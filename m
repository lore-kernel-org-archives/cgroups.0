From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Killing cgroups
Date: Tue, 20 Apr 2021 14:11:52 +0200
Message-ID: <20210420121152.kplnuuujuplmcs6m@wittgenstein>
References: <20210419155607.gmwu376cj4nyagyj@wittgenstein>
 <CALvZod6haoRmgp++9sqvZaYCo+gaK6t5MSfSZ7XFpm4p6wACwA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod6haoRmgp++9sqvZaYCo+gaK6t5MSfSZ7XFpm4p6wACwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Apr 19, 2021 at 10:08:19AM -0700, Shakeel Butt wrote:
> On Mon, Apr 19, 2021 at 8:56 AM Christian Brauner
> <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Hey,
> >
> > It's not as dramatic as it sounds but I've been mulling a cgroup feature
> > for some time now which I would like to get some input on. :)
> >
> > So in container-land assuming a conservative layout where we treat a
> > container as a separate machine we tend to give each container a
> > delegated cgroup. That has already been the case with cgroup v1 and now
> > even more so with cgroup v2.
> >
> > So usually you will have a 1:1 mapping between container and cgroup. If
> > the container in addition uses a separate pid namespace then killing a
> > container becomes a simple kill -9 <container-init-pid> from an ancestor
> > pid namespace.
> >
> > However, there are quite a few scenarios where one or two of those
> > assumptions aren't true, i.e. there are containers that share the cgroup
> > with other processes on purpose that are supposed to be bound to the
> > lifetime of the container but are not in the same pidns of the
> > container. Containers that are in a delegated cgroup but share the pid
> > namespace with the host or other containers.
> >
> > This is just the container use-case. There are additional use-cases from
> > systemd services for example.
> >
> > For such scenarios it would be helpful to have a way to kill/signal all
> > processes in a given cgroup.
> >
> > It feels to me that conceptually this is somewhat similar to the freezer
> > feature. Freezer is now nicely implemented in cgroup.freeze. I would
> > think we could do something similar for the signal feature I'm thinking
> > about. So we add a file cgroup.signal which can be opened with O_RDWR
> > and can be used to send a signal to all processes in a given cgroup:
> 
> and the descendant cgroups as well.

Yes, I think in line with the current design it would need to be
recursive by default. Which I think is fine. The case where we only want
to wipe all processes in a single cgroup might be ok to do manually.

> 
> >
> > int fd = open("/sys/fs/cgroup/my/delegated/cgroup", O_RDWR);
> > write(fd, "SIGKILL", sizeof("SIGKILL") - 1);
> 
> The userspace oom-killers can also take advantage of this feature.

Good to hear that there are more use-cases.
