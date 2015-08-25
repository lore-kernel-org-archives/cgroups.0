From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 25 Aug 2015 17:13:42 -0400
Message-ID: <20150825211342.GF26785@mtj.duckdns.org>
References: <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org>
 <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
 <20150824211707.GJ28944@mtj.duckdns.org>
 <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA@mail.gmail.com>
 <20150824214000.GL28944@mtj.duckdns.org>
 <CAPM31R+Mnk=AL6h05eMMQvPEEfnjkB3iGb+oZj28jAQ9-ajOxA@mail.gmail.com>
 <20150824224936.GO28944@mtj.duckdns.org>
 <CAPM31RKr5K0F6b70wJronTcvXRLBYRuOvH+aFeDTVeZiDVZz=Q@mail.gmail.com>
 <55DBD4A9.7080603@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IyPU5/qk2LDJVnPfbnXMXfYJSMqUMcU/tZLzOCjy7JU=;
        b=YBFYJaUcHwbYTGG+eohUNIbrV/7huqNVQVVoP0dsgj8nrA35WfNuHs4rstgDSD3trI
         Pi6L1BPictCmc/LlFPXW1/E0qhg3R9EKZmvRL6HAG8uP6p6/D/8NSfin5lhmP9AhpbFT
         LF92c/DmJoUimogzbk/YrPVaZvlRoI7TtmfqWwj3xsXfLg9tb+3h+4WFZEUFg2SjUJ4C
         OkC2s0kb/9JhzM2FQeWsM46exgb63STkkKuwp+Bxfqy229dY80adeh9FfpKg/rmr0vcu
         9Hr4m/4bYarXbqmriR2SVcJgEOtWJuMDLTOPleEJuU4H7ydyE/l99uPQaJLR9bm5Kw7o
         jIxA==
Content-Disposition: inline
In-Reply-To: <55DBD4A9.7080603-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Kame.

On Tue, Aug 25, 2015 at 11:36:25AM +0900, Kamezawa Hiroyuki wrote:
> I think I should explain my customer's use case of qemu + cpuset/cpu (via libvirt)
> 
> (1) Isolating hypervisor thread.
>    As already discussed, hypervisor threads are isolated by cpuset. But their purpose
>    is to avoid _latency_ spike caused by hypervisor behavior. So, "nice" cannot be solution
>    as already discussed.
> 
> (2) Fixed rate vcpu service.
>    With using cpu controller's quota/period feature, my customer creates  vcpu models like
>    Low(1GHz), Mid(2GHz), High(3GHz) for IaaS system.
> 
>    To do this, each vcpus should be quota-limited independently, with per-thread cpu control.
> 
> Especially, the method (1) is used in several enterprise customers for stabilizing their system.
> 
> Sub-process control should be provided by some way.

Can you please take a look at the proposal on my reply to Paul's
email?  AFAICS, both of above cases should be fine with that.

Thanks.

-- 
tejun
