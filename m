From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH] sched/core: Fix cpu controller for !RT_GROUP_SCHED
Date: Wed, 5 Jun 2019 16:20:03 +0200
Message-ID: <20190605142003.GD4255@blackbody.suse.cz>
References: <20190605114935.7683-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190605114935.7683-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, lizefan@huawei.com, tj@kernel.org, bristot@redhat.com, luca.abeni@santannapisa.it, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jun 05, 2019 at 01:49:35PM +0200, Juri Lelli <juri.lelli@redhat.com> wrote:
> Existing code comes with a comment saying the "we don't support RT-tasks
> being in separate groups".
I'm also inclined to this check not being completely correct.

This guard also prevents enabling cpu controller on unified hierarchy
with !CONFIG_RT_GROUP_SCHED. (If there are any kernel RT threads in root
cgroup, they can't be migrated to the newly create cpu controller's root
in cgroup_update_dfl_csses().)

I considered relaxing the check to non-root cgroups only, however, as
your example shows, it doesn't prevent reaching the avoided state by
other paths. I'm not that familiar with RT sched to tell whether
RT-priority tasks in different task_groups break any assumptions.

Michal
