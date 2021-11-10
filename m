From: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Wed, 10 Nov 2021 13:10:20 -0300
Message-ID: <20211110161020.GA20101@fuller.cnet>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211110111357.17617-1-felix.moessbauer@siemens.com>
 <20211110135653.GD20566@blackbody.suse.cz>
 <AM9PR10MB4869C14EAE01B87C0037BF6A89939@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636560631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDYzGh+ErslybNotJBfLj6+nXZEA3Pc6sKNXxclE+as=;
        b=RW2EMbm9/fxh31i+UIcnt6plB+7DvoatB7hRB1DE7L3UbfmBggNvuUAfMyhTSLTuaA+/oM
        OCpRmdzAmMUr5+YL85OkZkcPD6vxWBZ9D1OxB30wjS0erQOYppboDBlyKD+QCbM4n7L5FU
        xDCitBBo1JpWezIZCgKSi27Z+7MOfvk=
Content-Disposition: inline
In-Reply-To: <AM9PR10MB4869C14EAE01B87C0037BF6A89939-M49tMopaQCDO+/9PLUklKbUAtUbAAahqZmpNikb/MY7jO8Y7rvWZVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "Moessbauer, Felix" <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "guro-b10kYP2dOMg@public.gmane.org" <guro-b10kYP2dOMg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Wed, Nov 10, 2021 at 03:21:54PM +0000, Moessbauer, Felix wrote:
>=20
>=20
> > -----Original Message-----
> > From: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> > Sent: Wednesday, November 10, 2021 2:57 PM
> > To: Moessbauer, Felix (T RDA IOT SES-DE) <felix.moessbauer-kv7WeFo6aLtB=
DgjK7y7TUQ@public.gmane.org>
> > Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; akpm-de/tnXTf+JLsf=
HDXvbKv3WD2FQJk+8+b@public.gmane.org;
> > cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; corbet-T1hC0tSOHrs@pub=
lic.gmane.org; frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; guro-b10kY=
P2dOMg@public.gmane.org;
> > hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org; juri.lelli-H+wXaHxf7aLQ=
T0dZR+AlfA@public.gmane.org; linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.=
org; linux-
> > kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kselftest-u79uwXL=
29TY76Z2rM5mHXA@public.gmane.org;
> > lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org; mtosatti-H+wXaHxf7aL=
QT0dZR+AlfA@public.gmane.org; pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> > peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org; shuah-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org; tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Kiszka,=
 Jan (T RDA
> > IOT) <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>; Schild, Henn=
ing (T RDA IOT SES-DE)
> > <henning.schild-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
> > Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition typ=
e &
> > empty effecitve cpus
> >=20
> > Hello.
> >=20
> > On Wed, Nov 10, 2021 at 12:13:57PM +0100, Felix Moessbauer
> > <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> > > However, I was not able to see any latency improvements when using
> > > cpuset.cpus.partition=3Disolated.
> >=20
> > Interesting. What was the baseline against which you compared it (isolc=
pus, no
> > cpusets,...)?
>=20
> For this test, I just compared both settings cpuset.cpus.partition=3Disol=
ated|root.
> There, I did not see a significant difference (but I know, RT tuning depe=
nds on a ton of things).
>=20
> >=20
> > > The test was performed with jitterdebugger on CPUs 1-3 and the follow=
ing
> > cmdline:
> > > rcu_nocbs=3D1-4 nohz_full=3D1-4 irqaffinity=3D0,5-6,11 intel_pstate=
=3Ddisable
> > > On the other cpus, stress-ng was executed to generate load.
> > > [...]
> >=20
> > > This requires cgroup.type=3Dthreaded on both cgroups and changes to t=
he
> > > application (threads have to be born in non-rt group and moved to rt-=
group).
> >=20
> > But even with isolcpus the application would need to set affinity of th=
reads to
> > the selected CPUs (cf cgroup migrating). Do I miss anything?
>=20
> Yes, that's true. But there are two differences (given that you use isolc=
pus):
> 1. the application only has to set the affinity for rt threads.
>  Threads that do not explicitly set the affinity are automatically exclud=
ed from the isolated cores.
>  Even common rt test applications like jitterdebugger do not pin their no=
n-rt threads.
> 2. Threads can be started on non-rt CPUs and then bound to a specific rt =
CPU.
> This binding can be specified before thread creation via pthread_create.
> By that, you can make sure that at no point in time a thread has a "forbi=
dden" CPU in its affinities.
>=20
> With cgroup2, you cannot guarantee the second aspect, as thread creation =
and moving to a cgroup is not an atomic operation.
> Also - please correct me if I'm wrong - you first have to create a thread=
 before moving it into a group.
> At creation time, you cannot set the final affinity mask (as you create i=
t in the non-rt group and there the CPU is not in the cpuset.cpus).
> Once you move the thread to the rt cgroup, it has a default mask and by t=
hat can be executed on other rt cores.

man clone3:

       CLONE_NEWCGROUP (since Linux 4.6)
              Create  the  process  in  a  new cgroup namespace.  If this f=
lag is not set, then (as with fork(2)) the
              process is created in the same cgroup namespaces as the calli=
ng process.

              For further information on cgroup namespaces, see cgroup_name=
spaces(7).

              Only a privileged process (CAP_SYS_ADMIN) can employ CLONE_NE=
WCGROUP.

