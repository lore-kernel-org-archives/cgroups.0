From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.15] cgroup, sched: Move basic cpu stats from
 cgroup.stat to cpu.stat
Date: Thu, 26 Oct 2017 10:57:08 -0700
Message-ID: <20171026175708.GG59538@devbig577.frc2.facebook.com>
References: <20171023231827.GA8598@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UKQsvcpylqT7dIRWobDT6kn0mqB3MmQ9p66+FZP7dcI=;
        b=VGCOHPQ+r7z3eLgqNsztQxcjWDptDA04hqgVirGsu/11EP+QqKDZKSBg4E4v36dTvf
         8PoDZBAonQCOjDWGi0rjjECwLQaBBQ1kTzMUTHVCnOwMx8L0BysKiJuKBhfAOsLRcS4Z
         4ogX+VYyT59XGUeU4C5tqrVR2oLG+A4pQxAZznMiDFxz97Hh3pJ/S6cUaZj9CsugYF56
         5OqqKJ4927gZAFvIf33mozd5rtJHIBIsoXthUfLqm6uN7PtmpTIRiRB1BOFtdVrjeEYd
         gM95wp8tsQyyqNGHbLEFjyuIC+VltO7FLw9sv71BUIuy+HX1Zv5u3R+8JlhaOpoJ0VAa
         tUTQ==
Content-Disposition: inline
In-Reply-To: <20171023231827.GA8598-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Oct 23, 2017 at 04:18:27PM -0700, Tejun Heo wrote:
> The basic cpu stat is currently shown with "cpu." prefix in
> cgroup.stat, and the same information is duplicated in cpu.stat when
> cpu controller is enabled.  This is ugly and not very scalable as we
> want to expand the coverage of stat information which is always
> available.
> 
> This patch makes cgroup core always create "cpu.stat" file and show
> the basic cpu stat there and calls the cpu controller to show the
> extra stats when enabled.  This ensures that the same information
> isn't presented in multiple places and makes future expansion of basic
> stats easier.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-4.15.

Thanks.

-- 
tejun
