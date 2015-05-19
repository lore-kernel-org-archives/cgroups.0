From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v12 8/8] cgroup: implement the PIDs subsystem
Date: Tue, 19 May 2015 18:44:39 +1000
Message-ID: <CAOviyaij2bays4aYQ_5HcopcBOfj4M_gKE7oQ_FsV38skK6vWA@mail.gmail.com>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
	<1431960667-26593-9-git-send-email-cyphar@cyphar.com>
	<20150519080055.GA3644@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150519080055.GA3644@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, mingo@redhat.com, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>

>> However, it should be noted that organisational operations (adding and
>> removing tasks from a PIDs hierarchy) will *not* be prevented.
>
> This is how you spell: broken controller.

This has been discussed before. Organisational operations (i.e.
attaching to a cgroup) are not to be blocked by a cgroup controller in
the unified hierarchy. You simply can't escape out of a parent
cgroup's limit through attaching to a child cgroup (because you will
attach either before the fork checks against the cgroup [in which case
the child's limit is followed -- which means you also follow the
parent's limit] or after it checks [which means you'll hit the
parent's limit and won't be able to fork]).

--
Aleksa Sarai (cyphar)
www.cyphar.com
