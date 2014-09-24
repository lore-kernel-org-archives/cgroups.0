From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should be atomic flags
Date: Wed, 24 Sep 2014 20:44:43 +0900
Message-ID: <201409242044.GFJ81269.FJFVQOLSHtFMOO@I-love.SAKURA.ne.jp>
References: <54210D3F.2090409@huawei.com>
	<54210DA5.4040606@huawei.com>
	<201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
	<542233F0.1080402@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <542233F0.1080402@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, peterz@infradead.org, mingo@kernel.org
Cc: tj@kernel.org, miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, keescook@chromium.org

Zefan Li wrote:
> Those macros make the code easier to read, and emacs and cscope can also
> understand them.

I'm using legacy LXR which cannot understand them. But

> I'd vote for this:
> 
> TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
> TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
> 
> TASK_PFA_TEST(SPREAD_PAGE, spread_page)
> TASK_PFA_SET(SPREAD_PAGE, spread_page)
> TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
> 
> TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
> TASK_PFA_SET(SPREAD_SLAB, spread_slab)
> TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
> 
> over this:

you can go ahead. This difference is not a stopper.

Tejun Heo wrote:
> All the patches look good to me.  I can't say I'm a big fan of
> function defining macros but I don't have prettier alternatives
> either.  Once Peter/Ingo acks the patches, I'll route them through
> cgroup/for-3.17-fixes.

Peter and Ingo, are these patches OK for you?
