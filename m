From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: How we use cgroups in rkt
Date: Thu, 18 Jun 2015 14:40:24 +0000
Message-ID: <20150618144024.GB18426@ubuntumail>
References: <55815556.4030304@endocode.com>
 <20150617203024.GI10949@ubuntumail>
 <CALdWxcsxWCyLyH9H+BrAYW4gY-oAyNrp_Rf726tFtbHPy2_M9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALdWxcsxWCyLyH9H+BrAYW4gY-oAyNrp_Rf726tFtbHPy2_M9Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Cc: Iago =?iso-8859-1?Q?L=F3pez?= Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

Quoting Alban Crequy (alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org):
> On Wed, Jun 17, 2015 at 10:30 PM, Serge Hallyn <serge.hallyn@ubuntu.c=
om> wrote:
> > Quoting Iago L=C3=B3pez Galeiras (iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org):
> >> Hi everyone,
> >>
> >> We are working on rkt[1] and we want to ask for feedback about the=
 way we use
> >> cgroups to implement isolation in containers. rkt uses systemd-nsp=
awn internally
> >> so I guess the best way to start is explaining how this is handled=
 in
> >> systemd-nspawn.
> >>
> >> The approach taken by nspawn is mounting the cgroup controllers re=
ad-only inside
> >> the container except the part that corresponds to it inside the sy=
stemd
> >> controller. It is done this way because allowing the container to =
modify the
> >> other controllers is considered unsafe[2].
> >>
> >> This is how bind mounts look like:
> >>
> >> /sys/fs/cgroup/devices RO
> >> [...]
> >> /sys/fs/cgroup/memory RO
> >> /sys/fs/cgroup/systemd RO
> >> /sys/fs/cgroup/systemd/machine.slice/machine-a.scope RW
> >>
> >> In rkt we have a concept called pod[3] which is a list of apps tha=
t run inside a
> >> container, each running in its own chroot. To implement this conce=
pt, we start a
> >> systemd-nspawn container with a minimal systemd installation that =
starts each
> >> app as a service.
> >>
> >> We want to be able to apply different restrictions to each app of =
a pod using
> >> cgroups and the straightforward way we thought was delegating to s=
ystemd inside
> >> the container. Initially, this didn't work because, as mentioned e=
arlier, the
> >> cgroup controllers are mounted read-only.
> >>
> >> The way we solved this problem was mounting the cgroup hierarchy (=
with the
> >> directories expected by systemd) outside the container. The differ=
ence with
> >> systemd-nspawn=E2=80=99s approach is that we don=E2=80=99t mount e=
verything read-only; instead,
> >> we leave the knobs we need in each of the application=E2=80=99s su=
bcgroups read-write.
> >>
> >> For example, if we want to restrict the memory usage of an applica=
tion we leave
> >> /sys/fs/cgroup/memory/machine/machine.slice/machine-rkt-xxxxx/syst=
em.slice/sha512-xxxx/{memory.limit_in_bytes,cgroup.procs}
> >
> > Who exactly does the writing to those files?
>=20
> First, rkt prepares systemd a .service file for each application in
> the container with "CPUQuota=3D" and "MemoryLimit=3D". The .service f=
iles
> are not used by systemd outside the container. Then, rkt uses
> systemd-nspawn to start systemd as pid 1 in the container. Finally,
> systemd inside the container writes to the cgroup files
> {memory.limit_in_bytes,cgroup.procs}.
>=20
> We call those limits the "per-app isolators". It's not a security
> boundary because all the apps run in the same container (in the same
> pid/mount/net namespaces). The apps run in different chroots, but
> that's easily escapable.
>=20
> > Do the applications want to change them, or only rkt itself?
>=20
> At the moment, the limits are statically defined in the app container
> image, so neither rkt or the apps inside the container change them. I
> don't know of a use case where we would need to change them
> dynamically.
>=20
> >  If rkt, then it seems like you should be
> > able to use a systemd api to update the values (over dbus), right?
> > systemctl set-property machine-a-scope MemoryLimit=3D1G or somethin=
g.
>=20
> In addition to the "per-app isolators" described above, rkt can have
> "pod-level isolators" that are applied on the machine slice (the
> cgroup parent directory) rather than at the leaves of the cgroup tree=
=2E
> They are defined when rkt itself is started by a systemd .service
> file, and applied by systemd outside of the container. E.g.
>=20
> [Service]
> CPUShares=3D512
> MemoryLimit=3D1G
> ExecStart=3D/usr/bin/rkt run myapp.com/myapp-1.3.4
>=20
> Updating the pod-level isolators with systemctl on the host should wo=
rk.
>=20
> But systemd inside the container or the apps don't have access to the
> required cgroup knob files: they are mounted read-only.
>=20
> > Now I'm pretty sure that systemd doesn't yet support being able to =
do
> > this from inside the container in a delegated way.
>=20
> Indeed by default nspawn/systemd does not support delegating that. It
> only works because rkt prepared the cgroup bind mounts for the
> container.
>=20
> > That was cgmanager's
> > reason for being, and I'm interested in working on a proper API for=
 that
> > for systemd.
>=20
> Do you mean patching systemd so it does not write to the cgroup
> filesystem directly but talk to the cgmanager/cgproxy socket instead?

More likely, patch it so it can talk to a systemd-owned unix socket
bind-mounted into the container.  So systemd would need to be patched
at both ends.  But that's something I was hoping would happen upstream
anyway.  I would be very happy to help out in that effort.

-serge
