From: Qais Yousef <qais.yousef@arm.com>
Subject: Re: [PATCH] cgroup/cpuset: Fix a race condition when reading cpuset.*
Date: Thu, 13 Feb 2020 14:36:40 +0000
Message-ID: <20200213143639.6jw2kiadjzyu6unr@e107158-lin.cambridge.arm.com>
References: <20200211141554.24181-1-qais.yousef@arm.com>
 <20200212221543.GL80993@mtj.thefacebook.com>
 <20200213115015.hkd6uqwfjosxjfpm@e107158-lin.cambridge.arm.com>
 <20200213135645.GG88887@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200213135645.GG88887@mtj.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 02/13/20 08:56, Tejun Heo wrote:
> Hello,
> 
> On Thu, Feb 13, 2020 at 11:50:16AM +0000, Qais Yousef wrote:
> > I ran 500 iterations of cpuset_hotplug_test.sh on the branch, it passed.
> > 
> > I also cherry-picked commit 6426bfb1d5f0 ("cpuset: Make cpuset hotplug synchronous")
> > into v5.6-rc1 and ran 100 iterations and it passed too.
> 
> Awesome, thanks for verifying.
> 
> > While investigating the problem, I could reproduce it all the way back to v5.0.
> > Stopped there so earlier versions could still have the problem.
> > 
> > Do you think it's worth porting the change to stable trees? Admittedly the
> > problem should be benign, but it did trigger an LTP failure.
> 
> I'm afraid not. It's not an issue which would affect actual use cases
> and there's (as always) some risks involved with backporting it, so
> the benefit just doesn't seem justifiable here.

Yeah I can't see how a real application would depend on this functionality
other than for informational reasons. Or testing like in this case.

Thanks

--
Qais Yousef
