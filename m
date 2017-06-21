From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH-cgroup 1/6] cgroup: Relax the no internal process
 constraint
Date: Wed, 21 Jun 2017 17:39:05 -0400
Message-ID: <20170621213905.GD14720@htj.duckdns.org>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-2-git-send-email-longman@redhat.com>
 <20170621204050.GA14720@htj.duckdns.org>
 <0c752151-f4aa-cda0-ba36-77cdc7dc25c6@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rR9rkN4WUhokwWZwOoaQEppL2XwIaDPl0+upfTO9j3M=;
        b=AZMPfEOJAFOHmz4XFAoo5GoPtxBQoJC4/RVfAGKjhKvKXpPbYvfwT/tBjCL4gs7eE8
         DHZOXx+mNU2hHHIIu4wcsuFWZuC0eQnnMi9ICewirrL49VSrqZqpQNAPH8klXdGL+GrL
         GdsHTMcsR3OPJEChvJHF1l8aWlXwb1Q7Dxxx9Wfvi2g+jaJQtTAjZRSl1PUr3OuYc7iN
         0jD/M4DMJNL4QrR5Ph6HZUZsk5dqimTVGp8QmN66drAKFbFsIktdcnHb9vN17t5DbO02
         iyoo2zIeGzOISK7Ujf3km0qXZoWT7F01dv4NWEYHFHjnQU7TKw6+7hJOvDV7nPOjI4ki
         pnxQ==
Content-Disposition: inline
In-Reply-To: <0c752151-f4aa-cda0-ba36-77cdc7dc25c6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello,

On Wed, Jun 21, 2017 at 05:37:00PM -0400, Waiman Long wrote:
> > What happens when we add domain handling to CPU so that it is both a
> > domain and resource controller?  Even if that somehow can be resolved,
> > wouldn't that come with a rather surprising userland behavior changes?
> > Also, I'm not sure what we're achieving by doing this.  It doesn't
> > really relax the restriction.  It just turns it off implicitly when
> > certain conditions are met, which doesn't really allow any real
> > capabilities and at least to me the behaviors feel more subtle and
> > complicated than before.
> 
> I think CPU isn't a good example for that.

Can you please elaborate?

> Another alternative is to treat no internal process as a controller
> attribute. Then we don't need to worry about this intricate question and
> let the  controllers decide if they will allow internal processes.

Isn't that what "threaded" is?

Thanks.

-- 
tejun
