From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mm, memcg: store memcg name for oom kill log
 consistency
Date: Mon, 9 Sep 2013 02:00:26 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1309090200110.1935@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1308282302450.14291@chino.kir.corp.google.com> <20130829133032.GB12077@dhcp22.suse.cz> <20130905135219.GE13666@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=t8lTdN9ZgnYauNgohd6t94OM9wjsS+SjUibg4+5n+0s=;
        b=e0I2wb/yY9mdJvEbhqarmEN6qRrIUwg1ip6CR1mHdn7k70NidoBtx8wlmeww2H1a0P
         F6gHVOsebcwWgqcYg4u3GbwZVinLi0cN4SXMid5lDFdwhyXAKRoZjeOUTIqyFtD0ZnZc
         /yitZkBbQb/07M/exHcIOMmCyuCiKCsMS4wUehjsxMOBVv7Ydme1yEGXLzt54rw37RP4
         QnoJ22TyWeOLx7cR90gUASN+SqLSXCIPefW7ynuYP/kCC+TKGxnIvQE0EmcaTJLXqqcA
         tC7cAcz+2CN9KUZCPph8bcqN+PXY7XT/gqo5/3dv+SUbmK2eOpaVFFFb1pzMECbi2DhL
         EPvA==
In-Reply-To: <20130905135219.GE13666-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, 5 Sep 2013, Michal Hocko wrote:

> From 4cee36f56100f5689fe1ae22f468016ce5a0cbae Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Date: Thu, 5 Sep 2013 15:39:20 +0200
> Subject: [PATCH] memcg, oom: lock mem_cgroup_print_oom_info
> 
> mem_cgroup_print_oom_info uses a static buffer (memcg_name) to store the
> name of the cgroup. This is not safe as pointed out by David Rientjes
> because although memcg oom is locked for its hierarchy nothing prevents
> another parallel hierarchy to trigger oom as well and overwrite the
> already in-use buffer.
> 
> This patch introduces oom_info_lock hidden inside mem_cgroup_print_oom_info
> which is held throughout the function. It make access to memcg_name safe
> and as a bonus it also prevents parallel memcg ooms to interleave their
> statistics which would make the printed data hard to analyze otherwise.
> 
> Using the spinlock is OK here because this path is not hot and
> meaningful data is much more important.
> 
> Reported-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Remove this.

> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
