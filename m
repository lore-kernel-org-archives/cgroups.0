From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: remove cgroup_tree_mutex
Date: Tue, 13 May 2014 12:22:19 -0400
Message-ID: <20140513162219.GB1866@htj.dyndns.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+yLkRjziE7YSR5SOl7V292Qa0KjVVxWS22OHL2D2A4U=;
        b=tRJ7vLINLP5g/30oRmmGPmuAkuPs8S0Q8zyuKRmNMbiFkzc6aUpTNhKr9BBqmF9yqJ
         1UtqMQ4f8Z+9WiUxZXYqxwO5vhHlsyYMmMZkYrLOLfsrvgqyKqgT1OTtnDUi0F0NeCNi
         M/oRN+ojtLN4rSS/FmfLo4VB/i5o5uVhew33pRjyk1SUllmIj3Kci8CrNiG3kQoRJ8m8
         um77QZCc6X7ifOSwT4fFzrld2dH8IkCqEL+Li9f4FOA3BQyXc1xjYrd425ZpSiM9/E1R
         UBv5DOoEXYWNCkFwUP8v87m1na2af35x1XQMPiU0AxEca6VyPBOMG3sdssqK9zcIoh0w
         rRzA==
Content-Disposition: inline
In-Reply-To: <1399407574-21472-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 06, 2014 at 04:19:26PM -0400, Tejun Heo wrote:
> Hello,
> 
> cgroup_tree_mutex was introduced during kernfs conversion to work
> around the cyclic locking dependency between kernfs active protection
> and cgroup_mutex.  Some file and directory operations need to acquire
> cgroup_mutex which puts the mutex under the kernfs active protection;
> however, cgroup also needs to access the hierarchy and the registered
> cftypes to detemine which files to remove, which obviously can't be
> done while holding cgroup_mutex anymore.
> 
> cgroup_tree_mutex nests above both cgroup_mutex and kernfs active
> protection and protects hierarchy and cftypes so that those file
> operations can be performed while holding it without cgroup_mutex.
> This works but is kinda cumbersome as most places end up taking both
> cgroup_tree_mutex and cgroup_mutex and there's on-going friction on
> what needs to be protected by which combination.
> 
> Furthermore, due to new requirements from subtree_control
> implementations, kernfs ended up growing full-blown mechanism to
> bypass active protection instead of just supporting self-removal and
> cgroup ended up using both mechanisms - two layered mutexes and active
> protection bypss - on different areas, which is totally unncessary.
> 
> This patchset converts everything over to kernfs active protection
> bypass and drops cgroup_tree_mutex making cgroup locking noticeably
> simpler.  It contains the following eight patches.
> 
>  0001-cgroup-reorganize-cgroup_create.patch
>  0002-cgroup-collapse-cgroup_create-into-croup_mkdir.patch
>  0003-cgroup-grab-cgroup_mutex-earlier-in-cgroup_subtree_c.patch
>  0004-cgroup-move-cgroup-kn-priv-clearing-to-cgroup_rmdir.patch
>  0005-cgroup-factor-out-cgroup_kn_lock_live-and-cgroup_kn_.patch
>  0006-cgroup-use-cgroup_kn_lock_live-in-other-cgroup-kernf.patch
>  0007-cgroup-nest-kernfs-active-protection-under-cgroup_mu.patch
>  0008-cgroup-remove-cgroup_tree_mutex.patch

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
