From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Tue, 26 Nov 2013 16:53:47 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com> <20131031054942.GA26301@cmpxchg.org> <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com> <20131113233419.GJ707@cmpxchg.org> <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org> <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com> <20131118154115.GA3556@cmpxchg.org> <20131118165110.GE32623@dhcp22.suse.cz>
 <20131122165100.GN3556@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=bBm1/lZiucYv1EKuQP4I5BPlpToCoYkfsoDhIeCAaCA=;
        b=V05MdyCSLwyIzD9GsG9y24U/Zvwi+ocNF150eXuaX9nlYB/9PJ2fD2rYbBKW5jKhj0
         72S8C8/kUupdnzwCFp+WOzgDv5x2Ui4WfrHjpUc6SPsLFtNV+3jDjc9hi24sRG0jbDG9
         7stQ3ZedLgfKlhsHCodRNtbt+aAzfi/qB8gR21p00Sc0GsuQ5y8WR0iyBLu0mWFDY/Gp
         RfXqFSk8LQtoc1IzNbZC5yt3iqxi8I0tpMtgw3CG/MZGp+6uP5PMW/akou2x7FD4/fY4
         h50aqBjgLpHQmrIi6uSK+q+wdsEQHafO9DQtgCBzqzQDviTpBHdliRRjBz1Yb0HGm13Y
         oTbA==
In-Reply-To: <20131122165100.GN3556-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 22 Nov 2013, Johannes Weiner wrote:

> But userspace in all likeliness DOES need to take action.
> 
> Reclaim is a really long process.  If 5 times doing 12 priority cycles
> and scanning thousands of pages is not enough to reclaim a single
> page, what does that say about the health of the memcg?
> 
> But more importantly, OOM handling is just inherently racy.  A task
> might receive the kill signal a split second *after* userspace was
> notified.  Or a task may exit voluntarily a split second after a
> victim was chosen and killed.
> 

That's not true even today without the userspace oom handling proposal 
currently being discussed if you have a memcg oom handler attached to a 
parent memcg with access to more memory than an oom child memcg.  The oom 
handler can disable the child memcg's oom killer with memory.oom_control 
and implement its own policy to deal with any notification of oom.

This patch is required to ensure that in such a scenario that the oom 
handler sitting in the parent memcg only wakes up when it's required to 
intervene.  Making an inference about the "health of the memcg" can 
certainly be done with memory thresholds and vmpressure, if you need that.

I agree with Michal.
