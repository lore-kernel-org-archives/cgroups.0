From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg] memcg: prohibit unconditional exceeding the limit
 of dying tasks
Date: Mon, 13 Sep 2021 10:42:56 +0200
Message-ID: <YT8PEBbYZhLixEJD@dhcp22.suse.cz>
References: <5b06a490-55bc-a6a0-6c85-690254f86fad@virtuozzo.com>
 <099aa0db-045a-e5b8-6df7-b7c3fc4d3caa@i-love.sakura.ne.jp>
 <4a407474-ff7a-9e4f-d314-ab85f0eeaadf@virtuozzo.com>
 <YTtx3toUOMLXk4GZ@dhcp22.suse.cz>
 <9556c2ae-2dc8-9d0a-55de-002d674680bf@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631522577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8kanT9LvCczrJLW86//mm44q0kFal7DLHz1meuR6IX0=;
        b=auSFP3cSbtLDH8/xVJew4IJ/MN1dguOz5Le3URoMTqsmLf9D172qnDKyHsvueFiQpQni+V
        iqYmA0o/CA185fT9Fu5DYTdrKJ9FsKsopivFohrGz4IA4xpbdx8zaR0+EF8n/DbRV2DeGq
        KjLTsEbgxqHjGwGRRe1FlKKen1sn0b8=
Content-Disposition: inline
In-Reply-To: <9556c2ae-2dc8-9d0a-55de-002d674680bf-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon 13-09-21 11:29:37, Vasily Averin wrote:
> On 9/10/21 5:55 PM, Michal Hocko wrote:
> > On Fri 10-09-21 16:20:58, Vasily Averin wrote:
> >> On 9/10/21 4:04 PM, Tetsuo Handa wrote:
> >>> Can't we add fatal_signal_pending(current) test to vmalloc() loop?
> > 
> > We can and we should.
> > 
> >> 1) this has been done in the past but has been reverted later.
> > 
> > The reason for that should be addressed IIRC.
> 
> I don't know the details of this, and I need some time to investigate it.

b8c8a338f75e ("Revert "vmalloc: back off when the current task is killed"")
should give a good insight and references.

> >> 2) any vmalloc changes will affect non-memcg allocations too.
> >>  If we're doing memcg-related checks it's better to do it in one place.
> > 
> > I think those two things are just orthogonal. Bailing out from vmalloc
> > early sounds reasonable to me on its own. Allocating a large thing that
> > is likely to go away with the allocating context is just a waste of
> > resources and potential reason to disruptions to others.
> 
> I doubt that fatal signal should block any vmalloc allocations.
> I assume there are situations where rollback of some cancelled operation uses vmalloc.
> Or coredump saving on some remote storage can uses vmalloc.

If there really are any such requirements then this should be really
documented. 

> However for me it's abnormal that even OOM-killer cannot cancel huge vmalloc allocation.
> So I think tsk_is_oom_victim(current) check should be added to vm_area_alloc_pages() 
> to break vmalloc cycle.

Why should oom killed task behave any different than any other task
killed without a way to handle the signal?

-- 
Michal Hocko
SUSE Labs
