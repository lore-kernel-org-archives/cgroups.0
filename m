From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 00/11] per-cgroup cpu-stat
Date: Wed, 5 Jun 2013 18:49:29 -0700
Message-ID: <20130606014929.GS10693@mtj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6TU4RxohXZenHyQtslBd3IR998OovXGQwOffKbCBjdc=;
        b=g1NLNCQSn9+fkctj5whN6vVa3tWyBUdAEfC6IWICW3pZS2Tv+M6GNo8C2zS2dttL1C
         tmn6ck1Ncv1zi2JU+aLf3DyqPErEoit6R45Zd8VtaHoxpt77AAz2QsJRaK5im0MRqM5a
         JmmFAIst6dR0U/dpkjuHj/gYtL3lemsWgmsQIsQarHqyZ2sEv80S4K7HJwcMxUePaOF/
         /S54Svlj8UcNGLPlhZYg2fypUT0fge0NLOzweEFRy6V2Dq4mJHiMxNjhqCw0UeDBx3QF
         NC4OeAWG6YjQbu5KkpVW7oTAnLd6OqD/VJ0mTqIwDkq4D9RxLaOM3P4g9cDUX32xv3hV
         KkgA==
Content-Disposition: inline
In-Reply-To: <1369825402-31046-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Hello, Glauber.

On Wed, May 29, 2013 at 03:03:11PM +0400, Glauber Costa wrote:
> I am *not* going as far as marking cpuacct deprecated, because I think it
> deserves a special discussion (even though my position in this matter is widely
> known), but all the infrastructure to make it happen is here. But after this,
> it should be a matter of setting a flag (or not).

I'll ensure that cpuacct can't be used with sane_behavior from cgroup
core side, so that it can be deprecated with multiple hierarchies
eventually.

> Through this patchset I am making cpu cgroup provide the same functionality of
> cpuacct, and now with a more clear semantics, I attempt to provide userspace
> with enough information to reconstruct per-container version of files like
> "/proc/stat". In particular, we are interested in knowing the per-cgroup slices
> of user time, system time, wait time, number of processes, and a variety of
> statistics.
> 
> To make sure we can count nr of switches correctly, I am ressurecting one of
> Peter's patches that apparently got nowhere in the past.

I generally agree with the approach but which tree is it based on?
Can you please let me know the base commit so that I can review the
series properly?

Thanks.

-- 
tejun
