From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Disable on PREEMPT_RT
Date: Wed, 15 Dec 2021 18:13:40 +0100
Message-ID: <YboiRA1znig/cbCt@linutronix.de>
References: <20211207155208.eyre5svucpg7krxe@linutronix.de>
 <Ya+SCkLOLBVN/kiY@cmpxchg.org>
 <YbNwmUMPFM/MO0cX@linutronix.de>
 <YbcbmvQk+Sgdsi9G@dhcp22.suse.cz>
 <YbocOh+h3o/Yc5Ag@linutronix.de>
 <YboeI1aTFdQpN0TI@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639588421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jYXjzbGZlnN964PjJtzgEeX8RXqMVqwrS5n7/IuOGFI=;
        b=REqxSx+V31su26fCsE584O65uicmLycV3UA7QCYU9fdpth3uBkeQoRi4uJDeJLc4JUvAtD
        +PHYJDuMxpxJGiz2JkppXqJZcskLdO4iXoeTIJt/ImE8S72gp2dAA3Cx0sGcR6kGIxStY2
        +52K2rbXYrTAxMSNFYImMHK6G9rpOttoQvCxrLbhK/w7cvjU4ao8Yi3HVfoawP7Ah6/PDg
        nITGvxnemLqPRUlENkSdgr6gzPfPnb5FtV3qPfhrHYXdmE6/4xp/LYaaNoA8VE/+k5EVX1
        +Iwcc+fsW8iKf1R7Q8M/Cxu6iZ9tw48srCmxB4wUd73qxqorCjBGXjGqOFJ6WA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639588421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jYXjzbGZlnN964PjJtzgEeX8RXqMVqwrS5n7/IuOGFI=;
        b=QJ4AOPazmGLlU6Mdv7IO0XBCvO5u84k/9ccp0EH3VnFLVEfxqOu8XJY74BDcJ7iQQ8AYPB
        RsymUKCJvMZ/QrAg==
Content-Disposition: inline
In-Reply-To: <YboeI1aTFdQpN0TI-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2021-12-15 17:56:03 [+0100], Michal Hocko wrote:
> On Wed 15-12-21 17:47:54, Sebastian Andrzej Siewior wrote:
> > On 2021-12-13 11:08:26 [+0100], Michal Hocko wrote:
> > > On Fri 10-12-21 16:22:01, Sebastian Andrzej Siewior wrote:
> > > [...]
> > > I am sorry but I didn't get to read and digest the rest of the message
> > > yet. Let me just point out this
> > > 
> > > > The problematic part here is mem_cgroup_tree_per_node::lock which can
> > > > not be acquired with disabled interrupts on PREEMPT_RT.  The "locking
> > > > scope" is not always clear to me.  Also, if it is _just_ the counter,
> > > > then we might solve this differently.
> > > 
> > > I do not think you should be losing sleep over soft limit reclaim. This
> > > is certainly not something to be used for RT workloads and rather than
> > > touching that code I think it makes some sense to simply disallow soft
> > > limit with RT enabled (i.e. do not allow to set any soft limit).
> > 
> > Okay. So instead of disabling it entirely you suggest I should take
> > another stab at it? Okay. Disabling softlimit, where should I start with
> > it? Should mem_cgroup_write() for RES_SOFT_LIMIT always return an error
> > or something else?
> 
> Yeah, I would just return an error for RT configuration. If we ever need
> to implement that behavior for RT then we can look at specific fixes.

Okay. What do I gain by doing this / how do I test this? Is running
tools/testing/selftests/cgroup/test_*mem* sufficient to test all corner
cases here?

> Thanks!
Thank you ;)

Sebastian
