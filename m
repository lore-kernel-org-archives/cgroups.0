From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: flatten task_struct->memcg_oom
Date: Sun, 20 Sep 2015 10:45:25 -0400
Message-ID: <55FEC685.5010404@oracle.com>
References: <20150913185940.GA25369@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150913185940.GA25369-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 09/13/2015 02:59 PM, Tejun Heo wrote:
> task_struct->memcg_oom is a sub-struct containing fields which are
> used for async memcg oom handling.  Most task_struct fields aren't
> packaged this way and it can lead to unnecessary alignment paddings.
> This patch flattens it.
> 
> * task.memcg_oom.memcg          -> task.memcg_in_oom
> * task.memcg_oom.gfp_mask	-> task.memcg_oom_gfp_mask
> * task.memcg_oom.order          -> task.memcg_oom_order
> * task.memcg_oom.may_oom        -> task.memcg_may_oom
> 
> In addition, task.memcg_may_oom is relocated to where other bitfields
> are which reduces the size of task_struct.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> ---
> Hello,
> 
> Andrew, these are the two patches which got acked from the following
> thread.
> 
>  http://lkml.kernel.org/g/20150828220158.GD11089-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org
> 
> Acks are added and the second patch's description is updated as
> suggested by Michal and Vladimir.
> 
> Can you please put them in -mm?

Hi Tejun,

I've started seeing these warnings:

[1598889.250160] WARNING: CPU: 3 PID: 11648 at include/linux/memcontrol.h:414 handle_mm_fault+0x1020/0x3fa0()
[1598889.786891] Modules linked in:
[1598890.883223] Unable to find swap-space signature
[1598891.463736]
[1598892.236001] CPU: 3 PID: 11648 Comm: trinity-c10 Not tainted 4.3.0-rc1-next-20150918-sasha-00081-g4b7392a-dirty #2565
[1598892.239377]  ffffffffb4746d40 ffff8802edad7c70 ffffffffabfe97ba 0000000000000000
[1598892.241723]  ffff8802edad7cb0 ffffffffaa367466 ffffffffaa764140 ffff88037f00bec0
[1598892.244135]  ffff8802ecb94000 ffff88042420a000 0000000000b98fe8 ffff88042420a000
[1598892.246393] Call Trace:
[1598892.247256] dump_stack (lib/dump_stack.c:52)
[1598892.249105] warn_slowpath_common (kernel/panic.c:448)
[1598892.253202] warn_slowpath_null (kernel/panic.c:482)
[1598892.255148] handle_mm_fault (include/linux/memcontrol.h:414 mm/memory.c:3430)
[1598892.268151] __do_page_fault (arch/x86/mm/fault.c:1239)
[1598892.269022] trace_do_page_fault (arch/x86/mm/fault.c:1331 include/linux/jump_label.h:133 include/linux/context_tracking_state.h:30 include/linux/context_tracking.h:46 arch/x86/mm/fault.c:1332)
[1598892.269894] do_async_page_fault (arch/x86/kernel/kvm.c:280)
[1598892.270792] async_page_fault (arch/x86/entry/entry_64.S:989)

Not sure if it's because of this patch or not, but I haven't seen them before.


Thanks,
Sasha
