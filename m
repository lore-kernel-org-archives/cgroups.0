From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: add the mempolicy interface for cgroup
 v2.
Date: Tue, 24 May 2022 12:47:28 +0200
Message-ID: <Yoy3wDh0cvziWGHJ@dhcp22.suse.cz>
References: <20220524103638.473-1-hezhongkun.hzk@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653389249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a/JkmIrb3U0V/yu8PhyV+N8XrbjKAUo7AoBVKzx+G8o=;
        b=Rb3brHeSayt8ozGawjFpwJcpvr999BpR3pDQSkTLuEcz3hN1uVvTRiwpyoqnj5WBbqdbfP
        /TQRnq2orPaNUKVKgZnKJ3ryV4w0E7kHBeTVB+jZF4GkIEu7LsnZuQ7uoEYsdoPSKyWcFL
        gpRbufrymhC1QhjhY7nO7Vta82G2XVw=
Content-Disposition: inline
In-Reply-To: <20220524103638.473-1-hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Tue 24-05-22 18:36:38, hezhongkun wrote:
> From: Hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Mempolicy is difficult to use because it is set in-process
> via a system call. We want to make it easier to use mempolicy
> in cgroups, so that we can control low-priority cgroups to
> allocate memory in specified nodes. So this patch want to
> adds the mempolicy interface.
> 
> the mempolicy priority of memcgroup is higher than the priority
> of task. The order of getting the policy is,
> memcgroup->policy,task->policy or vma policy, default policy.
> memcgroup's policy is owned by itself, so descendants will
> not inherit it.

Why cannot you use cpuset cgroup?
-- 
Michal Hocko
SUSE Labs
