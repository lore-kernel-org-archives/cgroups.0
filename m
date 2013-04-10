From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] perf, cgroup: implement hierarchy support for
 perf_event controller
Date: Wed, 10 Apr 2013 11:01:17 -0700
Message-ID: <20130410180117.GB17641@mtj.dyndns.org>
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
 <1365579146.30071.24.camel@laptop>
 <20130410093755.GC24443@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=opvaXWuPSo8sQQ5QJq7oiWY6CZ1biYFeK5jW9PSxtTU=;
        b=WjepJTJ8tPtQI3TeN3ap82RKe6F+b379QRSG9WI5cY05H9oIv1Uwa4PMTZygutOGAF
         9YY4KmzSMLhHteQ0LIvqEInCVb8Pj49RX3IL/ig0vJ5JO/Re5NWdNpdD2Z5cejsEnCDX
         aHjsa7qFwXN5Ty/zrl9FV3ICp3ON0F8i+LId4JW+/rAIvU3zzeRIOMBB4HZOh4D1YgUH
         MbZOXhDasztBEYN3Aub9K1sw4uz2/W95+Rc0MuQWBzl5LwwECOe8/KaT4/Qutnn5gtGg
         NBP/vfF/Akj73rg3MEiPG18tVNH8N2Xg1ZN9gH2oaVxUO0gUJWEJxSKcN1pSdAFPUs6R
         tlCA==
Content-Disposition: inline
In-Reply-To: <20130410093755.GC24443-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org, eranian-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, namhyung.kim-Hm3cg6mZ9cc@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Apr 10, 2013 at 11:37:55AM +0200, Ingo Molnar wrote:
> Yeah - at least for larger changes that's a good workflow.
> 
> For smaller changes we can pick one or the other tree. Tejun, do these changes 
> create any conflicts with the current tip:master tree? If not then you could carry 
> these changes in your tree. If there's significant conflicts then it might be 
> better to rebase this on top of perf/core and pull them into perf/core. (assuming 
> there's no other cgroups prereq patches beyond the ones in this series.)

The only conflict is a trivial #include one in
include/linux/res_counter.h which is unrelated to this series.  I'll
commit these to cgroup/for-3.10.

Thanks!

-- 
tejun
