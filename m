From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 2/2] memcg: do not sleep on OOM waitqueue with full charge
 context
Date: Wed, 5 Jun 2013 21:10:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1306052058340.25115@chino.kir.corp.google.com>
References: <1370488193-4747-1-git-send-email-hannes@cmpxchg.org> <1370488193-4747-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=p/PKNhvoPAKnYgC1m+das1RNBOyweObZnex4kFNZAtg=;
        b=RLednu7KtiQ3mL+l6xePp68/r9/GLFePk2iEZMIW/6+qSrSX0DYH3J6jhoBBvsY1DV
         fGVzy+kqoFgp++9lzXlegSm7duIdK0lDzIrOXTQnyHzne6cDNiOoErqsaMeNn2Jw6Y52
         TmEGz9UYAJmjQ5rVMBc3MoRW6FeLNIdEMyLlnnsuMB5uw8rgAoFiuD9tQPGMVlCq4r9v
         UYlECelSGyfTeo/gQ6z2feJMqAYOlE7XT8VT1V/2BZwh7EAr4TNi9vh5cjnepC2kasOc
         NGkSlilWnyk/jYDkChIdWUUtSaGJ4S3NR8Vm8wzOEEV40idJuwCbNPS+6ihSybkq1fIh
         ukVQ==
In-Reply-To: <1370488193-4747-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Johannes Weiner wrote:

> The memcg OOM handling is incredibly fragile because once a memcg goes
> OOM, one task (kernel or userspace) is responsible for resolving the
> situation.

Not sure what this means.  Are you referring to the case where the memcg 
is disabled from oom killing and we're relying on a userspace handler and 
it may be caught on the waitqueue itself?  Otherwise, are you referring to 
the task as eventually being the only one that takes the hierarchy oom 
lock and calls mem_cgroup_out_of_memory()?  I don't think you can make a 
case for the latter since the one that calls mem_cgroup_out_of_memory() 
should return and call memcg_wakeup_oom().  We obviously don't want to do 
any memory allocations in this path.

> Every other task that gets caught trying to charge memory
> gets stuck in a waitqueue while potentially holding various filesystem
> and mm locks on which the OOM handling task may now deadlock.
> 

What locks?  The oom killer quite extensively needs task_lock() but we 
shouldn't be calling it in the case where we hold this since its a 
spinlock and mem_cgroup_do_charge() never gets to the point of handling 
the oom.

Again, are you referring only to a userspace handler here?

> Do two things:
> 
> 1. When OOMing in a system call (buffered IO and friends), invoke the
>    OOM killer but just return -ENOMEM, never sleep.  Userspace should
>    be able to handle this.
> 

The sleep should never occur for any significant duration currently, the 
current implementation ensures one process calls 
mem_cgroup_out_of_memory() while all others sit on a waitqueue until that 
process returns from the oom killer and then they all wakeup again so the 
killed process may exit and all others can retry their allocations now 
that something has been killed.  If that process hasn't exited yet, the 
next process that locks the memcg oom hierarchy will see the killed 
process with TIF_MEMDIE and the oom killer is deferred.  So this sleep is 
very temporary already, I don't see why you're trying to make it faster 
while another thread finds a candidate task, it works quite well already.

> 2. When OOMing in a page fault and somebody else is handling the
>    situation, do not sleep directly in the charging code.  Instead,
>    remember the OOMing memcg in the task struct and then fully unwind
>    the page fault stack first before going to sleep.
> 

Are you trying to address a situation here where the memcg oom handler 
takes too long to work?  We've quite extensively tried to improve that, 
especially by reducing its dependency on tasklist_lock which is contended 
from the writeside in the exit path and by only iterating processes that 
are attached to that memcg hierarchy and not all processes on the system 
like before.  I don't see the issue with scheduling other oom processes 
while one is doing mem_cgroup_out_of_memory().  (I would if the oom killer 
required things like mm->mmap_sem, but obviously it doesn't for reasons 
not related to memcg.)

> While reworking the OOM routine, also remove a needless OOM waitqueue
> wakeup when invoking the killer.  Only uncharges and limit increases,
> things that actually change the memory situation, should do wakeups.
> 

It's not needless at all, it's vitally required!  The oom killed process 
needs to be removed from the waitqueue and scheduled now with TIF_MEMDIE 
that the memcg oom killer provided so the allocation succeeds in the page 
allocator and memcg bypasses the charge so it can exit.

Exactly what problem are you trying to address with this patch?  I don't 
see any description of the user-visible effects or a specific xample of 
the scenario you're trying to address here.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
