From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: A problem with memory.oom_control
Date: Tue, 15 Apr 2014 10:49:41 +0800
Message-ID: <534C9E45.9090005@huawei.com>
References: <CAGXs5wUdhEYQ-kGEPSD2A=OceZuA1tovLs04gPcRcqBPagQJCw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXs5wUdhEYQ-kGEPSD2A=OceZuA1tovLs04gPcRcqBPagQJCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

=E4=BA=8E 2014/4/14 19:54, Kevin Wilson =E5=86=99=E9=81=93:
> Hello,
>=20
> First I hope this mailing list is the proper one for asking the
> following question:
> I do the following, as root,  on Fedora 20 with 3.12.7-300.fc20.x86_6=
4 kernel:
>=20
> create a cgroup called "0"
> /sys/fs/cgroup/memory/0
>=20
> run:
>=20
> echo "1" > /sys/fs/cgroup/memory/0/memory.oom_control
> bash: echo: write error: Invalid argument
>=20
> Why am I having this error  ?
>=20
> According to the documentation:
>=20
> http://lxr.free-electrons.com/source/Documentation/cgroups/memory.txt
> this should work.
>=20

Check if /sys/fs/cgroup/memory/memory/use_hierarchy is 1, if so the fai=
lure
is an expectecd bahavior.

"This operation is only allowed to the top cgroup of a sub-hierarchy."
