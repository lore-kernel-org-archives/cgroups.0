From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] sched, cgroup: reorganize threadgroup locking
Date: Thu, 14 May 2015 11:17:42 -0400
Message-ID: <20150514151742.GJ11388@htj.duckdns.org>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
 <1431549318-16756-2-git-send-email-tj@kernel.org>
 <20150514010913.GA4441@swordfish>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XyQ4j4pKrSQEgn3Urw1HEWUXeoioZUFkmssxJAUa3Aw=;
        b=m4YsbeyB+Qg0mbkYsPW+OSGtfZTcHZVfGHCL87FDjn9mnlprHCuhG88ltJE25FHtyg
         vs9CKYmwaAexp/vFPanr5a2F8JTKQKZlxaSXwQ7lF/lvp/fYrhI610lPiBRNsJ9jdQtQ
         MCM0Xj2LaOfC2wVyNXHq1KEsrTAHQldz1rY/codg65XHYsFny9740ggMwF8F5mfYVs2T
         MQwICqbWF3NhkZ/SWoMlsKHcNaFm5UbWgxMaE66+K3XjXL0JWE2RLki9/GReaIf0/idT
         lqUCa904LapUe/wSdshwM7wag5DTKGN5zPRPNE9Xlafj5zcBmzJXCfef4Yb441vYmJAL
         6RJA==
Content-Disposition: inline
In-Reply-To: <20150514010913.GA4441@swordfish>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Sergey.

On Thu, May 14, 2015 at 10:09:13AM +0900, Sergey Senozhatsky wrote:
> > +static inline void threadgroup_change_begin(struct task_struct *tsk)
> >  {
> > -	down_write(&tsk->signal->group_rwsem);
> > +	might_sleep();
> 
> I think cgroup_threadgroup_change_begin()->down_read() already does
> might_sleep() check.

Sure but it's a layering thing.  threadgroup_change_begin() should be
called from a blockable context whether the hook users actually make
use of it or not.  e.g. We want might_sleep() even when
!CONFIG_CGROUP.

Thanks.

-- 
tejun
