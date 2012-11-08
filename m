From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 9/9 v2] cgroup_freezer: implement proper hierarchy support
Date: Thu, 8 Nov 2012 06:18:48 -0800
Message-ID: <20121108141848.GA12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121107163919.GC2660@mtj.dyndns.org>
 <20121108140852.GI31821@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=F9LgQMiVjvsuDntRVh/BPzbhBwjLEXg/1QUoe+F2QJ4=;
        b=BRrZXKaIhZNN3qpV9/gQyuirbw0Q7mB2y9KufCdHgqmSZ/TYoGKn2iVEybKTsSqc57
         3ABuMuJ+eqwT6vo0WRdLUS+3ZMB2Yx3eIb/Ud7qYkZvxEvANQ6CNMrHXRmHNcMeMj7BR
         C5Hwn2SsBAWyb6kxHtpUgG3KHCCLKbqgi0RQD+GEPVB9py/aLq34e8nDRQt3aWcSJ6Z/
         7gty9KibS+TNqCUDx4s0KchEmF7fm/Zl7neI/vo9Eb8MWpmqhB5ZSuiWRe51D9eA3F6s
         iTzqSQtoY9AqwRW4pXa8/mgWtQLIq0+aBN++Ntq+i6UiDkJmK4EH7WECZkYgHtmsvxyn
         lFzQ==
Content-Disposition: inline
In-Reply-To: <20121108140852.GI31821-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello, Michal.

On Thu, Nov 08, 2012 at 03:08:52PM +0100, Michal Hocko wrote:
> This seems to be racy because parent->state access is not linearized.
> Say we have parallel freeze and thawing on a tree like the following:
> 	A
> 	|
> 	B
>         |
>         C 
> 
> pre_order will visit them in B, C order.
> 	CPU1						CPU2
> freezer_apply_state(A, true)
> A->state & FREEZING == true		freezer_apply_state(A, false)
> 					A->state & FREEZING == false
> 					freezer_apply_state(B, false)
> 					B->state & FREEZING == false
> freezer_apply_state(B, true)
> 
> B->state & FREEZING == true
> freezer_apply_state(C, true)
> 					freezer_apply_state(C, false)
> 
> So A, C are thawed while B is frozen. Or am I missing something which
> would prevent from this kind of race?

The rule is that there will be at least one inheritance operation
after a parent is updated.  The exact order of propagation doesn't
matter as long as there's at least one inheritance event after the
latest update to a parent.  This works because inheritance operations
are atomic to each other.  If one inheritance operation "saw" an
update to its parent, the next inheritance operation is guaranteed to
see at least upto that update.

So, in the above example in CPU2, (B->state & FREEZING) test and
freezer_apply_state(C, false) can't be interleaved with the same
inheritance operation from CPU1.  They either happen before or after.

Maybe it's too subtle.  The only reason I didn't use a giant
freezer_mutex was that I wanted to demonstrate how to do state
propagation without depending on single giant lock.  Maybe nobody
wants that and this should use one mutex to protect the hierarchy.  I
don't know.

Thanks.

-- 
tejun
