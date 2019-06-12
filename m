From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3] cpuset: restore sanity to
 cpuset_cpus_allowed_fallback()
Date: Wed, 12 Jun 2019 08:38:57 -0700
Message-ID: <20190612153857.GO3341036@devbig004.ftw2.facebook.com>
References: <1560352395-19977-1-git-send-email-jsavitz@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JuROWLVzxIFjnfWdTCsoegNVj2txOGgaIFKDPlu0MV8=;
        b=Xdp8UdIQpUWGHrfMgzQC4yhmJgOSy7bMYuN+V2wIvnXufG/JkdgwAn5A7Ib40gYEtx
         xc1wgOKi9WG7MZOiHNxUHSqd/iHlEnTCFxumomjOr3Yx5aC21bKBRkzfg8VC1waY6HEi
         /4A+V2YcoXnWKNsTlZPOovLuwBYBZ6QtZVURGDdG8JC/7fvzgiXl+C9O90BDjGaOiaPR
         VJCNr255zjzT2by8TcDY5vrhDw+X1d0/Zzdg650GBBwk7q38DRd88wgqI0NikESWEBkT
         vu9GaGzfuiSo70RxER42IQUgxN/wjaZKAY5g/c4QWRnLEMnPSq2vW1X2CJBqXEKXbUc/
         UYrg==
Content-Disposition: inline
In-Reply-To: <1560352395-19977-1-git-send-email-jsavitz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Savitz <jsavitz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, cgroups@vger.kernel.org

Hello, Joel.

On Wed, Jun 12, 2019 at 11:13:15AM -0400, Joel Savitz wrote:
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

So, I fully agree the whole thing is insane.  It has always been so
and the root cause of the problem is that we aren't distinguishing
restrictions put on by the cpuset and individual tasks' configured
cpumask.  Ultimately, for this to make actual sense, we need to
separate out per-task effective and configured and cpuset-imposed
masks.

That said, the suggested behavior seems way better than the current
one, so no objection from me, but can you please repost w/ scheduler
ppl cc'd?

Thanks.

-- 
tejun
