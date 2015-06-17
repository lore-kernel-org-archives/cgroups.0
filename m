From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: How we use cgroups in rkt
Date: Wed, 17 Jun 2015 20:30:24 +0000
Message-ID: <20150617203024.GI10949@ubuntumail>
References: <55815556.4030304@endocode.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55815556.4030304-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Iago =?iso-8859-1?Q?L=F3pez?= Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Quoting Iago L=C3=B3pez Galeiras (iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org):
> Hi everyone,
>=20
> We are working on rkt[1] and we want to ask for feedback about the wa=
y we use
> cgroups to implement isolation in containers. rkt uses systemd-nspawn=
 internally
> so I guess the best way to start is explaining how this is handled in
> systemd-nspawn.
>=20
> The approach taken by nspawn is mounting the cgroup controllers read-=
only inside
> the container except the part that corresponds to it inside the syste=
md
> controller. It is done this way because allowing the container to mod=
ify the
> other controllers is considered unsafe[2].
>=20
> This is how bind mounts look like:
>=20
> /sys/fs/cgroup/devices RO
> [...]
> /sys/fs/cgroup/memory RO
> /sys/fs/cgroup/systemd RO
> /sys/fs/cgroup/systemd/machine.slice/machine-a.scope RW
>=20
> In rkt we have a concept called pod[3] which is a list of apps that r=
un inside a
> container, each running in its own chroot. To implement this concept,=
 we start a
> systemd-nspawn container with a minimal systemd installation that sta=
rts each
> app as a service.
>=20
> We want to be able to apply different restrictions to each app of a p=
od using
> cgroups and the straightforward way we thought was delegating to syst=
emd inside
> the container. Initially, this didn't work because, as mentioned earl=
ier, the
> cgroup controllers are mounted read-only.
>=20
> The way we solved this problem was mounting the cgroup hierarchy (wit=
h the
> directories expected by systemd) outside the container. The differenc=
e with
> systemd-nspawn=E2=80=99s approach is that we don=E2=80=99t mount ever=
ything read-only; instead,
> we leave the knobs we need in each of the application=E2=80=99s subcg=
roups read-write.
>=20
> For example, if we want to restrict the memory usage of an applicatio=
n we leave
> /sys/fs/cgroup/memory/machine/machine.slice/machine-rkt-xxxxx/system.=
slice/sha512-xxxx/{memory.limit_in_bytes,cgroup.procs}

Who exactly does the writing to those files?  Do the applications want =
to
change them, or only rkt itself?  If rkt, then it seems like you should=
 be
able to use a systemd api to update the values (over dbus), right?
systemctl set-property machine-a-scope MemoryLimit=3D1G or something.

Now I'm pretty sure that systemd doesn't yet support being able to do
this from inside the container in a delegated way.  That was cgmanager'=
s
reason for being, and I'm interested in working on a proper API for tha=
t
for systemd.

> read-write so systemd inside the container can set the appropriate re=
strictions
> but the rest of /sys/fs/cgroup/memory/ is still read-only.
>=20
> We know this doesn=E2=80=99t provide perfect isolation but we assume =
non-malicious
> applications. We also know we=E2=80=99ll have to rework this when sys=
temd starts using
> the unified hierarchy.
>=20
> What do you think about our approach?
>=20
> Cheers.
>=20
> [1]: https://github.com/coreos/rkt
> [2]: http://lists.freedesktop.org/archives/systemd-devel/2015-April/0=
31191.html
> [3]: https://github.com/appc/spec/blob/master/spec/pods.md
>=20
> --=20
>=20
> Iago L=C3=B3pez Galeiras
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
