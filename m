From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix a race condition when reading cpuset.*
Date: Wed, 12 Feb 2020 17:15:43 -0500
Message-ID: <20200212221543.GL80993@mtj.thefacebook.com>
References: <20200211141554.24181-1-qais.yousef@arm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lt2bmGLGUi0Zcu/H421eTEe1/qtmGCD9EmboSnT4OXI=;
        b=ewzHnGuNrwUuIGR6/XbkIYVSSuohB/DF5TrOVfr1xP6bvsBmLUB7R2bhUngJhyL0B6
         EwRPVIk4ou9BNMLoFTtJaP09iN7769B6Vx7JbyiQNmQ8cjxvzgBXKgHs6pDRTkZHJP3I
         /Dt0CRoHfvHPjw+dcxB6vtWocysqrhIpmBfRJyodr5oBqhn47sz2D8su7Vgaz5YCsJSR
         I00e7uGihZvOR/Py3sMZuULUe99x+RYFHHtqnKmKKRmrH7XeuHWodyfLERHVGxyy2oOZ
         Q8B8nChKVR+77Vm8gkChlv2ve6fLlDl046ax2696x+k8z3i5fIM8EnmNqQ45Q1DK4snn
         M5Uw==
Content-Disposition: inline
In-Reply-To: <20200211141554.24181-1-qais.yousef-5wv7dgnIgG8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 11, 2020 at 02:15:54PM +0000, Qais Yousef wrote:
> LTP cpuset_hotplug_test.sh was failing with the following error message
> 
> 	cpuset_hotplug 1 TFAIL: root group's cpus isn't expected(Result: 0-5, Expect: 0,2-5).
> 
> Which is due to a race condition between cpu hotplug operation and
> reading cpuset.cpus file.
> 
> When a cpu is onlined/offlined, cpuset schedules a workqueue to sync its
> internal data structures with the new values. If a read happens during
> this window, the user will read a stale value, hence triggering the
> failure above.
> 
> To fix the issue make sure cpuset_wait_for_hotplug() is called before
> allowing any value to be read, hence forcing the synchronization to
> happen before the read.
> 
> I ran 500 iterations with this fix applied with no failure triggered.
> 
> Signed-off-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>

Hello, Qais. I just applied a patch which makes the operation
synchronous. Can you see whether the problem is gone on the
cgroup/for-next branch?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next

Thanks.

-- 
tejun
