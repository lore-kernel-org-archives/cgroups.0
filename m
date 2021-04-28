From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Wed, 28 Apr 2021 12:04:28 -0400
Message-ID: <YImHjGGuIt0ebL0G@slm.duckdns.org>
References: <20210423171351.3614430-1-brauner@kernel.org>
 <YIcOZEbvky7hGbR1@blackbook>
 <20210427093606.kygcgb74otakofes@wittgenstein>
 <YIgfrP5J3aXHfM1i@slm.duckdns.org>
 <20210428143746.p6tjwv6ywgpixnjy@wittgenstein>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9HgqzHqJPJLGc6VWM3q5vYoH4SbYPkaPRyIzhlX9Bos=;
        b=Bht3BSV6WGP5XFX0RRKMCTKA/B8W9utzqx+JvWKtKweNfmYxP9lLsJTExmM+rLe+Yk
         bWElCmDPEv4UYdxf4dkn/cUUnQ3lMpDFXP1hisUfEk6H7+b8FCANGwD4WXdxFz04bAhy
         RCT2ibFZwBQT4h42o43U8lplF6THU3M11Hh2eK4HknO7MVZNyCrxOxlDTKV/HMcipXSu
         xy/JROxrhxrPqjz/RL5CdZGPvD7hSWv8JnZr7YTUlAoRes6REUry3V8V5t4TKOmXnMZX
         xnvfSJBr6WN6WJo8dDvxTeP5LmzsUnSVOduK9FxAcU22LReNmnWVRVrmjM4hR24SLJD0
         yMOw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210428143746.p6tjwv6ywgpixnjy@wittgenstein>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Apr 28, 2021 at 04:37:46PM +0200, Christian Brauner wrote:
> > I'd align it with cgroup.procs. Killing is a process-level operation (unlike
> > arbitrary signal delivery which I think is another reason to confine this to
> > killing) and threaded cgroups should be invisible to process-level
> > operations.
> 
> Ok, so we make write to cgroup.kill in threaded cgroups EOPNOTSUPP which
> is equivalent what a read on cgroup.procs would yield.

Sounds good to me.

> Tejun, Roman, Michal, I've been thinking a bit about the escaping
> children during fork() when killing a cgroup and I would like to propose
> we simply take the write-side of threadgroup_rwsem during cgroup.kill.
> 
> This would give us robust protection against escaping children during
> fork() since fork()ing takes the read-side already in cgroup_can_fork().
> And cgroup.kill should be sufficiently rare that this isn't an
> additional burden.
> 
> Other ways seems more fragile where the child can potentially escape
> being killed. The most obvious case is when CLONE_INTO_CGROUP is not
> used. If a cgroup.kill is initiated after cgroup_can_fork() and after
> the parent's fatal_signal_pending() check we will wait for the parent to
> release the siglock in cgroup_kill(). Once it does we deliver the fatal
> signal to the parent. But if we haven't passed cgroup_post_fork() fast
> enough the child can be placed into that cgroup right after the kill.
> That's not super bad per se since the child isn't technically visible in
> the target cgroup anyway but it feels a bit cleaner if it would die
> right away. We could minimize the window by raising a flag say CGRP_KILL
> say:

So, yeah, I wouldn't worry about the case where migration is competing
against killing. The order of operations simply isn't defined and any
outcome is fine. As for the specific synchronization method to use, my gut
feeling is whatever which aligns better with the freezer implementation but
I don't have strong feelings otherwise. Roman, what do you think?

Thanks.

-- 
tejun
