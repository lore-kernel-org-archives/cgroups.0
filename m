From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: clean up obsolete code and comment
Date: Thu, 17 Apr 2014 10:19:04 -0400
Message-ID: <20140417141904.GH15326@htj.dyndns.org>
References: <1397744056-31119-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VhUptKCuZ8B8GQT5outHO4pwb3u4SMG3NSXdkbZmwGQ=;
        b=jUW1iNowFEWRsxL55QkSohbiJgYxIwD7J/J5+YcmW2z+h6dF6wQpFP1pKRqQJasH2B
         WGf4bi9vanhgwl+2VCDF4vFvpX+loknWxwYySGeUspHeu9mBIMShrgm8Vlf4eJUU8oud
         EiXmKtzqck2hicXhRRmUZAufstJJAWsXCJrB3bGnJSTjnaJoaT4VYyqwKgTJHnqCIQ4U
         2pEU0nXEI+iFhwA5Iw4ZR8ldgR3uvH2sIPt8/ljre5PiGkVOi7TqEwPqp8vGGuat5Cwh
         iIhhSh1/iNJwKAPkY0xkhEInvk66DFP6PN7AjxHp1Vo2exjaMAHNEslfQKkGwooCwiM/
         mahQ==
Content-Disposition: inline
In-Reply-To: <1397744056-31119-1-git-send-email-nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 17, 2014 at 10:14:16PM +0800, Jianyu Zhan wrote:
> This patch purely makes cleanup.
> 
> 1. parse_cgroupfs_options() no longer takes refcounts on
>    subsystems to be used, update its comment.

And cgroup_subsys[] doesn't require cgroup_mutex protection anymore.
That comment and BUG_ON(!mutex_is_locked()) can be removed.  Can you
please separate these out into a separate patch?

> 2. cgroup_pidlist_seq_operations has no more user, remove it.
> 3. s/pr_warning/pr_warn/g, suggested by scripts/checkpatch.pl.

And let's put 2 and 3 in separate patches too.

> Signed-off-by: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Also, please regenerate the patches on top of the following branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-populated-v2

Thanks.

-- 
tejun
