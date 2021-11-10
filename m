From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Wed, 10 Nov 2021 13:14:29 -0300
Message-ID: <20211110161429.GA22855@fuller.cnet>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211110111357.17617-1-felix.moessbauer@siemens.com>
 <20211110135653.GD20566@blackbody.suse.cz>
 <AM9PR10MB4869C14EAE01B87C0037BF6A89939@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
 <20211110161020.GA20101@fuller.cnet>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636560916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pujqTrjEVvmX1Jx376eksYnuy7UjFSMiFW1jzdmHKRE=;
        b=HKyWsFTy5AbnOGPcwQnm/29BaJ3R93f7cbU9kIxrHEirA+OFSH4zgICWg6CCJNUc76Gfer
        qz0O6jCs8Zr3Mp88KjTmwTg4fu4JJth7lcyv1JWioggh9w7wAfdid1u2cFP6hIJfekyLv0
        /jtjTkmZN7WLCTENVv2eBIGJVQkWPTI=
Content-Disposition: inline
In-Reply-To: <20211110161020.GA20101@fuller.cnet>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "Moessbauer, Felix" <felix.moessbauer@siemens.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, "longman@redhat.com" <longman@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, "frederic@kernel.org" <frederic@kernel.org>, "guro@fb.com" <guro@fb.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "pauld@redhat.com" <pauld@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "shuah@kernel.org" <shuah@kernel.org>

On Wed, Nov 10, 2021 at 01:10:20PM -0300, Marcelo Tosatti wrote:
> On Wed, Nov 10, 2021 at 03:21:54PM +0000, Moessbauer, Felix wrote:
> >=20
> >=20
> > > -----Original Message-----
> > > From: Michal Koutn=FD <mkoutny@suse.com>
> > > Sent: Wednesday, November 10, 2021 2:57 PM
> > > To: Moessbauer, Felix (T RDA IOT SES-DE) <felix.moessbauer@siemens.co=
m>
> > > Cc: longman@redhat.com; akpm@linux-foundation.org;
> > > cgroups@vger.kernel.org; corbet@lwn.net; frederic@kernel.org; guro@fb=
.com;
> > > hannes@cmpxchg.org; juri.lelli@redhat.com; linux-doc@vger.kernel.org;=
 linux-
> > > kernel@vger.kernel.org; linux-kselftest@vger.kernel.org;
> > > lizefan.x@bytedance.com; mtosatti@redhat.com; pauld@redhat.com;
> > > peterz@infradead.org; shuah@kernel.org; tj@kernel.org; Kiszka, Jan (T=
 RDA
> > > IOT) <jan.kiszka@siemens.com>; Schild, Henning (T RDA IOT SES-DE)
> > > <henning.schild@siemens.com>
> > > Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition t=
ype &
> > > empty effecitve cpus
> > >=20
> > > Hello.
> > >=20
> > > On Wed, Nov 10, 2021 at 12:13:57PM +0100, Felix Moessbauer
> > > <felix.moessbauer@siemens.com> wrote:
> > > > However, I was not able to see any latency improvements when using
> > > > cpuset.cpus.partition=3Disolated.
> > >=20
> > > Interesting. What was the baseline against which you compared it (iso=
lcpus, no
> > > cpusets,...)?
> >=20
> > For this test, I just compared both settings cpuset.cpus.partition=3Dis=
olated|root.
> > There, I did not see a significant difference (but I know, RT tuning de=
pends on a ton of things).
> >=20
> > >=20
> > > > The test was performed with jitterdebugger on CPUs 1-3 and the foll=
owing
> > > cmdline:
> > > > rcu_nocbs=3D1-4 nohz_full=3D1-4 irqaffinity=3D0,5-6,11 intel_pstate=
=3Ddisable
> > > > On the other cpus, stress-ng was executed to generate load.
> > > > [...]
> > >=20
> > > > This requires cgroup.type=3Dthreaded on both cgroups and changes to=
 the
> > > > application (threads have to be born in non-rt group and moved to r=
t-group).
> > >=20
> > > But even with isolcpus the application would need to set affinity of =
threads to
> > > the selected CPUs (cf cgroup migrating). Do I miss anything?
> >=20
> > Yes, that's true. But there are two differences (given that you use iso=
lcpus):
> > 1. the application only has to set the affinity for rt threads.
> >  Threads that do not explicitly set the affinity are automatically excl=
uded from the isolated cores.
> >  Even common rt test applications like jitterdebugger do not pin their =
non-rt threads.
> > 2. Threads can be started on non-rt CPUs and then bound to a specific r=
t CPU.
> > This binding can be specified before thread creation via pthread_create.
> > By that, you can make sure that at no point in time a thread has a "for=
bidden" CPU in its affinities.
> >=20
> > With cgroup2, you cannot guarantee the second aspect, as thread creatio=
n and moving to a cgroup is not an atomic operation.
> > Also - please correct me if I'm wrong - you first have to create a thre=
ad before moving it into a group.
> > At creation time, you cannot set the final affinity mask (as you create=
 it in the non-rt group and there the CPU is not in the cpuset.cpus).
> > Once you move the thread to the rt cgroup, it has a default mask and by=
 that can be executed on other rt cores.
>=20
> man clone3:
>=20
>        CLONE_NEWCGROUP (since Linux 4.6)
>               Create  the  process  in  a  new cgroup namespace.  If this=
 flag is not set, then (as with fork(2)) the
>               process is created in the same cgroup namespaces as the cal=
ling process.
>=20
>               For further information on cgroup namespaces, see cgroup_na=
mespaces(7).
>=20
>               Only a privileged process (CAP_SYS_ADMIN) can employ CLONE_=
NEWCGROUP.
>=20

Err, CLONE_INTO_CGROUP.

