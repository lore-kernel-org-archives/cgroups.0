From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Date: Wed, 24 Sep 2014 22:17:21 -0400
Message-ID: <20140925021721.GA5530@mtj.dyndns.org>
References: <54237281.5020308@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MOZnHXmqaP3AD0EJYdhW8Cf2YkDYz5AHuQVlDL+CjgA=;
        b=D37GqyU2+B5/qh8pq7vKmnHR1/TqZdwnXihFFIYlDPYA79Dbr0cNlnaXz+zvyBo5Fh
         x6g4dWS4dELZzJ5dWdqI7mmwwBJYAHmz43BWeFIP3/hmltoJnwLqkfRWiJQJXKhygbLb
         vzdVZd01WDv2eHNzORikc3agFKno3D+qKihjX7KkPmbwJPl01UQhhXFtFbncLbvuTLx6
         uC5lXYpZsYGURhHQnZm3g1Yqkfz8bFXfApJG7MlfyVzbXWQUJrY0bxMderk3xnqLXmyq
         5D5Sn3q6K/1hw+z6VAMbDFIh7ot259KX171UIOdPW6detdiq/i3o4wUdqYKZLKNYOAW1
         RsTw==
Content-Disposition: inline
In-Reply-To: <54237281.5020308-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Sep 25, 2014 at 09:40:17AM +0800, Zefan Li wrote:
> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
> because it is used as bit number. Redefine it as decimal bit number.
> 
> Note this changes the bit position of PFA_NOW_NEW_PRIVS from 1 to 0.
> 
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> [ lizf: slightly modified subject and changelog ]
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.17-fixes.

Thanks.

-- 
tejun
