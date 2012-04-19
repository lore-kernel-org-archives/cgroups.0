From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] don't take cgroup_mutex in destroy()
Date: Thu, 19 Apr 2012 15:57:04 -0700
Message-ID: <20120419225704.GE10553@google.com>
References: <1334875758-20939-1-git-send-email-glommer@parallels.com>
 <1334875758-20939-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+1zfD0oSLjYN4JT7oC35OfT74Fu2/+c5MGOu8UMlvvw=;
        b=QIW9cFn+m9O//Vdbm5WBv4zhvwcTypiUwgNoPxm6ut2Z29gbgjRqGHwoTscihYOT1S
         dGqxqjF3KdaVzVHoYJhhtRcLgX79lNpngaX8oPq84aBllWZ2PJzs7FWcnq3S01CzilXD
         lu+PnFr+7O/oCl+FuNbRTN56wUGaMNqOmzKvPAiEjzV8y7z9dlF5MY9skmhhqjR+/6Et
         dIIcQ5YGr/jCqUskSNdFzOrGMC87B3czPPkfszpvvNx3FCXNrxpOh+eazY7O3IxN7Wv4
         12tu79V8JKky2kxu7tupFbo0sGv4CeB7lHfS10E16FEei7/264J/PAPsWQ2qZAXFs7OZ
         z25A==
Content-Disposition: inline
In-Reply-To: <1334875758-20939-3-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Apr 19, 2012 at 07:49:17PM -0300, Glauber Costa wrote:
> Most of the destroy functions are only doing very simple things
> like freeing memory.
> 
> The ones who goes through lists and such, already use its own
> locking for those.
> 
> * The cgroup itself won't go away until we free it, (after destroy)
> * The parent won't go away because we hold a reference count
> * There are no more tasks in the cgroup, and the cgroup is declared
>   dead (cgroup_is_removed() == true)
> 
> For the blk-cgroup and the cpusets, I got the impression that the mutex
> is still necessary.
> 
> For those, I grabbed it from within the destroy function itself.
> 
> If the maintainer for those subsystems consider it safe to remove
> it, we can discuss it separately.

I really don't like cgroup_lock() usage spreading more.  It's
something which should be contained in cgroup.c proper.  I looked at
the existing users a while ago and they seemed to be compensating
deficencies in API, so, if at all possible, let's not spread the
disease.

Thanks.

-- 
tejun
