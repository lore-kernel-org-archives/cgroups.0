From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [BUG] cgroup lockup while upgrading udev on debian
Date: Mon, 22 Jan 2018 11:41:05 -0500
Message-ID: <20180122114105.4b66f020@gandalf.local.home>
References: <20180121213108.4218693b@gandalf.local.home>
        <20180122163051.GE1096857@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180122163051.GE1096857@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Mon, 22 Jan 2018 08:30:51 -0800
Tejun Heo <tj@kernel.org> wrote:

> It looks like the same bug which was fixed by 74d0833c659a ("cgroup:
> fix css_task_iter crash on CSS_TASK_ITER_PROC").  The bug got
> introduced durinv v4.14 cycle and triggers when cgroup1 and cgroup2
> are used at the same time, which the recent versions of systemd does
> when in cgroup1 mode.
>

Thanks Tejun,

I'll have to upgrade my systems to the lastest stable, before doing any
other upgrades.

-- Steve
