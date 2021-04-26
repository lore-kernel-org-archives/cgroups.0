From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Mon, 26 Apr 2021 17:29:32 +0200
Message-ID: <20210426152932.ekay5rfyqeojzihc@wittgenstein>
References: <20210423171351.3614430-1-brauner@kernel.org>
 <YIbRZeWIl8i6soSN@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YIbRZeWIl8i6soSN@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 26, 2021 at 04:42:45PM +0200, Michal Koutn=C3=BD wrote:
> Hello Christian,
> I have some questions to understand the motivation here.
>=20
> On Fri, Apr 23, 2021 at 07:13:51PM +0200, Christian Brauner <brauner-DgEj=
T+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > - Signals are specified by writing the signal number into cgroup.signal.
> >   An alternative would be to allow writing the signal name but I don't
> >   think that's worth it. Callers like systemd can easily do a snprintf()
> >   with the signal's define/enum.
> > - Since signaling is a one-time event and we're holding cgroup_mutex()
> >   as we do for freezer we don't need to worry about tasks joining the
> >   cgroup while we're signaling the cgroup. Freezer needed to care about
> >   this because a task could join or leave frozen/non-frozen cgroups.
> >   Since we only support SIGKILL currently and SIGKILL works for frozen
> >   tasks there's also not significant interaction with frozen cgroups.
> > - Since signaling leads to an event and not a state change the
> >   cgroup.signal file is write-only.
> Have you considered accepting a cgroup fd to pidfd_send_signal and
> realize this operation through this syscall? (Just asking as it may
> prevent some of these consequences whereas bring other unclarities.)

That's semantically quite wrong on several fronts, I think.
pidfd_send_signal() operates on pidfds (and for a quirky historical
reason /proc/<pid> though that should die at some point). Making this
operate on cgroup fds is essentially implicit multiplexing which is
pretty nasty imho. In addition, this is a cgroup concept not a pidfd
concept.
I've also removed the "arbitrary signal" feature from the cgroup.signal
knob. I think Roman's right that it should simply be cgroup.kill.

>=20
>=20
> > - Since we currently only support SIGKILL we don't need to generate a
> >   separate notification and can rely on the unpopulated notification
> >   meachnism. If we support more signals we can introduce a separate
> >   notification in cgroup.events.
> What kind of notification do you have in mind here?

This is now irrelevant with dumbing this down to cgroup.kill.

>=20
> > - Freezer doesn't care about tasks in different pid namespaces, i.e. if
> >   you have two tasks in different pid namespaces the cgroup would still
> >   be frozen.
> >   The cgroup.signal mechanism should consequently behave the same way,
> >   i.e.  signal all processes and ignore in which pid namespace they
> >   exist. This would obviously mean that if you e.g. had a task from an
> >   ancestor pid namespace join a delegated cgroup of a container in a
> >   child pid namespace the container can kill that task. But I think this
> >   is fine and actually the semantics we want since the cgroup has been
> >   delegated.
> What do you mean by a delegated cgroup in this context?

Hm? I mean a cgroup that is delegated to a specific user according to
the official cgroup2 documentation.

brauner@wittgenstein|/sys/fs/cgroup/payload.f1
> ls -al
total 0
drwxrwxr-x  6 root   100000 0 Apr 25 11:51 .
dr-xr-xr-x 41 root   root   0 Apr 25 11:51 ..
-r--r--r--  1 root   root   0 Apr 26 17:20 cgroup.controllers
-r--r--r--  1 root   root   0 Apr 26 17:20 cgroup.events
-rw-r--r--  1 root   root   0 Apr 26 17:20 cgroup.freeze
-rw-r--r--  1 root   root   0 Apr 26 17:20 cgroup.max.depth
-rw-r--r--  1 root   root   0 Apr 26 17:20 cgroup.max.descendants
-rw-rw-r--  1 root   100000 0 Apr 25 11:51 cgroup.procs
-r--r--r--  1 root   root   0 Apr 26 17:20 cgroup.stat
-rw-rw-r--  1 root   100000 0 Apr 25 11:51 cgroup.subtree_control
-rw-rw-r--  1 root   100000 0 Apr 25 11:51 cgroup.threads
-rw-r--r--  1 root   root   0 Apr 26 17:20 cgroup.type
-rw-r--r--  1 root   root   0 Apr 26 17:20 cpu.pressure
-r--r--r--  1 root   root   0 Apr 26 17:20 cpu.stat
drwxr-xr-x  2 100000 100000 0 Apr 25 11:51 init.scope
-rw-r--r--  1 root   root   0 Apr 26 17:20 io.pressure
drwxr-xr-x  2 100000 100000 0 Apr 25 11:51 .lxc
-rw-r--r--  1 root   root   0 Apr 26 17:20 memory.pressure
drwxr-xr-x 78 100000 100000 0 Apr 26 15:24 system.slice
drwxr-xr-x  2 100000 100000 0 Apr 25 11:52 user.slice

>=20
> > - We're holding the read-side of tasklist lock while we're signaling
> >   tasks. That seems fine since kill(-1, SIGKILL) holds the read-side
> >   of tasklist lock walking all processes and is a way for unprivileged
> >   users to trigger tasklist lock being held for a long time. In contrast
> >   it would require a delegated cgroup with lots of processes and a deep
> >   hierarchy to allow for something similar with this interface.
> I'd better not proliferate tasklist_lock users if it's avoidable (such
> as freezer does).
>=20
> > Fwiw, in addition to the system manager and container use-cases I think
> > this has the potential to be picked up by the "kill" tool. In the future
> > I'd hope we can do: kill -9 --cgroup /sys/fs/cgroup/delegated
> (OT: FTR, there's `systemctl kill` already ;-))

Not every distro uses systemd. :)
And actually systemd is one of the users of this feature.
