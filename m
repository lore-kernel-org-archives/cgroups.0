From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 9/9 v2] cgroup_freezer: implement proper hierarchy support
Date: Thu, 8 Nov 2012 07:29:23 -0800
Message-ID: <20121108152923.GG12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121107163919.GC2660@mtj.dyndns.org>
 <20121108140852.GI31821@dhcp22.suse.cz>
 <20121108141848.GA12973@htj.dyndns.org>
 <20121108152039.GL31821@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=h5xmeEbTOCZpDtV7e5yDA0tqu8heBzBWV6pw+CKMKPQ=;
        b=YKUVwnlQP/I48lCes4mWDYZd6RDG5WmmliXUrhUcEzPiOc+8abdLSb6uKt4j+xdSRU
         U6yEZvo3yy8G3fK2WsfMeI932N7YBi1qTf4u7VwaFISwStFqs56r/v2izM64oWdLcJPp
         +lD6U2Li7HQQGISw+wgZ5Bh14S9/l0X99adfkRIqo0ehy1lhDaOIJrmutJAWtyw8q6BS
         dg+l/Lt3Or+wwO6QamhE81iNQf4Me2Z/05WqZcK/hm2cBXkkRDdK47lo57ZM7V1yV9Rt
         OhcdZXYReMv9DaFWIirx8qr6KE6+UUo/6RexkxTqZkxFN7brRR53gQCHiOaBVSMWunR2
         Z68g==
Content-Disposition: inline
In-Reply-To: <20121108152039.GL31821-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hey, Michal.

On Thu, Nov 08, 2012 at 04:20:39PM +0100, Michal Hocko wrote:
> > So, in the above example in CPU2, (B->state & FREEZING) test and
> > freezer_apply_state(C, false) can't be interleaved with the same
> > inheritance operation from CPU1.  They either happen before or after.
> 
> I am not sure I understand what you mean by inheritance operation but

The operation of looking at one's parent and inherting the state.
Here, checking parent->state and calling apply_state accordingly.

> you are right that the race is not possible because spin_lock makes
> sure that Foo->state is done after the lock(Foo->child) and spin_unlock
> then serves as a leave barrier so the other CPUs will see the correctly
> updated value. The rest is handled by the fixed ordered tree walk. So
> there is really no interleaving going on here.

I'm worried that this is a bit too subtle.  This will work fine with a
single hierarchy mutex protecting hierarchy updates and state
propagations through it and that should work for most controllers too.
I want to have at least one example of finer grained locking for
future reference and cgroup_freezer happened to be the one I started
working on.  So, it is more complicated (not necessarily in written
code but the sync rules) than necessary.  I'm still not sure whether
to keep it or not.  I'll add more documentation about synchronization
in cgroup_for_each_descendant_pre() either way.

Thanks.

-- 
tejun
