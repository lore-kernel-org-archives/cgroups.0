From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm] vmalloc: back off when the current task is OOM-killed
Date: Fri, 24 Sep 2021 09:55:08 +0200
Message-ID: <YU2EXP5wrSKv+b/8@dhcp22.suse.cz>
References: <YT8PEBbYZhLixEJD@dhcp22.suse.cz>
 <d07a5540-3e07-44ba-1e59-067500f024d9@virtuozzo.com>
 <YUsg4j8gEt+WOCzi@dhcp22.suse.cz>
 <fa29c6f9-a53c-83bd-adcb-1e09d4387024@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632470111; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6+5dT0e/LVnNHHcl0ABQyeUOLyC28rt8o7MtGQJ16Wk=;
        b=KWiNL3UHQbuoAkuBsiy3YSQftN/E2jhVDCGJVJ4SuDi14ga6EYTPLdskYk6XwXRICZFsXG
        bEWK+3mJ2tb2wipT9UFRw4dJv04b+FFJK7rjY3eOiFx60uVYVav5B3hKKV06bppDfRyf6C
        q8TEmpzdS0lmOTDDH+ryD1WOMtFlK0k=
Content-Disposition: inline
In-Reply-To: <fa29c6f9-a53c-83bd-adcb-1e09d4387024-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu 23-09-21 09:49:57, Vasily Averin wrote:
[...]
> I'm agree that vmalloc callers should expect and handle single vnalloc failures.
> I think it is acceptable to enable fatal_signal_pending check to quickly
> detect such kind of iussues.
> However fatal_signal_pending check can cause serial vmalloc failures
> and I doubt it is acceptable. 
> 
> Rollback after failed vmalloc can call new vmalloc calls that will be failed too, 
> even properly handled such serial failures can cause troubles.

Could you be more specific? Also how would this be any different from
similar failures for an oom victim? Except that the later is less likely
so (as already mentioend) any potential bugs would be just lurking there
for a longer time.

> Hypothetically, cancelled vmalloc called inside some filesystem's transaction
> forces its rollback, that in own turn it can call own vmalloc.

Do you have any specific example?

> Any failures on this path can break the filesystem.
> I doubt it is acceptable, especially for non-OOM fatal signals.
> On the other hand I cannot say that it is a 100% bug.
> 
> Another scenario:
> as you know failed vmalloc calls pr_warn. According message should be sent
> to remote terminal or netconsole. I'm not sure about execution context,
> however if this is done in task context it may call vmalloc either in terminal
> or in network subsystems. Even handled, such failures are not fatal,
> but this behaviour is at least unexpected.

I do not think we want to shape the vmalloc bahavior based on
printk/console behavior.

> Should we perhaps interrupt the first vmalloc only?

This doesn't make much sense to me TBH. It doesn't address the very
problem you are describing in the changelog.
-- 
Michal Hocko
SUSE Labs
