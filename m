From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC REPOST] cgroup: removing css reference drain wait during
 cgroup removal
Date: Tue, 13 Mar 2012 09:39:14 -0700
Message-ID: <20120313163914.GD7349@google.com>
References: <20120312213155.GE23255@google.com>
 <20120312213343.GF23255@google.com>
 <20120313151148.f8004a00.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UVhubnif2dpW5PThuoS4996u+6j24kMdqK2DJ7thXv4=;
        b=hTptZii6/oUin5sBEFCQkG1HWKc4wNIaAQxxmt+mEWXBxjjPnhFw9CiKT1QJhOYkDj
         HvT+slILn5Wo+wcIu0KK4nm/OnU5wcv6OrqVPXqUCKI4//2w6e2v22+o2m7qM/TqB0ru
         hk4viVaM3uSbya0Zox01L9LLYO96LmcD9MvURhHIEx+h2v76RiMjqQ9D5yAJpRrbQqQB
         OyAjub7R9tUHEz2CNOI0cI7LW1UnzYevoLWy2n7bDNgD8q26j2GFtdmCR51CFTOXQRGR
         V2PrSlbdV/8dK0az1BcJu3QxGoqx63bopadnNbg+JQ0i/Y2Q8yMYQ1sUNDyCGB+NmVY5
         xNOw==
Content-Disposition: inline
In-Reply-To: <20120313151148.f8004a00.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, KAMEZAWA.

On Tue, Mar 13, 2012 at 03:11:48PM +0900, KAMEZAWA Hiroyuki wrote:
> The trouble for pre_destroy() is _not_ refcount, Memory cgroup has its own refcnt
> and use it internally. The problem is 'charges'. It's not related to refcnt.

Hmmm.... yeah, I'm not familiar with memcg internals at all.  For
blkcg, refcnt matters but if it doesn't for memcg, great.

> Cgroup is designed to exists with 'tasks'. But memory may not be related to any
> task...just related to a cgroup.
> 
> But ok, pre_destory() & rmdir() is complicated, I agree.
> 
> Now, we prevent rmdir() if we can't move charges to its parent. If pre_destory()
> shouldn't fail, I can think of some alternatives.
> 
>  * move all charges to the parent and if it fails...move all charges to
>    root cgroup.
>    (drop_from_memory may not work well in swapless system.)

I think this one is better and this shouldn't fail if hierarchical
mode is in use, right?

> I think.. if pre_destory() never fails, we don't need pre_destroy().

For memcg maybe, blkcg still needs it.

> >   The last one seems more tricky.  On destruction of cgroup, the
> >   charges are transferred to its parent and the parent may not have
> >   enough room for that.  Greg told me that this should only be a
> >   problem for !hierarchical case.  I think this can be dealt with by
> >   dumping what's left over to root cgroup with a warning message.
> 
> I don't like warning ;) 

I agree this isn't perfect but then again failing rmdir isn't perfect
either and given that the condition can be wholly avoided in
hierarchical mode, which should be the default anyway (is there any
reason to keep flat mode except for backward compatibility?), I don't
think the trade off is too bad.

> I think we can do all in 'destroy()'.

That would be even better.  I tried myself but that was a lot of code
I didn't have much idea about.  If someone more familiar with memcg
can write up such patch, I owe a beer. :)

Thank you.

-- 
tejun
