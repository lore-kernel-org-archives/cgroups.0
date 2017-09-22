From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Reinit cgroup_taskset structure before
 cgroup_migrate_execute() returns
Date: Fri, 22 Sep 2017 08:16:49 -0700
Message-ID: <20170922151649.GE828415@devbig577.frc2.facebook.com>
References: <1506002053-13380-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L3bhWA0k4KOYpLxcTCZUugzz+17pK8MwVT5ThCvwHEs=;
        b=GDoHCz0dq3dQXzhzqDWUG0KmqheM1LFCvqB44ySxGRj/r9u41DLDeAyQ/ji7scP3Wc
         2OX3EOzR8ySiJ4TatRm+41p1Za/Wk5jsfdMthUe1mIox0HyQxN2h/HjAd12e8K7HkG+n
         jtT+ruqR+yg58HtK4cTO8oIbLbFryNPgGFnrCakOPEROdEO9uQBSnSvVHox2T7nmBFwT
         01UCRmoZAvGlL29V/4HVIuT2t8uAODTAgsY3McyjPaSLZ9tMgvJ6Nkv/zcjMRqt5w9P7
         B1/8uCa2CMHgzH8w3709pEVHVNsfJz4P6Vun9L+Lx/O5wfcCnXrqx7+51LMdWhWQ2sbB
         lFzg==
Content-Disposition: inline
In-Reply-To: <1506002053-13380-1-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 21, 2017 at 09:54:13AM -0400, Waiman Long wrote:
...
> To allow reuse of the cgroup_mgctx structure, some fields in that
> structure are now re-initialized at the end of cgroup_migrate_execute()
> function call so that the structure can be reused again in a later
> iteration without causing problem.
> 
> This bug was introduced in the commit e595cd706982 ("group: track
> migration context in cgroup_mgctx") in 4.11. This commit moves the
> cgroup_taskset initialization out of cgroup_migrate(). The commit
> 10467270fb3 ("cgroup: don't call migration methods if there are no
> tasks to migrate") helped, but did not completely resolve the problem.
> 
> Fixes: e595cd706982bff0211e6fafe5a108421e747fbc ("group: track migration context in cgroup_mgctx")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.14-fixes.

Thanks, Waiman!

-- 
tejun
