From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Disable on PREEMPT_RT
Date: Mon, 13 Dec 2021 11:08:26 +0100
Message-ID: <YbcbmvQk+Sgdsi9G@dhcp22.suse.cz>
References: <20211207155208.eyre5svucpg7krxe@linutronix.de>
 <Ya+SCkLOLBVN/kiY@cmpxchg.org>
 <YbNwmUMPFM/MO0cX@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639390108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sAlFWeBlMiXf+1RQBWZpSz97qKdbH168dZaJ4vBCj88=;
        b=rUPcmILWZKV8HVQCcAOG/7r1sDRrpwu3h02jFJQISqeJswZm+cmuKuPjTJzDAdK+xGFhdg
        OnM0Cae/CVt5zFQbjxQRDYh5WCHEo8C3zHEBNwB06Srz3YgrlHTotzrr02Zu1pi4Chq8Tq
        9WdcpaC89KsMkxK4es9O0AwrnBXd3NE=
Content-Disposition: inline
In-Reply-To: <YbNwmUMPFM/MO0cX-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri 10-12-21 16:22:01, Sebastian Andrzej Siewior wrote:
[...]
I am sorry but I didn't get to read and digest the rest of the message
yet. Let me just point out this

> The problematic part here is mem_cgroup_tree_per_node::lock which can
> not be acquired with disabled interrupts on PREEMPT_RT.  The "locking
> scope" is not always clear to me.  Also, if it is _just_ the counter,
> then we might solve this differently.

I do not think you should be losing sleep over soft limit reclaim. This
is certainly not something to be used for RT workloads and rather than
touching that code I think it makes some sense to simply disallow soft
limit with RT enabled (i.e. do not allow to set any soft limit).
-- 
Michal Hocko
SUSE Labs
