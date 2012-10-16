From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Date: Tue, 16 Oct 2012 11:39:33 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210161136470.2910@chino.kir.corp.google.com>
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com> <20121016133439.GI13991@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=cK/uZQYaGjSvDVqdEkRQXbXrO7cLLaPxoaVud841dVU=;
        b=EvmEwlxfHxUdvAYH2NzJPdCorsFOeEcGpKfM3nkZWKMYJUIKBls+llFF7jvl2XNXe5
         O7w7HlskJrkvcTzdDL0YNmFSXMYwY3pdKkb5fatVj/nofIRT/mR8x48/bQAc9LF47bcB
         rRzKqSXimeY1QqM95Re2DJtQF3PqPFLoWATEvhyRImXKtWc3Q8oDcEsDEp/uZol+s25M
         82bsUgm+li9/n0pdiC9WaJasIMUmJbWV82xG8Pr1tRvLlSSNUTcs85ghwaxXDJhPAd8y
         31DMNDCsEhXbG18G33MANipDiik08uTpoMzmLPVd/2KvGcyr7ztmqfS5vcEtf+U2ymYp
         nEag==
In-Reply-To: <20121016133439.GI13991-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue, 16 Oct 2012, Michal Hocko wrote:

> The primary motivation for oom_kill_allocating_task AFAIU was to reduce
> search over huge tasklists and reduce task_lock holding times. I am not
> sure whether the original concern is still valid since 6b0c81b (mm,
> oom: reduce dependency on tasklist_lock) as the tasklist_lock usage has
> been reduced conciderably in favor of RCU read locks is taken but maybe
> even that can be too disruptive?
> David?
> 

When the oom killer became serialized, the folks from SGI requested this 
tunable to be able to avoid the expensive tasklist scan on their systems 
and to be able to avoid killing threads that aren't allocating memory at 
all in a steady state.  It wasn't necessarily about tasklist_lock holding 
time but rather the expensive iteration over such a large number of 
processes.

> Moreover memcg oom killer doesn't iterate over tasklist (it uses
> cgroup_iter*) so this shouldn't cause the performance problem like
> for the global case.

Depends on how many threads are attached to a memcg.
