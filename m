From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: Getting notifications of the tasks file
Date: Tue, 31 Jul 2012 17:14:13 +0300
Message-ID: <20120731141413.GA3200@shutemov.name>
References: <5486539.IgfTNnpt1m@valencia>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5486539.IgfTNnpt1m@valencia>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?iso-8859-1?Q?V=EDctor_Fern=E1ndez_Mart=EDnez?= <vfernandez-JE8hqn47KVKB+jHODAdFcQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 31, 2012 at 11:42:06AM +0200, V=C3=ADctor Fern=C3=A1ndez Ma=
rt=C3=ADnez wrote:
> =EF=BB=BFI'm trying to use the eventfd notification API to get notifi=
ed when the tasks=20
> file changes. This way I would like to know when child processes are =
spawned=20
> and when they exit. However, I always get EINVAL when writing to=20
> cgroup.event_control. Even cgroup_event_listener.c returns that error=
:
>=20
> # cat /sys/fs/cgroup/memory/grp0/tasks=20
> 3590
> 23902
> # ./cgroup_event_listener /sys/fs/cgroup/memory/grp0/tasks 0
> Cannot write to cgroup.event_control: Invalid argument
>=20
> I have also tried to monitor cgroup.procs.
>=20
> Is it possible to monitor the tasks file at all or is this a bug? If =
0 is a=20
> wrong argument, which argument should I use instead?

Currently, you can only listen for events from memory.usage_in_bytes,
memory.memsw.usage_in_bytes and memory.oom_control.
It's not implemented for any other cgroup files yet.

--=20
 Kirill A. Shutemov
