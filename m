From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 2/2] cpuset: Add cpuset.flags control knob to v2
Date: Mon, 19 Mar 2018 09:26:54 -0700
Message-ID: <20180319162654.GR2943022@devbig577.frc2.facebook.com>
References: <1521148842-15486-1-git-send-email-longman@redhat.com>
 <1521148842-15486-3-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8eNInYkHwQkCuJcX3qBfesUQwAMJyRKRawyW/fU43j0=;
        b=aCpOKbXJtXGVVO/VTBzsDbJ+Cg5JrGm7pDYXCQocL/l6NEuvZOa79qZhH1bh+3xUrO
         UjENbD3Ew5vCDDFtNLoBxCB6WXwvATgkv/NQ1g/i+cr9oBdYOljrDrMDFnO0F/lTmaa8
         wWOKE1s1jH8EI2d5ZmzRKS8mz98ceGqk3PiBQu1dPSbadBTZopkjL0sXItEDZfNmnaKQ
         FpmE4NBCPvQIv+KO+ODCODyvtVCILoEmuud/PBVMlIZXwvNQ8VfVlGK61zyKPwIUlETs
         JGbk0kiMlWa0SMAGbkmtasPamuHawzwMCq0dTqt2Uw5eZDX/NzDE0nEqD50iGi/A7LpI
         IVuA==
Content-Disposition: inline
In-Reply-To: <1521148842-15486-3-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

Hello, Waiman.

On Thu, Mar 15, 2018 at 05:20:42PM -0400, Waiman Long wrote:
> +	The currently supported flag is:
> +
> +	  sched_load_balance
> +		When it is not set, there will be no load balancing
> +		among CPUs on this cpuset.  Tasks will stay in the
> +		CPUs they are running on and will not be moved to
> +		other CPUs.
> +
> +		When it is set, tasks within this cpuset will be
> +		load-balanced by the kernel scheduler.  Tasks will be
> +		moved from CPUs with high load to other CPUs within
> +		the same cpuset with less load periodically.

Hmm... looks like this is something which can be decided by the cgroup
itself and should be made delegatable.  Given that different flags
might need different delegation settings and the precedence of
memory.oom_group, I think it'd be better to make the flags separate
bool files - ie. cpuset.sched_load_balance which contains 0/1 and
marked delegatable.

Thanks.

-- 
tejun
