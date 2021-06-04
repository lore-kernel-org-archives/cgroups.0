From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix kernel-doc
Date: Fri, 4 Jun 2021 10:51:25 -0400
Message-ID: <YLo97dfH7YOSLf5S@slm.duckdns.org>
References: <1621997349-118999-1-git-send-email-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RXCvfYSa38byXD2N1/fwQZOmkk+TUNZ19R3TGRpTRWk=;
        b=bqZuc7V4Te8HZclf1lNnPlamU6AU6Fb50rT8BqxHcQqYIT+TosF8EyGLsla2W/orEI
         8QxZX9Ufyng0ZoOk6XxyiI7Qfq6/t+g2QYiGRVxedBBchWxLWjsWh9pLgseqFFoWc34H
         DRBZfgf4rDURZdNFvmWuIGVOiidbO+ZyPxdnlOTSYEkj8ESjwcENaeiyGS2hK4ZAq3Q9
         7yVCFSMrYjMZMCslbxh+nTCq8SUC0CSEMNlbwD7gMoVEhXwtjVbVE6L7j6kCuVJxsEMq
         6mfXtmESlMAew88ZmVzezfzm9u50P+sYWgJ4FzLcZGjAOHAIgv7r/OMo1Mo9Jwc6Uc6J
         SbCg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1621997349-118999-1-git-send-email-yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 26, 2021 at 10:49:09AM +0800, Yang Li wrote:
> Fix function name in cgroup.c and rstat.c kernel-doc comment
> to remove these warnings found by clang_w1.
> 
> kernel/cgroup/cgroup.c:2401: warning: expecting prototype for
> cgroup_taskset_migrate(). Prototype was for cgroup_migrate_execute()
> instead.
> kernel/cgroup/rstat.c:233: warning: expecting prototype for
> cgroup_rstat_flush_begin(). Prototype was for cgroup_rstat_flush_hold()
> instead.
> 
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Fixes: 'commit e595cd706982 ("cgroup: track migration context in cgroup_mgctx")'
> Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Applied to cgroup/for-5.14.

Thanks.

-- 
tejun
