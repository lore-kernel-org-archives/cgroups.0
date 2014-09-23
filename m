From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should beatomic flags
Date: Tue, 23 Sep 2014 19:55:48 +0900
Message-ID: <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
References: <54210D3F.2090409@huawei.com>
	<54210DA5.4040606@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54210DA5.4040606@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, tj@kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, keescook@chromium.org

Zefan Li wrote:
> Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which happend

s/happend/happened/

> @@ -1972,6 +1973,14 @@ static inline void memalloc_noio_restore(unsigned int flags)
>  TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
>  TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
>  
> +TASK_PFA_TEST(SPREAD_PAGE, spread_page)
> +TASK_PFA_SET(SPREAD_PAGE, spread_page)
> +TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
> +
> +TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
> +TASK_PFA_SET(SPREAD_SLAB, spread_slab)
> +TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
> +

I wonder how adding 3 macro lines differs from 3 inlined functions.
Personally, from LXR (source code browser) point of view, inlined functions
are more friendly than macros. Also, I wonder about the cost of extracting
macros in a file which is likely included by every file but referenced
by few files. Speak of SPREAD_PAGE and SPREAD_SLAB, they should be defined
as inlined functions in include/linux/cpuset.h rather than as macros in
include/linux/sched.h ?
