From: "Enrico Weigelt, metux IT consult" <lkml-EcKl7qYKIbxeoWH0uzbU5w@public.gmane.org>
Subject: Re: Prevent inode/dentry trashing?
Date: Mon, 28 Jun 2021 11:40:39 +0200
Message-ID: <88451906-e537-0ac3-b8f2-16bfc4d77ea6@metux.net>
References: <ce330972-78e6-4347-9735-72ee7bb21ef5@pmhahn.de>
 <YNX8anv2yCnkVPXy@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YNX8anv2yCnkVPXy@blackbook>
Content-Language: tl
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Philipp Hahn <pmhahn+lkml-isSyJ6YaLy+zQB+pC5nmwQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 25.06.21 17:55, Michal Koutn=FD wrote:
>> Is it possible to prevent inode/dentry trashing for example by limiting =
the
>> cache per process(-group)?
>=20
> Yes. Unless you have disabled it with CONFIG_MEMCG_KMEM or
> cgroup.memory=3Dnokmem, dentries and inodes are charged to respective
> cgroups. And you can limit overall memory of a cgroup, see
> memory.{max,high} attributes. (You suggest this inode/dentry consumption
> is dominant enough to affect other jobs, so the limit would keep it
> constrained as you intend).

Could you please tell a bit more how this really works ?
(maybe some pointers to the code)

I'm curios what happens if those cache objects are used by different
cgroups - are they accounted to multiple times (once per cgroup) ?
What happens when one cgroup using some cache object reaching its limit,
wile another one does not ?


--mtx

--=20
---
Hinweis: unverschl=FCsselte E-Mails k=F6nnen leicht abgeh=F6rt und manipuli=
ert
werden ! F=FCr eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schl=FCssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info-EcKl7qYKIbxeoWH0uzbU5w@public.gmane.org -- +49-151-27565287
