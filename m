From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: make sure a parent css isn't offlined before
 its children
Date: Thu, 21 Jan 2016 16:28:12 -0500
Message-ID: <20160121212812.GJ5157@mtj.duckdns.org>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org>
 <5698A023.9070703@de.ibm.com>
 <20160121203111.GF5157@mtj.duckdns.org>
 <20160121212416.GL6357@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lJGPIZrtkKGHuPdubS321hfKq14YyuNuOd7U+nx70KU=;
        b=KjPL+nQXXK7xez5lvpunvybWLpy98bKSZduwI9G2rFIK2v0rvBt/MI+nJ9tX5oNEbb
         4QzVOHFxpyjdZUnkvQgNFZYfHnHJFa2BofGQfQXvyv1cVIhe7eLWD4X2zwwHLSdt/QUG
         XDVVnDOo6M0mFGNpgvM0/WkHosCRzYoXQCbgN3MHbB7ZT4cdPOyWm9ZIiTIP2/QPA2i4
         SOfjto2BVweMBFXRSXFvGV1cg3Gi+k0MiE/s+oskpCVMQaAClpuXZwNs5xahki7qxQkO
         WubBeHADUaE7cO7QlSvhw6oY8zWHzlJHCmzKm9qtuzX1rGTz+3v3sNiRS7hYTxkTzStM
         j4Xg==
Content-Disposition: inline
In-Reply-To: <20160121212416.GL6357-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Jan 21, 2016 at 10:24:16PM +0100, Peter Zijlstra wrote:
> On Thu, Jan 21, 2016 at 03:31:11PM -0500, Tejun Heo wrote:
> > There are three subsystem callbacks in css shutdown path -
> > css_offline(), css_released() and css_free().  Except for
> > css_released(), cgroup core didn't use to guarantee the order of
> > invocation.  css_offline() or css_free() could be called on a parent
> > css before its children.  This behavior is unexpected and led to
> > use-after-free in cpu controller.
> > 
> > This patch updates offline path so that a parent css is never offlined
> > before its children.  Each css keeps online_cnt which reaches zero iff
> > itself and all its children are offline and offline_css() is invoked
> > only after online_cnt reaches zero.
> > 
> > This fixes the reported cpu controller malfunction.  The next patch
> > will update css_free() handling.
> 
> No, I need to fix the cpu controller too, because the offending code
> sits off of css_free() (the next patch), but also does a call_rcu() in
> between, which also doesn't guarantee order.

Ah, I see.  Christian, can you please apply all three patches and see
whether the problem gets fixed?  Once verified, I'll update the patch
description and repost.

Thanks.

-- 
tejun
