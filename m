From: Tejun Heo <tj@kernel.org>
Subject: Re: [RESEND PATCH v3] cpuset: restore sanity to
 cpuset_cpus_allowed_fallback()
Date: Wed, 12 Jun 2019 11:02:36 -0700
Message-ID: <20190612180236.GQ3341036@devbig004.ftw2.facebook.com>
References: <1560354648-23632-1-git-send-email-jsavitz@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5+frD1W0PaRHYVfg7bRlg/bAjJXsZpY3XnMe0SfDiS8=;
        b=DPUHU1je3wTkpwlmd4MDNQvT6dUdwrfcgO9977+0I6QZnpSQ06GQLLwWKQDu8JQL4e
         A0s6M+ym0+M2+9lOyg+uLIrUhDvUczKtO7PPnpDIuDx6v1EjhQlNbLMifAD7wHFAjOEz
         SFXRSfsnlETmOJAxvMO7pxUVw8jsxiGVvps9/8pjqDShlbA7FHSvsdbq7m76wH5eV/O4
         6ANvVXTPseOZh3bv4kS9RMlv6PAddZOy135SEKfAITFTRQUBhrZeexigSL9EMMPI5KAW
         i5rZwS18NdwBeTZkhL+ZXrYsTmp6PkS4RxsEhYKDrRm6mC5ZD2TGpxTUnjDwgDytUWJM
         9LKA==
Content-Disposition: inline
In-Reply-To: <1560354648-23632-1-git-send-email-jsavitz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Savitz <jsavitz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org

On Wed, Jun 12, 2019 at 11:50:48AM -0400, Joel Savitz wrote:
> In the case that a process is constrained by taskset(1) (i.e.
> sched_setaffinity(2)) to a subset of available cpus, and all of those are
> subsequently offlined, the scheduler will set tsk->cpus_allowed to
> the current value of task_cs(tsk)->effective_cpus.
> 
> This is done via a call to do_set_cpus_allowed() in the context of 
> cpuset_cpus_allowed_fallback() made by the scheduler when this case is
> detected. This is the only call made to cpuset_cpus_allowed_fallback()
> in the latest mainline kernel.
> 
> However, this is not sane behavior.
...
> Suggested-by: Waiman Long <longman@redhat.com>
> Suggested-by: Phil Auld <pauld@redhat.com>
> Signed-off-by: Joel Savitz <jsavitz@redhat.com>

Applied to cgroup/for-5.2-fixes.

Thanks.

-- 
tejun
