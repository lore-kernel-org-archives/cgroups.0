From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Sat, 10 Mar 2018 04:47:28 +0100
Message-ID: <1520653648.12749.20.camel@gmx.de>
References: <1520609707-16582-1-git-send-email-longman@redhat.com>
         <1520613285.12489.36.camel@gmx.de>
         <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
         <1520619426.27998.18.camel@gmx.de>
         <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
         <1520624424.27998.76.camel@gmx.de>
         <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
         <20180309221736.GB5926@hirez.programming.kicks-ass.net>
         <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On Fri, 2018-03-09 at 18:06 -0500, Waiman Long wrote:
> On 03/09/2018 05:17 PM, Peter Zijlstra wrote:
> > On Fri, Mar 09, 2018 at 03:43:34PM -0500, Waiman Long wrote:
> >> The isolcpus=3D parameter just reduce the cpus available to the rests =
of
> >> the system. The cpuset controller does look at that value and make
> >> adjustment accordingly, but it has no dependence on exclusive cpu/mem
> >> features of cpuset.
> > The isolcpus=3D boot param is donkey shit and needs to die. cpuset _use=
d_
> > to be able to fully replace it, but with the advent of cgroup 'feature'
> > this got lost.
> >
> > And instead of fixing it, you're making it _far_ worse. You completely
> > removed all the bits that allow repartitioning the scheduler domains.
> >
> > Mike is completely right, full NAK on any such approach.
>=20
> So you are talking about sched_relax_domain_level and
> sched_load_balance. I have not removed any bits. I just haven't exposed
> them yet. It does seem like these 2 control knobs are useful from the
> scheduling perspective. Do we also need cpu_exclusive or just the two
> sched control knobs are enough?

Some form of cpu_exclusive (preferably exactly that, but something else
could replace it) is needed to define sets that must not overlap any
other set at creation time or any time thereafter. =A0A set with property
'exclusive' is the enabler for fundamentally exclusive (but dynamic!)
set properties such as 'isolated' (etc etc).

	-Mike
