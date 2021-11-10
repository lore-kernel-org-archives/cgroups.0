From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Wed, 10 Nov 2021 14:29:46 -0300
Message-ID: <20211110172946.GA30250@fuller.cnet>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211110111357.17617-1-felix.moessbauer@siemens.com>
 <20211110135653.GD20566@blackbody.suse.cz>
 <AM9PR10MB4869C14EAE01B87C0037BF6A89939@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
 <20211110161020.GA20101@fuller.cnet>
 <c1e94031-a179-dc72-e5ee-3f8197bea492@siemens.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636565412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Ujzpstdx7glfvVqivgfVsPUAxC6nAewWUKzEFliz9k=;
        b=deOH+mmFos5mW0Ehiz1V2NR+bykIhZ2QZvXHon7T4jFb3nU42o6X2OODiB3hEPDK99LjE5
        nG34ExtFNoy9gvl98hSSsukjMK6bV0heHm4Ki/V7+EuKzPfsR5uTZpVynjHEocZlQLjBDV
        nks+55u72u9kCNdhXx2Tnd2DkiPT8BQ=
Content-Disposition: inline
In-Reply-To: <c1e94031-a179-dc72-e5ee-3f8197bea492@siemens.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "Moessbauer, Felix" <felix.moessbauer@siemens.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, "longman@redhat.com" <longman@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, "frederic@kernel.org" <frederic@kernel.org>, "guro@fb.com" <guro@fb.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "pauld@redhat.com" <pauld@redhat.com>, "peterz@infradead.org" <peterz@infra>

On Wed, Nov 10, 2021 at 05:15:41PM +0100, Jan Kiszka wrote:
> On 10.11.21 17:10, Marcelo Tosatti wrote:
> > On Wed, Nov 10, 2021 at 03:21:54PM +0000, Moessbauer, Felix wrote:
> >>
> >>
> >>> -----Original Message-----
> >>> From: Michal Koutn=FD <mkoutny@suse.com>
> >>> Sent: Wednesday, November 10, 2021 2:57 PM
> >>> To: Moessbauer, Felix (T RDA IOT SES-DE) <felix.moessbauer@siemens.co=
m>
> >>> Cc: longman@redhat.com; akpm@linux-foundation.org;
> >>> cgroups@vger.kernel.org; corbet@lwn.net; frederic@kernel.org; guro@fb=
.com;
> >>> hannes@cmpxchg.org; juri.lelli@redhat.com; linux-doc@vger.kernel.org;=
 linux-
> >>> kernel@vger.kernel.org; linux-kselftest@vger.kernel.org;
> >>> lizefan.x@bytedance.com; mtosatti@redhat.com; pauld@redhat.com;
> >>> peterz@infradead.org; shuah@kernel.org; tj@kernel.org; Kiszka, Jan (T=
 RDA
> >>> IOT) <jan.kiszka@siemens.com>; Schild, Henning (T RDA IOT SES-DE)
> >>> <henning.schild@siemens.com>
> >>> Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition t=
ype &
> >>> empty effecitve cpus
> >>>
> >>> Hello.
> >>>
> >>> On Wed, Nov 10, 2021 at 12:13:57PM +0100, Felix Moessbauer
> >>> <felix.moessbauer@siemens.com> wrote:
> >>>> However, I was not able to see any latency improvements when using
> >>>> cpuset.cpus.partition=3Disolated.
> >>>
> >>> Interesting. What was the baseline against which you compared it (iso=
lcpus, no
> >>> cpusets,...)?
> >>
> >> For this test, I just compared both settings cpuset.cpus.partition=3Di=
solated|root.
> >> There, I did not see a significant difference (but I know, RT tuning d=
epends on a ton of things).
> >>
> >>>
> >>>> The test was performed with jitterdebugger on CPUs 1-3 and the follo=
wing
> >>> cmdline:
> >>>> rcu_nocbs=3D1-4 nohz_full=3D1-4 irqaffinity=3D0,5-6,11 intel_pstate=
=3Ddisable
> >>>> On the other cpus, stress-ng was executed to generate load.
> >>>> [...]
> >>>
> >>>> This requires cgroup.type=3Dthreaded on both cgroups and changes to =
the
> >>>> application (threads have to be born in non-rt group and moved to rt=
-group).
> >>>
> >>> But even with isolcpus the application would need to set affinity of =
threads to
> >>> the selected CPUs (cf cgroup migrating). Do I miss anything?
> >>
> >> Yes, that's true. But there are two differences (given that you use is=
olcpus):
> >> 1. the application only has to set the affinity for rt threads.
> >>  Threads that do not explicitly set the affinity are automatically exc=
luded from the isolated cores.
> >>  Even common rt test applications like jitterdebugger do not pin their=
 non-rt threads.
> >> 2. Threads can be started on non-rt CPUs and then bound to a specific =
rt CPU.
> >> This binding can be specified before thread creation via pthread_creat=
e.
> >> By that, you can make sure that at no point in time a thread has a "fo=
rbidden" CPU in its affinities.
> >>
> >> With cgroup2, you cannot guarantee the second aspect, as thread creati=
on and moving to a cgroup is not an atomic operation.
> >> Also - please correct me if I'm wrong - you first have to create a thr=
ead before moving it into a group.
> >> At creation time, you cannot set the final affinity mask (as you creat=
e it in the non-rt group and there the CPU is not in the cpuset.cpus).
> >> Once you move the thread to the rt cgroup, it has a default mask and b=
y that can be executed on other rt cores.
> >=20
> > man clone3:
> >=20
> >        CLONE_NEWCGROUP (since Linux 4.6)
> >               Create  the  process  in  a  new cgroup namespace.  If th=
is flag is not set, then (as with fork(2)) the
> >               process is created in the same cgroup namespaces as the c=
alling process.
> >=20
> >               For further information on cgroup namespaces, see cgroup_=
namespaces(7).
> >=20
> >               Only a privileged process (CAP_SYS_ADMIN) can employ CLON=
E_NEWCGROUP.
> >=20
>=20
> Is there pthread_attr_setcgroup_np()?
>=20
> Jan

Don't know... Waiman?=20

