From: Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: fix var may be used uninitialized warning
Date: Tue, 03 Mar 2015 16:12:49 +0100
Message-ID: <54F5CF71.7060405@collabora.co.uk>
References: <1425373187-7227-1-git-send-email-javier.martinez@collabora.co.uk> <20150303134642.GD3122@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150303134642.GD3122-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Tejun,

On 03/03/2015 02:46 PM, Tejun Heo wrote:
> On Tue, Mar 03, 2015 at 09:59:47AM +0100, Javier Martinez Canillas wr=
ote:
>> When building cgroup, GCC warns that the root variable
>> may be used uninitialized in the cgroup_mount function.
>>=20
>> kernel/cgroup.c: In function =E2=80=98cgroup_mount=E2=80=99:
>> kernel/cgroup.c:1886:13: warning: =E2=80=98root=E2=80=99 may be used=
 uninitialized in this function [-Wuninitialized]
>> kernel/cgroup.c:1742:22: note: =E2=80=98root=E2=80=99 was declared h=
ere
>>=20
>> This can never happen because if the struct cgroup_root
>> can't be allocated, ret is set to -ENOMEM and the error
>> returned so the code using root is not reachable. But
>> set root to NULL just to silence the compiler warning.
>=20
> Which compiler are you on?
>

Yeah, I noticed that I was using a pretty old 4.7.2 GCC on
that machine and the warning indeed is not seen with 4.9.1.

Sorry for the noise...

> Thanks.
>

Best regard,
Javier
