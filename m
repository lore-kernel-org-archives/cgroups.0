From: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix a race condition when reading cpuset.*
Date: Thu, 13 Feb 2020 11:50:16 +0000
Message-ID: <20200213115015.hkd6uqwfjosxjfpm@e107158-lin.cambridge.arm.com>
References: <20200211141554.24181-1-qais.yousef@arm.com>
 <20200212221543.GL80993@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200212221543.GL80993-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun

On 02/12/20 17:15, Tejun Heo wrote:
> On Tue, Feb 11, 2020 at 02:15:54PM +0000, Qais Yousef wrote:
> > LTP cpuset_hotplug_test.sh was failing with the following error message
> > 
> > 	cpuset_hotplug 1 TFAIL: root group's cpus isn't expected(Result: 0-5, Expect: 0,2-5).
> > 
> > Which is due to a race condition between cpu hotplug operation and
> > reading cpuset.cpus file.
> > 
> > When a cpu is onlined/offlined, cpuset schedules a workqueue to sync its
> > internal data structures with the new values. If a read happens during
> > this window, the user will read a stale value, hence triggering the
> > failure above.
> > 
> > To fix the issue make sure cpuset_wait_for_hotplug() is called before
> > allowing any value to be read, hence forcing the synchronization to
> > happen before the read.
> > 
> > I ran 500 iterations with this fix applied with no failure triggered.
> > 
> > Signed-off-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
> 
> Hello, Qais. I just applied a patch which makes the operation
> synchronous. Can you see whether the problem is gone on the
> cgroup/for-next branch?
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next

I ran 500 iterations of cpuset_hotplug_test.sh on the branch, it passed.

I also cherry-picked commit 6426bfb1d5f0 ("cpuset: Make cpuset hotplug synchronous")
into v5.6-rc1 and ran 100 iterations and it passed too.

While investigating the problem, I could reproduce it all the way back to v5.0.
Stopped there so earlier versions could still have the problem.

Do you think it's worth porting the change to stable trees? Admittedly the
problem should be benign, but it did trigger an LTP failure.

I can check 4.19 and 4.14 stable trees (which at least in Android world are
still relevant) if you agree it makes sense to put a fix in stable.

Thanks
