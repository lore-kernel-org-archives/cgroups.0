From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Notifying on empty cgroup
Date: Wed, 15 Jan 2014 16:12:18 +0100
Message-ID: <20140115151218.GO8782@dhcp22.suse.cz>
References: <135711389759165@web22h.yandex.ru>
 <20140115135930.GK8782@dhcp22.suse.cz>
 <409331389795100@web18j.yandex.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <409331389795100-sAm+gIlHn/hxpj1cXAZ9Bg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Victor Porton <porton-Q+l+L2ir60w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed 15-01-14 16:11:40, Victor Porton wrote:
> 15.01.2014, 15:59, "Michal Hocko" <mhocko-AlSwsSmVLrQ@public.gmane.org>:
> > [CCing cgroups mailing list]
> > On Wed 15-01-14 06:12:45, Victor Porton wrote:
> >
> >> =A0I want to write software which needs to receive a signal when t=
he cgroup
> >> =A0created by it becomes empty. (After this the empty cgroup shoul=
d be deleted
> >> =A0just not to clutter the memory.)
> >>
> >> =A0If the kernel does not support such notifications, it should be=
 improved.
> >> =A0This functionality is crucial for some kinds of software.
> >>
> >> =A0There is /sys/fs/cgroup/systemd/release_agent but I don't under=
stand how to
> >> =A0use it. I don't understand why we would need it at all.
> >
> > "1.4 What does notify_on_release do ?" in
> > Documentation/cgroups/cgroups.txt the kernel source doesn't help?
>=20
> I've read it. I understand what it does. I don't understand how to us=
e
> it in practice nor

You want to clean up your memcg without any tasks so the script might d=
o
something like:
---
#!/bin/sh

CGROUP=3D"$1"
CGROUP_MNT=3D`mount | grep cgroup | awk '{print $3}'`

rmdir "$CGROUP_MNT/$CGROUP"
---

> why it is done this way.

I find the interface rather awkward as well but that is a question for
those who have implement it.

The interface will change in the future (sorry I do not have any link t=
o
discussion about the change handy).

> >> =A0Starting a binary on emptying a cgroup with the purpose to noti=
fy an other
> >> =A0binary looks like a big overkill.
> >
> > the binary can do rmdir which is what you want, no?
>=20
> I suppose a base package should do that, not my specific software. Do
> I understand right?

Yes. The notifier works on the root of the cgroup hierarchy so it is a
matter of the admin to set it.
=20
> >> =A0Also my program should work in userspace without the need to us=
e
> >> =A0release_agent which can be accessed only by root.
> >
> > The release_agent is global for all groups so the program doesn't h=
ave
> > to care.
>=20
> Again: What MY program should do?

Nothing. (assuming the only thing you are interested in is removing the
empty group).

[...]
--=20
Michal Hocko
SUSE Labs
