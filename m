From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH] clone3: fix cgroup argument sanity check
Date: Sun, 12 Apr 2020 23:10:53 +0200
Message-ID: <20200412211053.fs54wfguvttav7j6@wittgenstein>
References: <20200412202533.GA29554@asgard.redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200412202533.GA29554@asgard.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eugene Syromiatnikov <esyr@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christian Brauner <christian@brauner.io>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>

On Sun, Apr 12, 2020 at 10:25:33PM +0200, Eugene Syromiatnikov wrote:
> Checking that cgroup field value of struct clone_args is less than 0
> is useless, as it is defined as unsigned 64-bit integer.  Moreover,
> it doesn't catch the situations where its higher bits are lost during
> the assignment to the cgroup field of the cgroup field of the internal
> struct kernel_clone_args (where it is declared as signed 32-bit
> integer), so it is still possible to pass garbage there.  A check
> against INT_MAX solves both these issues.
> 
> Fixes: ef2c41cf38a7559b ("clone3: allow spawning processes into cgroups")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>

Thanks, will queue for rc2 unless I hear objections.
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
