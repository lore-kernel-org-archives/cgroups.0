From: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: BUG: KASAN: null-ptr-deref in workingset_eviction+0xf2/0x1e0
Date: Tue, 1 Dec 2020 14:38:50 +0530
Message-ID: <CA+G9fYs8jzvh6c3sfaMoCetQydtSrzsmcUvG4DpPW33bad7Q0A@mail.gmail.com>
References: <CA+G9fYtk3fKy7ct-rT=T8iFDhE4CbjGgdfxsOBrKT9y8ntwXyg@mail.gmail.com>
 <58f66f22-fd5f-685d-e608-99c35d89c1a3@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S+Ngn4W/oQtuMxlBFu4kHeU3p7nhm6p8xjw9712a+hg=;
        b=a1xDBC0NB1WegU5JwLnZPeJz2v97WB28CL0vAfurTSZNAoShRCXmC95d3JszRXT8V2
         t47DSCSTXBLukV4RQqIXsQnrhr/HM/xRMmAlJs5xV8uW8100Cy9Z++tUUSqc9mt/66r+
         C7zlSHICvqkcIRc7XolTcgpJitMlO1FBjS1utDfmAwsQkNaZVOZEyw2JFuyf0w+WfxLT
         e2I8DpbCs7yCV7cmmNDt4SphJREPbyXf81PsCX3pEukIGegJ1hbWRaWt89vhrqdqhFyK
         oAjflrkxgLhtnaAtj0D13J65wTDkcPV++R8Dc3ox0c3PdP1EchtZPQlqRlCsdZXqesef
         TA0g==
In-Reply-To: <58f66f22-fd5f-685d-e608-99c35d89c1a3-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: inux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, richard.weiyang-Re5JQEeQqe8@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

Hi Alex,

On Tue, 1 Dec 2020 at 13:14, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
>
>
> =E5=9C=A8 2020/12/1 =E4=B8=8A=E5=8D=883:52, Naresh Kamboju =E5=86=99=E9=
=81=93:
> > Crash log:
> > -----------
> > ioctl_sg01.c:81: TINFO: Found SCSI device /dev/sg1
> > [  285.862123] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [  285.863025] BUG: KASAN: null-ptr-deref in workingset_eviction+0xf2/0=
x1e0
> > [  285.863025] Read of size 4 at addr 00000000000000c8 by task kswapd0/=
245
>
> Hi Naresh,
>
> Good to know you again. :)

Same here :)

>
> Would you like to use command to check whichh line cause the panic:
>
> scripts/faddr2line vmlinux workingset_eviction+0xf2/0x1e0

scripts/faddr2line vmlinux workingset_eviction+0xf2/0x1e0
workingset_eviction+0xf2/0x1e0:
workingset_eviction at ??:?


vmlinux and system.map files available in this location,
https://builds.tuxbuild.com/1l0FDtgxYSNunuG5ERIXtvPjZ7R/

>
> I can't reproduce it. and my gcc version mismatch with yours.

Please run below easy steps to reproduce.
you may install docker and tuxmake.

Please share if you have any debug patch or proposed fix patch,
I would be happy to test.

Steps to reproduce:
--------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.

# tuxmake --runtime docker --target-arch x86_64 --toolchain gcc-9 \
--kconfig defconfig \
--kconfig-add https://builds.tuxbuild.com/1l0FDtgxYSNunuG5ERIXtvPjZ7R/confi=
g

# run LTP
# cd /opt/ltp
# ./runltp -s ioctl_sg01
# you see below crash

- Naresh
