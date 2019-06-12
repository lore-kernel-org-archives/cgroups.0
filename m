From: Tejun Heo <tj@kernel.org>
Subject: Re: [RESEND PATCH v3] cpuset: restore sanity to
 cpuset_cpus_allowed_fallback()
Date: Wed, 12 Jun 2019 09:02:44 -0700
Message-ID: <20190612160244.GP3341036@devbig004.ftw2.facebook.com>
References: <1560354648-23632-1-git-send-email-jsavitz@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q/SueBbtj7C5fFQ+1HnrwXXVgHlOaQMtNQZKJDih2vk=;
        b=O2IfSoEdPeOtqvYc61BZ6k3//eUBsMkInNpkQAdhysvx5DQ3SdYRIa4kcfKFNZZiUf
         gnZiXeSVkjhFpwuXlNh0ekQU9A13LIBL1boBvvOujQQdHY6GA0eSL5Gnqvg6nq8Nfeuc
         3fp+jTtqUacUT5N2RJ51BAY8KHD3RLw3T0WANZ7Fdcv8ap6gs4icNXGB8NJwKRnjHgbx
         5lD/T9jSf8m6NvX1y/agOfMFhQMjhe9A0JGL45PHag1/zVPKZOOpYu8c3TGhLn+7hxSO
         UoCiIyN+Kca/fLHpXlP7m4CqcwCd5anviByK0K7OR9KQ3wgNCj125XtlSdLups1CYqYK
         GJSA==
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

While not perfect (we'll need to stop updating task's cpumask from
cpuset to make), this is still a signifcant improvement.

 Acked-by: Tejun Heo <tj@kernel.org>

If there's no objection, I'll route it through the cgroup tree.

Thanks.

-- 
tejun
