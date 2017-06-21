From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH-cgroup 5/6] cgroup: Skip dying css in
 cgroup_apply_control_{enable,disable}
Date: Wed, 21 Jun 2017 18:04:38 -0400
Message-ID: <20170621220438.GB18600@htj.duckdns.org>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-6-git-send-email-longman@redhat.com>
 <20170621214216.GE14720@htj.duckdns.org>
 <81c62822-8bb6-ae68-112a-dad49414e3f1@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hdNaDUhRy38d7g69n77EmT5diJ/zh3aVBK6OeDO5VNk=;
        b=D9OFdnzViCJdFH9ptw9DO+tZnSUTEc36djp8An7UIUOAuGFjnhFBmgZIZiXdN4WLV6
         vZVQbILN53kh540vKqyf7zhFQ7Y9vZScUnFBUqKx3KGV0vjIz+yXyluifMV2ErbmAqq4
         uDyNhUBZp/aRFmgcyLl4j0GheH0PeanXR/tQgLRHZKGMcDJ+1BsGBIh/RHeKiFFsdmwm
         iolbqRVVMuaaUNVrPtLCtuS5V5Od/+r9kSLwOKdPj3GK7LQZ6SLflfFQ6uMahmPOkbjx
         A5VjYm+dI4GkSrW0MwK5m9DroKX6ysb9cJ5xc12RdbiA/YMsHUgr969YFAC4pbiPatzT
         BzSA==
Content-Disposition: inline
In-Reply-To: <81c62822-8bb6-ae68-112a-dad49414e3f1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello,

On Wed, Jun 21, 2017 at 06:01:56PM -0400, Waiman Long wrote:
> I do think that it can happen with existing code because CSS killing is
> asynchronous, I think. So the command can complete before the CSS is
> actually gone. If the next command to reactivate it happens fast enough,
> we can trigger that. When I added more checking to my test script
> essentially increasing the latency between successive tests, I couldn't
> trigger it anymore.

While disabling is asynchronous, there's a flushing logic before
starting reenabling things, so the existing code shouldn't trigger
that condition.  But then there's should and the reality. :)

Thanks.

-- 
tejun
