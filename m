From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Date: Fri, 7 Feb 2014 10:13:41 -0500
Message-ID: <20140207151341.GB3304@htj.dyndns.org>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
 <20140207140402.GA3304@htj.dyndns.org>
 <20140207143740.GD5121@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=igi0qLA/LtlFKQtUQySrLNbGyS7vt86rGIUOg9fZS18=;
        b=uyOb84RR09jDywunlQjNLjQrRv3EXKvusYH1hXloZCkZvdJ7cvHz2WmY+m2GFOic1/
         AVAgflExqMv6dJy7N25Dw38SFf5jrLuoJITeYD3zgHgbAwc45L9IfWfPUwPOF+d79AbD
         UD7hjIlGoGs88xTssarBdwwygVi/8akXJmjpWWwRBF9waZYpguQvOXm5wzsnmRMe5OaR
         /OZE1IVJF6XKMO2QatnqltTuBBn0VKqzJlT3ZHeQ17Gj7gi6ek8f9hBlAnoftAWQTS2V
         lyfEV7G+rbiXBl4mEFp1r0NrH/r/CFdZPAOZwc2AEaxoxllLAQnCXqO+iM4ZJQoYvdgC
         5KGQ==
Content-Disposition: inline
In-Reply-To: <20140207143740.GD5121-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello, Michal.

On Fri, Feb 07, 2014 at 03:37:40PM +0100, Michal Hocko wrote:
> Hmm, this is a bit tricky. We cannot use memcg iterators to reach
> children because css_tryget would fail on them. We can use cgroup
> iterators instead, alright, and reparent pages from leafs but this all
> sounds like a lot of complications.

Hmmm... I think we're talking past each other here.  Why would the
parent need to reach down to the children?  Just bail out if it can't
make things down to zero and let the child when it finishes its own
cleaning walk up the tree propagating changes.  ->parent is always
accessible.  Would that be complicated too?

> Another option would be weakening css_offline reparenting and do not
> insist on having 0 charges. We want to get rid of as many charges as
> possible but do not need to have all of them gone
> (http://marc.info/?l=linux-kernel&m=139161412932193&w=2). The last part
> would be reparenting to the upmost parent which is still online.
> 
> I guess this is implementable but I would prefer Hugh's fix for now and
> for stable.

Yeah, for -stable, I think Hugh's patch is good but I really don't
want to keep it long term.

Thanks.

-- 
tejun
