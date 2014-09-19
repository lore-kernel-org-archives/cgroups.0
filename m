From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: remove CGRP_RELEASABLE flag
Date: Fri, 19 Sep 2014 09:30:15 -0400
Message-ID: <20140919133015.GB31015@mtj.dyndns.org>
References: <541BEE74.6020008@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=I26fAAHLwNZTrq56AQTCDugl8fhDWmACjXryKgDQAwc=;
        b=0UR/1UQJ3ZEffOHKGrnxg7Pq1MF0iHrUielgbsNILdQ9s3rYcW5f8x4wr5iWgwmORB
         e2TYVZ9V7J7opUS5tNkA4IIRJ20trEiJrzIlpJZWnD6/fi6sgNCGEtwwyWUc7npaP3/o
         toJBo6GUgA7l65q62BRZPSmCWQNKrL7hrhZ2Zia+6XMJzPt9NX7lYuJvXsDkhZnnA2GC
         Rma17PqkOCeO3JoBSgeHRYnuJZjcvEy4uI+v4goDUaBD2Nac73otq4ntoQEomZCfCTdk
         Gn5Irh5vCmyejvqE9sQ+kJYAles+lO93oDlOh9o5RkitjZa8dh7KUcZDi7vR6dso9IRU
         QJkA==
Content-Disposition: inline
In-Reply-To: <541BEE74.6020008-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 19, 2014 at 04:51:00PM +0800, Zefan Li wrote:
> We call put_css_set() after setting CGRP_RELEASABLE flag in
> cgroup_task_migrate(), but in other places we call it without setting
> the flag. I don't see the necessity of this flag.
> 
> Moreover once the flag is set, it will never be cleared, unless writing
> to the notify_on_release control file, so it can be quite confusing
> if we look at the output of debug.releasable.
> 
>   # mount -t cgroup -o debug xxx /cgroup
>   # mkdir /cgroup/child
>   # cat /cgroup/child/debug.releasable
>   0   <-- shows 0 though the cgroup is empty
>   # echo $$ > /cgroup/child/tasks
>   # cat /cgroup/child/debug.releasable
>   0
>   # echo $$ > /cgroup/tasks && echo $$ > /cgroup/child/tasks
>   # cat /proc/child/debug.releasable
>   1   <-- shows 1 though the cgroup is not empty
> 
> This patch removes the flag, and now debug.releasable shows if the
> cgroup is empty or not.
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
