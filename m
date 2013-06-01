From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Sat, 1 Jun 2013 12:29:05 +0200
Message-ID: <20130601102905.GB19474@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
 <20130601061151.GC15576@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9E6xb7OnZOJX+Ggzgl2Ofvza7PNNYNYgAeMll03BfZY=;
        b=Mbxg3jDKVvvIKlhKnPiuuNx6UGztbJh+zSG/6F6BiS5yt2gNeMMpvUi7RoHB98qbjw
         hFS1L91XCTTQY//ad6NAQ/dalQNQ1IP+mKC6zfFiW0vDgE7NMB+Li4Dzb4xG4gr0/HTc
         zkVLAFli0lA6JIk4xZJJ1DXM+MwTdKao3h+D0/Ip13ak1xueo7HAEkaIgKJedmKVd9TP
         xcQOJYhwOVI/1whz28faociaSNa1sIHzRdQHh/+8lWz/wLvclO1dauxMYAMV5j8yaNIa
         Iu4tn8ON+vhcKIAqyViBbKinctXaKyEdzOERtQMDnkRgd7ww8x9MrEzpmM75KbJ+tgK7
         5Y4w==
Content-Disposition: inline
In-Reply-To: <20130601061151.GC15576@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Sat 01-06-13 02:11:51, Johannes Weiner wrote:
[...]
> I'm currently messing around with the below patch.  When a task faults
> and charges under OOM, the memcg is remembered in the task struct and
> then made to sleep on the memcg's OOM waitqueue only after unwinding
> the page fault stack.  With the kernel OOM killer disabled, all tasks
> in the OOMing group sit nicely in
> 
>   mem_cgroup_oom_synchronize
>   pagefault_out_of_memory
>   mm_fault_error
>   __do_page_fault
>   page_fault
>   0xffffffffffffffff
> 
> regardless of whether they were faulting anon or file.  They do not
> even hold the mmap_sem anymore at this point.
> 
> [ I kept syscalls really simple for now and just have them return
>   -ENOMEM, never trap them at all (just like the global OOM case).
>   It would be more work to have them wait from a flatter stack too,
>   but it should be doable if necessary. ]
> 
> I suggested this at the MM summit and people were essentially asking
> if I was feeling well, so maybe I'm still missing a gaping hole in
> this idea.

I didn't get to look at the patch (will do on Monday) but it doesn't
sounds entirely crazy. Well, we would have to drop mmap_sem so things
have to be rechecked but we are doing that already with VM_FAULT_RETRY
in some archs so it should work.

> Patch only works on x86 as of now, on other architectures memcg OOM
> will invoke the global OOM killer.
[...]
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
