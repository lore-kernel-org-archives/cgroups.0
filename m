From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v6 4/7] cgroup: cgroup v2 freezer
Date: Thu, 14 Feb 2019 17:26:13 +0100
Message-ID: <20190214162612.GC19102@redhat.com>
References: <20181222000307.28231-1-guro@fb.com>
 <20181222000307.28231-5-guro@fb.com>
 <20190125122713.GA18218@redhat.com>
 <CALo0P13XnGiFykMXY3ZKu158ZqnBwHru0gyhQUrJSHEprnmiHQ@mail.gmail.com>
 <20190130165200.GA4131@redhat.com>
 <20190211213036.GA26063@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211213036.GA26063@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 02/11, Roman Gushchin wrote:
>
> On Wed, Jan 30, 2019 at 05:52:01PM +0100, Oleg Nesterov wrote:
> >
> > Worse, this looks just wrong. In the latter case, cgroup becomes CGRP_FROZEN
> > right after a 2nd task migrates to this cgroup, before this new task calls
> > do_freezer_trap() or cgroup_enter_stopped().
>
> You're right. So, it looks like the problem is in the equation
> nr_tasks_frozen + nr_tasks_stopped == nr_tasks_to_freeze ,
> because a task can be frozen and stopped simultaneously.
>
> So, basically it has to be
> nr_tasks_frozen + nr_tasks_stopped >= nr_tasks_to_freeze instead.

It seems you didn't read the paragraph above, or I missed something...

How can "frozen + stopped >= to_freeze" fix the problem with the falsely true
CGRP_FROZEN ?

Oleg.

