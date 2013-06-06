From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 08/11] sched: Push put_prev_task() into
 pick_next_task()
Date: Thu, 6 Jun 2013 16:56:47 -0700
Message-ID: <20130606235647.GR5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-9-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=8/BIZXSjJwYNKT59eTRu4tPUi57V++YqK7aORBXNfAo=;
        b=Hyx0IA14yRzGhaHiMLkygSIsL7XOA9iiA+QmXxnMxda+NKmIuTz7QJz0cnvyUtiXv2
         0HuGJY3S0Mfzk6nE1kjAvyTNGvrDcREzC4W723Pm3lQh0HHxN/0P24lwlCkNT7AzSFuD
         hwBYScxseHcdPKi4cdW52vZydq2ViercAt98zZTKpQgTz51N1jAKG0gi/6/XIA6ta8k9
         B67p20UhG4zZLe/f2IwTw/FIWeHigWvaqZ5GFGsFCflquV/zL+Diqr5CUPlQvhkOeKNW
         Z1hKkAUvpFz3MisxD8kEe4kMh6y/0hl8V2qcaFprfBhAZj2Vjqx0cni5dXmHyACVY2cO
         6YUw==
Content-Disposition: inline
In-Reply-To: <1369825402-31046-9-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed, May 29, 2013 at 03:03:19PM +0400, Glauber Costa wrote:
> From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> 
> In order to avoid having to do put/set on a whole cgroup hierarchy
> when we context switch, push the put into pick_next_task() so that
> both operations are in the same function. Further changes then allow
> us to possibly optimize away redundant work.

I suppose this is to optimize out css_put/get() if the previous and
next tasks are in the same group?  css refcnt will soon (this week) be
converted to percpu reference counter, so the optimization might not
be as meaningful unless there are other things which are being
optimized.

Thanks.

-- 
tejun
