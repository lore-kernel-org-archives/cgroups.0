From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Fri, 15 Apr 2016 11:25:26 -0400
Message-ID: <20160415152526.GJ12583@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415070601.GA32377@dhcp22.suse.cz>
 <20160415143815.GH12583@htj.duckdns.org>
 <20160415150815.GM32377@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HRcbDRoQqJei4oyAZnw5RUhquIIs742Gk/2yNP5OgoE=;
        b=cN2mqc3n5qG3z7cr5vqk5UZRPxYeEiw9ry69koGl6BO7eouOS7ykoGLicEoAjSvbC1
         5aO7a3EmXc1ZzwyYb+n8SaUszkgU7oD6FZSK3yU7yd9eFmdiBi4yjambDjCU0tbRacuM
         D8yrjN8XjsJ+SRIS9ESUxTngBQQ9X4N7tSx5lDt/5YQcJhd++9Rh0+yl7tj1w7MgM77q
         pATzu6jJ3aS4IrfQ0kZdg9JILsHg3DS/eHlYkqKfaMccHJFurIUrFARmXrigLgQcPJy8
         c+wyY+d3HAelHeQlqY2OnUV4K7FXhQirsS5vfAlRgCDqFtwNpUs2UGtO2bT01zP9FqHE
         K7uw==
Content-Disposition: inline
In-Reply-To: <20160415150815.GM32377-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Apr 15, 2016 at 05:08:15PM +0200, Michal Hocko wrote:
> On Fri 15-04-16 10:38:15, Tejun Heo wrote:
> > Not necessarily.  The only thing necessary is flushing the work item
> > after releasing locks but before returning to user.
> > cpuset_post_attach_flush() does exactly the same thing.
> 
> Ahh, ok, didn't know that __cgroup_procs_write is doing something
> controller specific. Yes then we wouldn't need a generic callback if
> another code like above would be acceptable.

Yeah, I thought it'd be an one-off thing so didn't made it a generic
callback.  Making it a generic callback isn't a problem tho.

> > > really relies on the previous behavior I guess we can solve it with a
> > > post_move cgroup callback which would be called from a lockless context.
> > > 
> > > Anyway, before we go that way, can we at least consider the possibility
> > > of removing the kworker creation dependency on the global rwsem? AFAIU
> > > this locking was added because of the pid controller. Do we even care
> > > about something as volatile as kworkers in the pid controller?
> > 
> > It's not just pid controller and the global percpu locking has lower
> 
> where else would the locking matter? I have only checked the git history
> to build my picture so I might be missing something of course.

IIRC, there were followup patches which fixed and/or simplified
locking paths.  It's just generally a lot simpler to deal with.  The
downside obviously is that cgroup core operations can't depend on task
creation.  I didn't expect memcg to trigger it too tho.  I don't think
we wanna be doing heavy-lifting operations like node migration or page
relabeling while holding cgroup lock anyway, so would much prefer
making them async.

> > hotpath overhead.  We can try to exclude kworkers out of the locking
> > but that can get really nasty and there are already attempts to add
> > cgroup support to workqueue.  Will think more about it.  For now tho,
> > do you think making charge moving async would be difficult?
> 
> Well it certainly is not that trivial because it relies on being
> exclusive with global context. I will have to look closer of course but
> I cannot guarantee I will get to it before I get back from LSF. We can
> certainly discuss that at the conference. Johannes will be there as
> well.

I see.  For cpuset, it didn't really matter but what we can do is
creating a mechanism on cgroup core side which is called after a
migration operation is done after dropping the usual locks and
guarantees that no new migration will be started before the callbacks
finish.  If we have that, relocating charge moving outside the attach
path should be pretty trivial, right?

Thanks.

-- 
tejun
