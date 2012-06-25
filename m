From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] fix bad behavior in use_hierarchy file
Date: Mon, 25 Jun 2012 13:49:08 -0700
Message-ID: <20120625204908.GL3869@google.com>
References: <1340616061-1955-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uO5rmuSBmM/XqX6+ZAuDW+Oa+SSI3+OAJPor8x5y3lg=;
        b=kaKDTQPLV4cofWj/d4rtl7O+osaca0Jib4860dmaPJ27NEM9iG5/iscL9q25jYOTZP
         DYKwwP1Nu8BNU8DOchayABZgiJk2RdSLUJHBmVTxB5+bC1VAoxAmSoQDQkS/30lf4k8t
         1ydtTG9UNhZZ0fZWiMKUbEj5YnU4Q+5d/UrYpkU81TAeu8czomecNkWPkB3FDNDA5Ntc
         WT7ESrwSf7w5NA/jhJzmbSJQWw8/S7eBncQQ9eqP8tc0+Tri3pSqlvBCDvKazEYQBHXF
         gLUNRb/yUtd8jFuLynX1UvuCGTB0/bOQiWoJaV9uE1XDuaofY8r9AFh8UqcyGNOmKFJt
         aSnw==
Content-Disposition: inline
In-Reply-To: <1340616061-1955-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, Jun 25, 2012 at 01:21:01PM +0400, Glauber Costa wrote:
> I have an application that does the following:
> 
> * copy the state of all controllers attached to a hierarchy
> * replicate it as a child of the current level.
> 
> I would expect writes to the files to mostly succeed, since they
> are inheriting sane values from parents.
> 
> But that is not the case for use_hierarchy. If it is set to 0, we
> succeed ok. If we're set to 1, the value of the file is automatically
> set to 1 in the children, but if userspace tries to write the
> very same 1, it will fail. That same situation happens if we
> set use_hierarchy, create a child, and then try to write 1 again.
> 
> Now, there is no reason whatsoever for failing to write a value
> that is already there. It doesn't even match the comments, that
> states:
> 
>  /* If parent's use_hierarchy is set, we can't make any modifications
>   * in the child subtrees...
> 
> since we are not changing anything.
> 
> The following patch tests the new value against the one we're storing,
> and automatically return 0 if we're not proposing a change.

A bit of delta but is there any chance we can either deprecate
.use_hierarhcy or at least make it global toggle instead of subtree
thing?  This seems needlessly complicated. :(

-- 
tejun
