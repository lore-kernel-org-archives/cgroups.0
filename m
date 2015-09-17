From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Thu, 17 Sep 2015 11:52:45 -0400
Message-ID: <20150917155245.GF7205@mtj.duckdns.org>
References: <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org>
 <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org>
 <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
 <20150825210234.GE26785@mtj.duckdns.org>
 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
 <20150917143527.GJ3604@twins.programming.kicks-ass.net>
 <20150917151049.GB11639@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dqcDN+he7fEQD8H14k6EvTtStucoq3aEHAr/HkkdMaw=;
        b=yjvi5/PuWJBF4oyLjgXu7VYKzFjRHAUaUXRTNUAa6og/RrLzDm0W1kBI8uC+dyGHoq
         2X6lH2eS0CjPn3w6bCo6FMoyz9DtnQ8gf04hHlq3fUGMCwE2/xf63udT9ODPSXcEwEs0
         +FpnOtrlaCuwk0La1YC9mxK9wfPJ68CgdpZyAcX6Kot5JypL71KHntsP5QW1StK/xEUD
         2ZCsGLz0ERYbcqKrrLyB2dMrqdUHgfI/5MNJF4M+wLMXJyJlHD9B9QDHYjf8shu33Smz
         frsMI9iESBUVYb2c1xaref//k6Y+Qa6o6QfMaUCLjOWdc8KuOm6C+dWmKJMNlE3k8Git
         csmw==
Content-Disposition: inline
In-Reply-To: <20150917151049.GB11639-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Thu, Sep 17, 2015 at 05:10:49PM +0200, Peter Zijlstra wrote:
> Subject: sched: Refuse to unplug a CPU if this will violate user task affinity
> 
> Its bad policy to allow unplugging a CPU for which a user set explicit
> affinity, either strictly on this CPU or in case this was the last
> online CPU in its mask.
> 
> Either would end up forcing the thread on a random other CPU, violating
> the sys_sched_setaffinity() constraint.

Shouldn't this at least handle suspend differently?  Otherwise any
userland task would be able to block suspend.

> Disallow this by default; root might not be aware of all user
> affinities, but can negotiate and change affinities for all tasks.
>
> Provide a sysctl to go back to the old behaviour.

I don't think a sysctl is a good way to control this as that breaks
the invariant - all tasks always have some cpus online in its affinity
mask - which otherwise can be guaranteed.

If we wanna go this way, let's plesae start the discussion in a
separate thread with detailed explanation on implications of the
change.

Thanks.

-- 
tejun
