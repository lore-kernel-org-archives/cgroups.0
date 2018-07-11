From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/tracing: Move taking of spin lock out of trace
 event handlers
Date: Wed, 11 Jul 2018 10:49:40 -0700
Message-ID: <20180711174940.GH72677@devbig577.frc2.facebook.com>
References: <20180709174854.74a30b57@gandalf.local.home>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NeGXoR8z44F7IqX2W2+SCPz8Ki85jqIZ9XhKRi3d7Cs=;
        b=Cz7E2fRh+SxU3POQD7g4SnSEw6+Q6VXkOLlmL3BxaIRq3XjGKSzE+ZvekuhHo4MJcT
         KqgYegWecbHoUZQy5+2W9qRp3P94ftBvg7G0CNDHKu0VUaGDMEzSqfqgSSQa7xot+qB6
         Z/PT/Hp/eiiD8d7MMqjigSKU1p4oVVIaVo3FmRiDGuYiNir7+UjcLARJQCMvrtcBKtxa
         EKz0x9BZvUGDhGyufyJRCfH+Gs08czwAM3XGwjt/C89JO2xIS9672OLq9hWeAVzyEjTo
         KquUvmj44BWdXSThl70CkakJMPWz4JkWfi9ANvvfHRlXkjADe9uchFnknOFT1yEUkHnx
         ASMw==
Content-Disposition: inline
In-Reply-To: <20180709174854.74a30b57@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

On Mon, Jul 09, 2018 at 05:48:54PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> It is unwise to take spin locks from the handlers of trace events.
> Mainly, because they can introduce lockups, because it introduces locks
> in places that are normally not tested. Worse yet, because trace events
> are tucked away in the include/trace/events/ directory, locks that are
> taken there are forgotten about.
> 
> As a general rule, I tell people never to take any locks in a trace
> event handler.
> 
> Several cgroup trace event handlers call cgroup_path() which eventually
> takes the kernfs_rename_lock spinlock. This injects the spinlock in the
> code without people realizing it. It also can cause issues for the
> PREEMPT_RT patch, as the spinlock becomes a mutex, and the trace event
> handlers are called with preemption disabled.
> 
> By moving the calculation of the cgroup_path() out of the trace event
> handlers and into a macro (surrounded by a
> trace_cgroup_##type##_enabled()), then we could place the cgroup_path
> into a string, and pass that to the trace event. Not only does this
> remove the taking of the spinlock out of the trace event handler, but
> it also means that the cgroup_path() only needs to be called once (it
> is currently called twice, once to get the length to reserver the
> buffer for, and once again to get the path itself. Now it only needs to
> be done once.
> 
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Applied to cgroup/for-4.19.

Thanks.

-- 
tejun
