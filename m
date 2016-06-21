From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cgroup: Add pids controller event when fork fails
 because of pid limit
Date: Tue, 21 Jun 2016 13:28:32 -0400
Message-ID: <20160621172832.GM3262@mtj.duckdns.org>
References: <20160621163402.GI3262@mtj.duckdns.org>
 <1466528198-3416939-1-git-send-email-kennyyu@fb.com>
 <20160621171212.GL3262@mtj.duckdns.org>
 <9874B6F0-99B8-4739-B099-B7EEE99478F3@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EDfru7xIhzFQAWKMDGnL7OaMKROVNMnOD1zMG9uBdks=;
        b=q5Z0PCAC4zf/XlPfpmPosyR45tVIZDpul2ix7JpOeuQo/POCk0tGjBjJV6p/bo8e9U
         d1qUWJLzv2B4xfjS2uO5+Y4OBCP9fRKWE6fkHDxN0MCkhy/sQlgoF7dne8w6zF147fKT
         tl2LQBkRjsx/ChU6pMzk30AQNQfG7ccHD3lrOZdP0VglRoD+3kg/znX7VziHvMkFwk6m
         p7vWygy4etuMkqI42KqUg92jLDYXXzGcmI0QWlhZOEwNl+emPTahNmSkohtFn4iUL4Aw
         2kBicRqGzs9lnYa/mvDYD8wHg6bdXjXgVHtaTXitO1tMdRU9Mt9lqulq6og+pR3vdgyN
         jhbQ==
Content-Disposition: inline
In-Reply-To: <9874B6F0-99B8-4739-B099-B7EEE99478F3-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Cc: "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org" <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <Kernel-team-b10kYP2dOMg@public.gmane.org>

Hello,

On Tue, Jun 21, 2016 at 05:23:40PM +0000, Kenny Yu wrote:
> >It'd be better to use atomic64_inc_and_test() instead.
> >
> >	if (err) {
> >		if (atomic64_inc_and_test()) {
> >			pr_xxx...;
> >		}
> >		cgroup_file_notify(&pids->events_file);
> >	}
> >
> 
> According to the docs https://www.kernel.org/doc/Documentation/atomic_ops.txt ,
> it looks like atomic_inc_and_test returns "a boolean indicating whether the resulting
> counter value was zero or not", which will only happen when the counter goes from
> negative to 0. I'll keep it as atomic_inc_return and get rid of the temp variable.

Right you're.  Sorry about the confusion.  Yeah, that sounds good to
me.

Thanks!

-- 
tejun
