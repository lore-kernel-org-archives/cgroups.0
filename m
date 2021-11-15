From: "Moessbauer, Felix" <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: RE: Questions about replacing isolcpus by cgroup-v2
Date: Mon, 15 Nov 2021 12:47:51 +0000
Message-ID: <AM9PR10MB486954284391B62D03B9976989989@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
References: <AM9PR10MB48692A964E3106D11AC0FDEE898D9@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
 <20211112153656.qkwyvdmb42ze25iw@linutronix.de>
 <20211112163707.GA315388@lothringen>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NHNiNd4CxBhMyKgrrjEkUgJTnEt3+AEx75Rw6EIktw=;
 b=gGSG1CxHVY6XxiyU4hSfdUcbA+aymS5i+lgneMjBPxJ3iZ+xub+jfQYk8YbmlZJO+XmrjYMR9UFTLvzuJoUL7Mu7B8663phu+5PwaNaOTZjazF+fSE7T0IkNggNya2urAwF3dbe9idQSCujXahitCtgUTs9breODtrd1EiqmAC/eCSsD3A1bqaStFXsk3/CqcKFRFQpy6Zeu4JEcqSPUIMtna4mmcGMabCHmQUktxGagEtMW4mC0BCi22tofacXwJDP1EerHE+RzduXg/j+/PZRGPAPxXEPxUSv20CkrtOCzBZesmzOz8Z0JjHC/xN+/WHDcc+28LoAbAAAtc8SSdw==
In-Reply-To: <20211112163707.GA315388@lothringen>
Content-Language: de-DE
List-ID: <cgroups.vger.kernel.org>
To: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org" <henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org" <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, "Schmidt, Adriaan" <adriaan.schmidt-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi Sebastian,

> -----Original Message-----
> From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Sent: Friday, November 12, 2021 5:37 PM
> To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Moessbauer, Felix (T RDA IOT SES-DE) <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>;
> cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Schild, Henning =
(T
> RDA IOT SES-DE) <henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>; Kiszka, Jan (T RDA IOT)
> <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>; Schmidt, Adriaan (T RDA IOT SES-DE)
> <adriaan.schmidt-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>; Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>; Tejun
> Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>; Waiman Long
> <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Subject: Re: Questions about replacing isolcpus by cgroup-v2
>=20
> On Fri, Nov 12, 2021 at 04:36:56PM +0100, Sebastian Andrzej Siewior wrote=
:
> > On 2021-11-04 17:29:08 [+0000], Moessbauer, Felix wrote:
> > > Dear subscribers,
> > Hi,
> >
> > I Cced cgroups@vger since thus question fits there better.
> > I Cced Frederic in case he has come clues regarding isolcpus and
> > cgroups.
> >
> > > we are currently evaluating how to rework realtime tuning to use cgro=
up-v2
> cpusets instead of the isolcpus kernel parameter.
> > > Our use-case are realtime applications with rt and non-rt threads. He=
reby,
> the non-rt thread might create additional non-rt threads:
> > >
> > > Example (RT CPU=3D1, 4 CPUs):
> > > - Non-RT Thread (A) with default affinity 0xD (1101b)
> > > - RT Thread (B) with Affinity 0x2 (0010b, via set_affinity)
> > >
> > > When using pure isolcpus and cgroup-v1, just setting isolcpus=3D1 per=
fectly
> works:
> > > Thread A gets affinity 0xD, Thread B gets 0x2 and additional threads =
get a
> default affinity of 0xD.
> > > By that, independent of the threads' priorities, we can ensure that n=
othing is
> scheduled on our RT cpu (except from kernel threads, etc...).
> > >
> > > During this journey, we discovered the following:
> > >
> > > Using cgroup-v2 cpusets and isolcpus together seems to be incompatibl=
e:
> > > When activating the cpuset controller on a cgroup (for the first time=
), all
> default CPU affinities are reset.
> > > By that, also the default affinity is set to 0xFFFF..., while with is=
olcpus we
> expect it to be (0xFFFF - isolcpus).
> > > This breaks the example from above, as now the non-RT thread can
> > > also be scheduled on the RT CPU.
>=20
> That sounds buggy from the cpuset-v2 side (adding the maintainers in Cc).
>=20
> Also please have a look into "[PATCH v8 0/6] cgroup/cpuset: Add new cpuse=
t
> partition type & empty effecitve cpus":
>=20
>=20
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.=
kern
> el.org%2Flkml%2F20211018143619.205065-1-
> longman%40redhat.com%2F&amp;data=3D04%7C01%7Cfelix.moessbauer%40sie
> mens.com%7C1a74cbf4e3d140a9031808d9a5faad3c%7C38ae3bcd95794fd4add
> ab42e1495d55a%7C1%7C0%7C637723318334809165%7CUnknown%7CTWFpb
> GZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6M
> n0%3D%7C1000&amp;sdata=3DJm3j2vDvOOtikU5ZpusupQ6d6koPII9oYZZhpDUkvY
> c%3D&amp;reserved=3D0
>=20
> This stuff adds support for a new "isolated" partition type on cpuset/cgr=
oup-v2
> which should behave just like isolcpus.

I already tested the patch and reported back on the ML.
However, it only covers load-balancing aspects, not isolcpu like default af=
finities.
When setting cpusets.cpus.partition=3Disolated, you get similar behavior as=
 with =3Droot
(cpus are removed from all other groups), but the schedulers load-balancing=
 is disabled
for this domain.
For details, please have a look in the other thread.=20

>=20
> > >
> > > When only using cgroup-v2, we can isolate our RT process by placing i=
t in a
> cgroup with CPUs=3D0,1 and remove CPU=3D1 from all other cgroups.
> > > However, we do not know of a strategy to set a default affinity:
> > > Given the example above, we have no way to ensure that newly created
> threads are born with an affinity of just 0x2 (without changing the appli=
cation).
> > >
> > > Finally, isolcpus itself is deprecated since kernel 5.4.
> >
> > Where is this the deprecation of isolcpus announced/ written?
>=20
> We tried to deprecate it but too many people are still using it. Better p=
ick an
> interface that allows you to change the isolated set at runtime like
> cpuset.sched_load_balance on cpuset/cgroup-v1 or the above patchset on v2=
.
>=20

Currently, the only workaround we know of to get isolcpu semantics on syste=
ms where
other tools like container runtimes or libvirt fiddle around with the cpuse=
t controller, is to simply enforce the cgroups-v1.
But maybe we are just running into the bug from above.

Felix

> Thanks.
