From: Michal Hocko <mhocko@suse.cz>
Subject: Re: memory-cgroup bug
Date: Thu, 22 Nov 2012 22:42:52 +0100
Message-ID: <20121122214249.GA20319@dhcp22.suse.cz>
References: <20121121200207.01068046@pobox.sk>
 <20121122152441.GA9609@dhcp22.suse.cz>
 <20121122190526.390C7A28@pobox.sk>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=biRBPraKqBujWRYUdaZvYwEstsdQxToS5u4m128rRqw=;
        b=xHvnUlLaW47Zx7HGKp2ncHWet7surQ7H9w0aeV3mBBXoXi+ALCzGT8iwy6kBpCrYOQ
         T2Tj8lG9GRwk6gC7tUJhmKQqEhrxVz6/kOQz7zYdj25JqperhVmouYK0wMc3QyiOf8Fa
         +8fG9TP1mK1prHZg/+bP2heS9gVwfV7HLpttpYWFCJQ8SuiNmjqs1e0Q63DuuVFo/R0f
         QuDuX5nKlue9/RRVfweo8E0N4nGspwC8MJPdmHLGBM00i67wFLACHOKhNpiwmrSFSQej
         do+AYf1yAFL8yH89FIlUbnWbIV4z3tGWELBuI5j+35/A44k8Ku6x2fjo/IARuMwQI8mA
         AnZw==
Content-Disposition: inline
In-Reply-To: <20121122190526.390C7A28@pobox.sk>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>

On Thu 22-11-12 19:05:26, azurIt wrote:
[...]
> My cgroups hierarchy:
> /cgroups/<user_id>/uid/
> 
> where '<user_id>' is system user id and 'uid' is just word 'uid'.
> 
> Memory limits are set in /cgroups/<user_id>/ and hierarchy is
> enabled. Processes are inside /cgroups/<user_id>/uid/ . I'm using
> hard limits for memory and swap BUT system has no swap at all
> (it has 'only' 16 GB of real RAM). memory.oom_control is set to
> 'oom_kill_disable 0'. Server has enough of free memory when problem
> occurs.

OK, so so the global reclaim shouldn't be active. This is definitely
good to know.
 
> >> This happens when problem occures:
> >>  - no new processes can be started for this cgroup
> >>  - current processes are freezed and taking 100% of CPU
> >>  - when i try to 'strace' any of current processes, the whole strace
> >>    freezes until process is killed (strace cannot be terminated by
> >>    CTRL-c)
> >>  - problem can be resolved by raising memory limit for cgroup or
> >>    killing of few processes inside cgroup so some memory is freed
> >> 
> >> I also garbbed the content of /proc/<pid>/stack of freezed process:
> >> [<ffffffff8110a9c1>] mem_cgroup_handle_oom+0x241/0x3b0
> >> [<ffffffff8110b5ab>] T.1146+0x5ab/0x5c0
> >
> >Hmm what is this?
> 
> Really doesn't know, i will get stack of all freezed processes next
> time so we can compare it.
> 
> >> [<ffffffff8110ba56>] mem_cgroup_charge_common+0x56/0xa0
> >> [<ffffffff8110bae5>] mem_cgroup_newpage_charge+0x45/0x50
> >> [<ffffffff810ec54e>] do_wp_page+0x14e/0x800
> >> [<ffffffff810eda34>] handle_pte_fault+0x264/0x940
> >> [<ffffffff810ee248>] handle_mm_fault+0x138/0x260
> >> [<ffffffff810270ed>] do_page_fault+0x13d/0x460
> >> [<ffffffff815b53ff>] page_fault+0x1f/0x30
> >> [<ffffffffffffffff>] 0xffffffffffffffff

Btw. is this stack stable or is the task bouncing in some loop?
And finally could you post the disassembly of your version of
mem_cgroup_handle_oom, please?

> >How many tasks are hung in mem_cgroup_handle_oom? If there were many
> >of them then it'd smell like an issue fixed by 79dfdaccd1d5 (memcg:
> >make oom_lock 0 and 1 based rather than counter) and its follow up fix
> >23751be00940 (memcg: fix hierarchical oom locking) but you are saying
> >that you can reproduce with 3.2 and those went in for 3.1. 2.6.32 would
> >make more sense.
> 
> 
> Usually maximum of several 10s of processes but i will check it next
> time. I was having much worse problems in 2.6.32 - when freezing
> happens, the whole server was affected (i wasn't able to do anything
> and needs to wait until my scripts takes case of it and killed apache,
> so i don't have any detailed info).

Hmm, maybe the issue fixed by 1d65f86d (mm: preallocate page before
lock_page() at filemap COW) which was merged in 3.1.

> In 3.2 only target cgroup is affected.
> 
> >> I'm currently using kernel 3.2.34 but i'm having this problem since 2.6.32.
> >
> >I guess this is a clean vanilla (stable) kernel, right? Are you able to
> >reproduce with the latest Linus tree?
> 
> 
> Well, no. I'm using, for example, newest stable grsecurity patch.

That shouldn't be related

> I'm also using few of Andrea Righi's cgroup subsystems but i don't
> believe
> these are doing problems:
>  - cgroup-uid which is moving processes into cgroups based on UID
>  - cgroup-task which can limit number of tasks in cgroup (i already
>    tried to disable this one, it didn't help)
> http://www.develer.com/~arighi/linux/patches/

I am not familiar with those pathces but I will double check.

> Unfortunately i cannot just install new and untested kernel version
> cos i'm not able to reproduce this problem anytime (it's happening
> randomly in production environment).

This will make it a bit harder to debug but let's see maybe the new
traces would help...
 
> Could it be that OOM cannot start and kill processes because there's
> no free memory in cgroup?

That shouldn't happen. 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
