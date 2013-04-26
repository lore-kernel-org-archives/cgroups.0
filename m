From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup sysfs entry
Date: Fri, 26 Apr 2013 09:31:01 +0800
Message-ID: <5179D8D5.4050003@huawei.com>
References: <CAJJAcod9kNkdEvVf8GyHqqdzzC0Px1EdHwNtv68e-XtMXVo8zw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJJAcod9kNkdEvVf8GyHqqdzzC0Px1EdHwNtv68e-XtMXVo8zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: David Shwatrz <dshwatrz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

=E4=BA=8E 2013/4/26 3:39, David Shwatrz =E5=86=99=E9=81=93:
> Hello,
>=20
> I have a question about cgroup implementation:
>=20
> The /sys/fs/cgroup entry is created in kernel/cgroup.c:
>=20
> static struct kobject *cgroup_kobj;
>=20
> cgroup_init(void) {
> ...
> cgroup_kobj =3D kobject_create_and_add("cgroup", fs_kobj);
>   if (!cgroup_kobj) {
>   err =3D -ENOMEM;
>   goto out;
>   }
>=20
> }
>=20
> I wondered about this two points:
> 1) why is the /sys/fs/cgroup entry created at all?
> 2) why is this done as a sysfs entry.
>=20
> The cgroup_kobj is not used anywhere in this module apart from
> its creation above (and destroying if we later fail with
> register_filesystem() in this same method). I don't see anywhere usag=
e
> of syfs API to create files underneath
> it. In fact, the entries beneath it are created by mkdir of admin or
> systemd code. so what's the point of it being a sysfs entry ? wouldn'=
t
> simply mkdir be ok ? and why under /sys/fs?
>=20
> Since cgroups can be mounted by definition on every path, why this is=
 needed?
>=20

It's supposed to be the standard place to mount cgroupfs.

commit 676db4af043014e852f67ba0349dae0071bd11f3
Author: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Date:   Thu Aug 5 13:53:35 2010 -0700

    cgroupfs: create /sys/fs/cgroup to mount cgroupfs on

    We really shouldn't be asking userspace to create new root filesyst=
ems.
    So follow along with all of the other in-kernel filesystems, and pr=
ovide
    a mount point in sysfs.

    For cgroupfs, this should be in /sys/fs/cgroup/  This change provid=
es
    that mount point when the cgroup filesystem is registered in the ke=
rnel.

    Acked-by: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
    Acked-by: Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
    Cc: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
    Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>
