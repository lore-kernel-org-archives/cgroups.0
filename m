From: "Moessbauer, Felix" <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Wed, 10 Nov 2021 15:21:54 +0000
Message-ID: <AM9PR10MB4869C14EAE01B87C0037BF6A89939@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211110111357.17617-1-felix.moessbauer@siemens.com>
 <20211110135653.GD20566@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0qRMyI8auFOGLBDH0E8gQPrF0wZc8jAySp3hMZCv30=;
 b=zqkvKrLSA6rAcm8UPfhqrGtCGGT6A5B8l5AKmWNKhDn0RWRNEWSmi/qx+X6AZFKpMe9TgneUNkDcTB8EYuoPwTJQq8llXttBPb2jngI+yKW4yEBocICbYXdmbvE1zl4P1an5Q4qO2hteOTHsnHLp5pwuxwcn9aHK/8qk6MoDqGxfYG7Bw+kPrSg7s1uzk5cLxIVZFdklRhZifBaUCvvvjt/jxKjZAlKPFqkhRLbrCjpBO6KrtT2WZiNZ6i9/Dw9LWoU2uyMitGkduEUTv2DHa0mBuKmqL/Bj9h4A0+XeBXWZmU0t/XH6lVevBSQLVKNhceGK8ZQrVtdhp6ZjQqv3Hg==
In-Reply-To: <20211110135653.GD20566-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: de-DE
List-ID: <cgroups.vger.kernel.org>
To: =?iso-8859-1?Q?Michal_Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: "longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "guro-b10kYP2dOMg@public.gmane.org" <guro-b10kYP2dOMg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, t



> -----Original Message-----
> From: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Sent: Wednesday, November 10, 2021 2:57 PM
> To: Moessbauer, Felix (T RDA IOT SES-DE) <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
> Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org;
> cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; corbet-T1hC0tSOHrs@public.gmane.org; frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; guro-b10kYP2dOMg@public.gmane.org=
;
> hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org; juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; lin=
ux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org; mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org; shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Kiszka, Jan (T RDA
> IOT) <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>; Schild, Henning (T RDA IOT SES-DE)
> <henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
> Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type =
&
> empty effecitve cpus
>=20
> Hello.
>=20
> On Wed, Nov 10, 2021 at 12:13:57PM +0100, Felix Moessbauer
> <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> > However, I was not able to see any latency improvements when using
> > cpuset.cpus.partition=3Disolated.
>=20
> Interesting. What was the baseline against which you compared it (isolcpu=
s, no
> cpusets,...)?

For this test, I just compared both settings cpuset.cpus.partition=3Disolat=
ed|root.
There, I did not see a significant difference (but I know, RT tuning depend=
s on a ton of things).

>=20
> > The test was performed with jitterdebugger on CPUs 1-3 and the followin=
g
> cmdline:
> > rcu_nocbs=3D1-4 nohz_full=3D1-4 irqaffinity=3D0,5-6,11 intel_pstate=3Dd=
isable
> > On the other cpus, stress-ng was executed to generate load.
> > [...]
>=20
> > This requires cgroup.type=3Dthreaded on both cgroups and changes to the
> > application (threads have to be born in non-rt group and moved to rt-gr=
oup).
>=20
> But even with isolcpus the application would need to set affinity of thre=
ads to
> the selected CPUs (cf cgroup migrating). Do I miss anything?

Yes, that's true. But there are two differences (given that you use isolcpu=
s):
1. the application only has to set the affinity for rt threads.
 Threads that do not explicitly set the affinity are automatically excluded=
 from the isolated cores.
 Even common rt test applications like jitterdebugger do not pin their non-=
rt threads.
2. Threads can be started on non-rt CPUs and then bound to a specific rt CP=
U.
This binding can be specified before thread creation via pthread_create.
By that, you can make sure that at no point in time a thread has a "forbidd=
en" CPU in its affinities.

With cgroup2, you cannot guarantee the second aspect, as thread creation an=
d moving to a cgroup is not an atomic operation.
Also - please correct me if I'm wrong - you first have to create a thread b=
efore moving it into a group.
At creation time, you cannot set the final affinity mask (as you create it =
in the non-rt group and there the CPU is not in the cpuset.cpus).
Once you move the thread to the rt cgroup, it has a default mask and by tha=
t can be executed on other rt cores.

Best regards,
Felix

>=20
> Thanks,
> Michal
