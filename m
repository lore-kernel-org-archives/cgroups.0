From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH v3 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Date: Wed, 24 Sep 2014 23:09:25 +0900
Message-ID: <201409242309.HDF95877.OSVFFtQLJMOHOF@I-love.SAKURA.ne.jp>
References: <542124D3.9000007@huawei.com>
	<20140924132218.GC16555@htj.dyndns.org>
	<20140924133513.GD16555@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140924133513.GD16555@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: lizefan@huawei.com, peterz@infradead.org, mingo@kernel.org, keescook@chromium.org, miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, rientjes@google.com

Tejun Heo wrote:
> > Applied 1-3 to cgroup/for-3.17-fixes w/ the typo spotted by davidr
> > fixed.

s/happend/happened/

> 
> Reverted due to build failure.  Will wait for a refreshed version. :(

I can build with 1-3 patches using HEAD of linux.git. What failure did you see?

$ make kernel/seccomp.o kernel/sys.o security/apparmor/domain.o kernel/cpuset.o
