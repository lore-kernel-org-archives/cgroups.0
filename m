From: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup: remove redundant get/put of task struct
Date: Tue, 20 Dec 2011 16:04:18 -0800
Message-ID: <20111221000418.GY13529@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-3-git-send-email-msb@chromium.org>
 <20111220232326.GL10752@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        bh=LOgGkFTAyGjghM1rzCYynl4paFn+I5fmEH4YRYsSel0=;
        b=wXLGSEHG55ceu16OvoBHC2Ac1p5bPVH0CfRrWKpZXf4K0omkbKmNWtCWftLpu/L0hy
         XD/4y4QBjEEjOIdw3/xg==
Content-Disposition: inline
In-Reply-To: <20111220232326.GL10752-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:
> Hello,
> 
> On Tue, Dec 20, 2011 at 03:14:30PM -0800, Mandeep Singh Baines wrote:
> > @@ -2287,14 +2280,12 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
> >  			cgroup_unlock();
> >  			return -EACCES;
> >  		}
> > -		get_task_struct(tsk);
> >  		rcu_read_unlock();
> 
> This is before threadgroup is locked.  What guarantees @tsk doesn't go
> away once rcu is unlocked?
> 

Nothing. D'oh. I'll remove the changes to attach_task_by_id and leave
the others.

> Thanks.
> 
> -- 
> tejun
