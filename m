From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: Fix the bug that subpart_cpus updated wrongly in
 update_cpumask()
Date: Wed, 26 Jan 2022 06:49:56 -1000
Message-ID: <YfF7tPxxNT2SxWxl@slm.duckdns.org>
References: <20220118100518.2381118-1-dtcccc@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qHKkyLNz3BcJqhVoJVmJSW+AQ6LC+YMbazKnt8TVUkM=;
        b=EqkmYvUuHqLMrlellKgtt5dH4fjRwBxeLQlg4yOHiXrlRPwkZmEvL5zjR9gsWSQj8e
         FH/FdYO/EASM4JiRC2XMNbbtLLaauL4WXuAHKZc0or3hXKBCPHdtOFGpP+luU0nhVRhw
         ISVG1N4X6ctoZfEnl3UB1LEwNQISpF5UBMCga4EdNsAAxwXm9gMzD+tjcICd2bG9L0sA
         Fj66vuOp0rx9m6DVJ724BgsVjrxTHV+lVjBnWgTXX25kBbEXt0zAvwtvq72HmheS7iva
         z/wkmZSUkSjfDI6IaTzK9NHM1ChbYGdI5oqObJRJF0ttryPec4a4MTIJ2NWrucNChbJy
         ugzA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220118100518.2381118-1-dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 18, 2022 at 06:05:18PM +0800, Tianchen Ding wrote:
> subparts_cpus should be limited as a subset of cpus_allowed, but it is
> updated wrongly by using cpumask_andnot(). Use cpumask_and() instead to
> fix it.
> 
> Fixes: ee8dde0cd2ce ("cpuset: Add new v2 cpuset.sched.partition flag")
> Signed-off-by: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Applied to cgroup/for-5.17-fixes.

Thanks.

-- 
tejun
