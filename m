From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] memcg: Do not hang on OOM when killed by userspace OOM
 access to memory reserves
Date: Thu, 9 Jan 2014 13:40:10 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401091335450.31538@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com> <20131212103159.GB2630@dhcp22.suse.cz> <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com> <20131217162342.GG28991@dhcp22.suse.cz> <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
 <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com> <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org> <20140108103319.GF27937@dhcp22.suse.cz>
 <20140109143048.GE27538@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=187xg5Yg4W/cn1YrNht6+F0Nf6HpHvpBa2D7SKv5d84=;
        b=kyUm/1m98BgMjWPNIRAK/T2PCxQB0G4l5UYgH81Y9OKZrVO8E51BTQ9BdEZXeReP0Q
         J4ttsj1HGTL9vNKsR3j9Fxm8ha6qVD+Kl3++eSQoeE71y1jLmd3HfFlau8xnBmWikxwd
         ogDQd6UUkvtjsJ7GyV2wEvSV05cgrw+J9PE7b32WT85QnYarJp3+Vo1AWSf3cxu3buST
         csMn7AyV9XfcIQttzvVPCj63X37ZotQzHRSmdTGExZo+iKtH25tQgGv2iW1p2/6yWZxV
         /oBIrujjDTw0bX8nw30yI9CyMVD8+Fy/hTzSxFQBjz+B65TB2nryYyPiAWVtGqdH5k2R
         6gzQ==
In-Reply-To: <20140109143048.GE27538@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Thu, 9 Jan 2014, Michal Hocko wrote:

> Eric has reported that he can see task(s) stuck in memcg OOM handler
> regularly. The only way out is to
> 	echo 0 > $GROUP/memory.oom_controll
> His usecase is:
> - Setup a hierarchy with memory and the freezer
>   (disable kernel oom and have a process watch for oom).
> - In that memory cgroup add a process with one thread per cpu.
> - In one thread slowly allocate once per second I think it is 16M of ram
>   and mlock and dirty it (just to force the pages into ram and stay there).
> - When oom is achieved loop:
>   * attempt to freeze all of the tasks.
>   * if frozen send every task SIGKILL, unfreeze, remove the directory in
>     cgroupfs.
> 
> Eric has then pinpointed the issue to be memcg specific.
> 
> All tasks are sitting on the memcg_oom_waitq when memcg oom is disabled.
> Those that have received fatal signal will bypass the charge and should
> continue on their way out. The tricky part is that the exit path might
> trigger a page fault (e.g. exit_robust_list), thus the memcg charge,
> while its memcg is still under OOM because nobody has released any
> charges yet.
> Unlike with the in-kernel OOM handler the exiting task doesn't get
> TIF_MEMDIE set so it doesn't shortcut futher charges of the killed task
> and falls to the memcg OOM again without any way out of it as there are
> no fatal signals pending anymore.
> 
> This patch fixes the issue by checking PF_EXITING early in
> __mem_cgroup_try_charge and bypass the charge same as if it had fatal
> signal pending or TIF_MEMDIE set.
> 
> Normally exiting tasks (aka not killed) will bypass the charge now but
> this should be OK as the task is leaving and will release memory and
> increasing the memory pressure just to release it in a moment seems
> dubious wasting of cycles. Besides that charges after exit_signals
> should be rare.
> 
> Reported-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Is this tested?

> ---
>  mm/memcontrol.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b8dfed1b9d87..b86fbb04b7c6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2685,7 +2685,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  	 * MEMDIE process.
>  	 */
>  	if (unlikely(test_thread_flag(TIF_MEMDIE)
> -		     || fatal_signal_pending(current)))
> +		     || fatal_signal_pending(current))
> +		     || current->flags & PF_EXITING)
>  		goto bypass;
>  
>  	if (unlikely(task_in_memcg_oom(current)))

This would become problematic if significant amount of memory is charged 
in the exit() path.  I don't know of an egregious amount of memory being 
allocated and charged after PF_EXITING is set, but if it happens in the 
future then this could potentially cause system oom conditions even in 
memcg configurations that are designed such as the one Tejun suggested to 
be able to handle such conditions in userspace:

		     ___root___
		    /	       \
		user		oom
		/  \		/ \
		A  B		C D

where the limit of user is equal to the amount of system memory minus 
whatever amount of memory is needed by the system oom handler attached as 
a descendant of oom and still allows the limits of A + B to exceed the 
limit of user.

So how do we ensure that memory allocations in the exit() path don't cause 
system oom conditions whereas the above configuration no longer provides 
any strict guarantee?

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
