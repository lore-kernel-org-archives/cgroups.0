From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: flatten task_struct->memcg_oom
Date: Wed, 30 Sep 2015 14:54:20 -0400
Message-ID: <20150930185420.GF2627@mtj.duckdns.org>
References: <20150913185940.GA25369@htj.duckdns.org>
 <55FEC685.5010404@oracle.com>
 <20150921200141.GH13263@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SfuKPagvDt3wYM7nt3tNt2b6KcaF/4AxVErfNWhYb6U=;
        b=bUrhhvWnLCJBVmEYPUsqK+QmXWiWFwXBTyKmZNwkODBlSqC9H1eKA056aJhW0hBfED
         hPA+ZkUJSZzxqWKjerjl0MIQznxq5eVsAXtUyYBD7DqawyvIaqUK935Z7DHC9tyj787/
         QCDACypoSTPB3kbYW4A5GCjS/wcfta8rbV/YvqhTVLQrYO1SaCc4gR+Fr9/VRn6ex+Ub
         Hwx7rVWxTt/CRG2XoDuRxB8aBuAYSKr51DdW2CVlZaZCgNqwBajDV+OffrBwUn7ulbDT
         XZWCsLOQdEfZyt7RNMkvsvjekdyD7EdHwPMqy0qYLiQ610Eqpu9erTpbIcqNgSSFCInd
         nyYw==
Content-Disposition: inline
In-Reply-To: <20150921200141.GH13263-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Sep 21, 2015 at 04:01:41PM -0400, Tejun Heo wrote:
> (cc'ing scheduler folks)
> 
> On Sun, Sep 20, 2015 at 10:45:25AM -0400, Sasha Levin wrote:
> > On 09/13/2015 02:59 PM, Tejun Heo wrote:
> > > task_struct->memcg_oom is a sub-struct containing fields which are
> > > used for async memcg oom handling.  Most task_struct fields aren't
> > > packaged this way and it can lead to unnecessary alignment paddings.
> > > This patch flattens it.
> > > 
> > > * task.memcg_oom.memcg          -> task.memcg_in_oom
> > > * task.memcg_oom.gfp_mask	-> task.memcg_oom_gfp_mask
> > > * task.memcg_oom.order          -> task.memcg_oom_order
> > > * task.memcg_oom.may_oom        -> task.memcg_may_oom
> ...
> > I've started seeing these warnings:
> > 
> > [1598889.250160] WARNING: CPU: 3 PID: 11648 at include/linux/memcontrol.h:414 handle_mm_fault+0x1020/0x3fa0()
> ...
> > [1598892.247256] dump_stack (lib/dump_stack.c:52)
> > [1598892.249105] warn_slowpath_common (kernel/panic.c:448)
> > [1598892.253202] warn_slowpath_null (kernel/panic.c:482)
> > [1598892.255148] handle_mm_fault (include/linux/memcontrol.h:414 mm/memory.c:3430)
> > [1598892.268151] __do_page_fault (arch/x86/mm/fault.c:1239)
> > [1598892.269022] trace_do_page_fault (arch/x86/mm/fault.c:1331 include/linux/jump_label.h:133 include/linux/context_tracking_state.h:30 include/linux/context_tracking.h:46 arch/x86/mm/fault.c:1332)
> > [1598892.269894] do_async_page_fault (arch/x86/kernel/kvm.c:280)
> > [1598892.270792] async_page_fault (arch/x86/entry/entry_64.S:989)
> > 
> > Not sure if it's because of this patch or not, but I haven't seen them before.
> 
> So, the only way the patch could have caused the above is if someone
> who isn't the task itself is writing to the bitfields while the task
> is running.  Looking through the fields, ->sched_reset_on_fork seems a
> bit suspicious.  __sched_setscheduler() looks like it can modify the
> bit while the target task is running.  Peter, am I misreading the
> code?

Ping?

-- 
tejun
