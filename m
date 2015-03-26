From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 2/3] cgroups: allow a cgroup subsystem to reject a fork
Date: Thu, 26 Mar 2015 11:02:23 -0400
Message-ID: <20150326150223.GA1953@htj.duckdns.org>
References: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
 <1426307835-5893-3-git-send-email-cyphar@cyphar.com>
 <20150316165335.GC8353@htj.duckdns.org>
 <CAOviyahTq1K6zBRfmXfepabiQ7xU8ZoNdq0jPd3nP4Q-0H1DDQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kaIT8wdSGm1rMke1vkpIM4OEkxR3l3egldmietwG/jY=;
        b=aXdYsc/JX8f+PQv5sokd6xfwI3F8j8t1vwtYfD6/h07utqcxUEVS+CrnRe4zSWwJfy
         XLWTf5K0BUm8y8Frk19BUz5iAM0ZH70VdgcTC66hPOBq+N90BwXkPPACBTvxpkS59aeh
         ynXsUaRjHzE5A4yY4740k4UGaXPErFR+i8IrTKELic2QC4D5sWQ9rNz2f3JZx6PRGmTq
         NU07AEYuO0c/uH+Paiqbk0Fye4GgyxlEK2VHjtZQsjUGmnmHsIhw64rmWjK/3FZBrdx2
         w6WW4GrD/IygQO77O13MhJJ/F/Vh2t24OUddG0ztOovm6o7NBAN6HtdNHEaytWzfvYl4
         1oWw==
Content-Disposition: inline
In-Reply-To: <CAOviyahTq1K6zBRfmXfepabiQ7xU8ZoNdq0jPd3nP4Q-0H1DDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Mar 27, 2015 at 01:38:54AM +1100, Aleksa Sarai wrote:
> The issue I can see with passing around an opaque pointer to fork() is that you
> have a random private (void **) argument that is completely useless if you
> don't use can_fork(). This is why I think we should call the reapply_fork()

Just pass NULL?  I really don't like having another callback.  pre and
post do make sense because the operation is essentially a transaction.
The problem with adding additional callbacks is that they aren't
essential and as such arbitrary to a certain degree.  reapply_fork or
whatnot may fit this case but may not others, so let's please stick
with what the logic dictates to be essential.

> callback if the association changes [we could call it something else if you
> like, since reapply_fork() is a pids-specific name -- what about switch_fork(),
> reassoc_fork(), re_fork() or something to show that it's a callback if the
> association changes?] (the subsystem can decide if they want to ignore it / if
> they don't want to touch it) and we deal with pinning / dropping the ref of the
> css_set for the current task inside the cgroup_* callbacks. That way, we don't
> start messing around with post-fork() callbacks that aren't related to the new
> conditional stuff.

You can't pin css_set from inside cgroup callbacks.  It's a construct
which in general shouldn't be accessible outside cgroup core.

> I mean, if you want to have a random, completely unused and essentially
> vestigial argument to ss->fork() [if you don't use the new can_fork() callbacks
> (and actually care about storing private data)] then I can just write that. It
> just looks like a weird callback API imho.

It's an opaque token from pre.  If a subsys doesn't have pre, it's
NULL.  I don't see anything weird about that, so let's please go that
way.

Thanks.

-- 
tejun
