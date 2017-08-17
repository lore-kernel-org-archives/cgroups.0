From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource
 accounting
Date: Thu, 17 Aug 2017 17:03:52 +0200
Message-ID: <20170817150352.mi2klerrjkrgf6ze@gmail.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170816185241.GF4087514@devbig577.frc2.facebook.com>
 <20170817081304.ebdeh56tonm5fjgt@gmail.com>
 <20170817130158.GB3238792@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CLvPTSqOmWX3L0qWIXJIDngVRYALf8ypCShWkcgyunA=;
        b=FZpoFnLeFl6zWAPGWgczn6YPoShsbIA2AMBsQLBX6zLnqDPLwgHDgMA5UWnkMLVQym
         DMW7TIB9IK+Iq7rBROHmI3ZJbdzw5NhvC2yHMOwmFF1zqysL6a02vvlBqGDKQhJZShWG
         4GD0B8MrLl3wlbcm0PIOnPj+B7jZ1DWtjafTJxclljjCNar6DtzQ/XRNSUlkMt6saz22
         dlh4PWcehThYCXX4XsOgjjyz1zThG84h7tm7iz0U23rYqxu4XsWexesTGJ4L6qKm/aaY
         HhHBYQKQxA6AGVMN84BHjzF6amo9hYux18LUYQxikfrE1DQ5gBELx3CLj4bjSNTv2utJ
         BTpA==
Content-Disposition: inline
In-Reply-To: <20170817130158.GB3238792-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org


* Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hello, Ingo.
> 
> On Thu, Aug 17, 2017 at 10:13:04AM +0200, Ingo Molnar wrote:
> > Please hold off on applying it before PeterZ gets back from vacation and has had a 
> > chance to review it.
> 
> Of course.  These aren't going anywhere without Peter's explicit acks.

Thank you!

	Ingo
