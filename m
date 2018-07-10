From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] cgroup/tracing: Move taking of spin lock out of trace
 event handlers
Date: Tue, 10 Jul 2018 18:22:52 +0200
Message-ID: <20180710162252.j5ftyyp2fve64ppv@linutronix.de>
References: <20180709174854.74a30b57@gandalf.local.home>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180709174854.74a30b57@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>

On 2018-07-09 17:48:54 [-0400], Steven Rostedt wrote:
> From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reported-by: Clark Williams <williams@redhat.com>
I just forwarded the report.

> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

I am in favour of this change.

Sebastian
