From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH] sched/core: Fix cpu controller for !RT_GROUP_SCHED
Date: Wed, 19 Jun 2019 14:34:05 +0200
Message-ID: <20190619123405.GN26005@localhost.localdomain>
References: <20190605114935.7683-1-juri.lelli@redhat.com>
 <20190605142003.GD4255@blackbody.suse.cz>
 <20190619092904.GB28937@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190619092904.GB28937@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, lizefan@huawei.com, tj@kernel.org, bristot@redhat.com, luca.abeni@santannapisa.it, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

On 19/06/19 11:29, Michal Koutn=FD wrote:
> On Wed, Jun 05, 2019 at 04:20:03PM +0200, Michal Koutn=FD <mkoutny@suse.c=
om> wrote:
> > I considered relaxing the check to non-root cgroups only, however, as
> > your example shows, it doesn't prevent reaching the avoided state by
> > other paths. I'm not that familiar with RT sched to tell whether
> > RT-priority tasks in different task_groups break any assumptions.
> So I had another look and the check is bogus.
>=20
> The RT sched with !CONFIG_RT_GROUP_SCHED works only with the struct
> rt_rq embedded in the generic struct rq -- regardless of the task's
> membership in the cpu controller hierarchy.

Yep.

> Perhaps, the commit message may mention this also prevents enabling cpu
> controller on unified hierarchy (if there are any (kernel) RT tasks to
> migrate).

Sure. Can add such a comment.

> Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

Thanks!

Peter?

Best,

Juri
