From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes] cgroup: make css_set pin its css's
 to avoid use-afer-free
Date: Mon, 30 Nov 2015 09:48:55 -0500
Message-ID: <20151130144855.GA3535@mtj.duckdns.org>
References: <20151123195541.GA19072@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=w3AJBFOBP8nea9dKKI/ai+q6qafDBFS3CwXIM8JzHEE=;
        b=Aj3nsow68jKN3s9I0wpZw0O1kTpT+diGOORCdCxFhO65Xp/L4Cg++eoD3R7xMAIJ+s
         F2ubY8eyX0pRyE0vWeLxb3cxjEZDWn91jAODnIU86XSRzRw/KGWr75mGQRotI6YHnf4v
         IOD/0vHgX6mgjo6f+aFgLl9sO008WAfs351FM3c1u6szq2vIuIg3dz7nUtidkDeGMmW9
         /TsjM+3uwmtqwTgustu2yR8huOn2OKyn9dlspYDlYXmQtClz492zJX6udIuILFg6yhB5
         7TsA4DXJvZPAXBaquqYyuHzJnrionwIAIkNa41Pns0NNWj3w3Cc0qg+Y4tKcpumacHgG
         kdhg==
Content-Disposition: inline
In-Reply-To: <20151123195541.GA19072-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Nov 23, 2015 at 02:55:41PM -0500, Tejun Heo wrote:
> A css_set represents the relationship between a set of tasks and
> css's.  css_set never pinned the associated css's.  This was okay
> because tasks used to always disassociate immediately (in RCU sense) -
> either a task is moved to a different css_set or exits and never
> accesses css_set again.
> 
> Unfortunately, afcf6c8b7544 ("cgroup: add cgroup_subsys->free() method
> and use it to fix pids controller") and patches leading up to it made
> a zombie hold onto its css_set and deref the associated css's on its
> release.  Nothing pins the css's after exit and it might have already
> been freed leading to use-after-free.
> 
>  general protection fault: 0000 [#1] PREEMPT SMP
>  task: ffffffff81bf2500 ti: ffffffff81be4000 task.ti: ffffffff81be4000
>  RIP: 0010:[<ffffffff810fa205>]  [<ffffffff810fa205>] pids_cancel.constprop.4+0x5/0x40
>  ...
>  Call Trace:
>   <IRQ>
>   [<ffffffff810fb02d>] ? pids_free+0x3d/0xa0
>   [<ffffffff810f8893>] cgroup_free+0x53/0xe0
>   [<ffffffff8104ed62>] __put_task_struct+0x42/0x130
>   [<ffffffff81053557>] delayed_put_task_struct+0x77/0x130
>   [<ffffffff810c6b34>] rcu_process_callbacks+0x2f4/0x820
>   [<ffffffff810c6af3>] ? rcu_process_callbacks+0x2b3/0x820
>   [<ffffffff81056e54>] __do_softirq+0xd4/0x460
>   [<ffffffff81057369>] irq_exit+0x89/0xa0
>   [<ffffffff81876212>] smp_apic_timer_interrupt+0x42/0x50
>   [<ffffffff818747f4>] apic_timer_interrupt+0x84/0x90
>   <EOI>
>  ...
>  Code: 5b 5d c3 48 89 df 48 c7 c2 c9 f9 ae 81 48 c7 c6 91 2c ae 81 e8 1d 94 0e 00 31 c0 5b 5d c3 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <f0> 48 83 87 e0 00 00 00 ff 78 01 c3 80 3d 08 7a c1 00 00 74 02
>  RIP  [<ffffffff810fa205>] pids_cancel.constprop.4+0x5/0x40
>   RSP <ffff88001fc03e20>
>  ---[ end trace 89a4a4b916b90c49 ]---
>  Kernel panic - not syncing: Fatal exception in interrupt
>  Kernel Offset: disabled
>  ---[ end Kernel panic - not syncing: Fatal exception in interrupt
> 
> Fix it by making css_set pin the associate css's until its release.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
> Reported-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> Link: http://lkml.kernel.org/g/20151120041836.GA18390-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org
> Link: http://lkml.kernel.org/g/5652D448.3080002-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org
> Fixes: afcf6c8b7544 ("cgroup: add cgroup_subsys->free() method and use it to fix pids controller")

Applied to cgroup/for-4.4-fixes.

-- 
tejun
