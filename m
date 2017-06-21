From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH-cgroup 2/6] cgroup: Enable bypass mode in cgroup v2
Date: Wed, 21 Jun 2017 17:17:01 -0400
Message-ID: <20170621211701.GB14720@htj.duckdns.org>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-3-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NpQsAUN5BV9aQZT+XiQqedHCMsDsRUS0/abYQ3KsO1Y=;
        b=qVnMFd0vcAeV1iahevs0jVI85bMdQ+Yg8rWIxpU33r5S/CWBZiYTU4ScV50zQcop6X
         6PA4EL72Iiy18qOru0Oqbq89tWvhhvBydxBlICFP2zxdvZi1jfi+FZDhD7EbTqdQaNTT
         AXkFkJ6ZHNjqRbWYQGux47HIwSP6cjNNrceB1ChUTCWRLOnMniJMaiSpS/lZrLjYJkAA
         C9E0RaVv8S3Vve8QdsKg0iuDUANWajc2fx8IwC17xHIkVu17zPWr/ZZNP8ZmWfxUTidT
         oExO22w7LLw/i3DWiG6wv65D0k5wWWhQdhxrvHq2eiHp4JCBrOtAsdReySzF93vj3sWr
         KPgA==
Content-Disposition: inline
In-Reply-To: <1497452737-11125-3-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello, Waiman.

Let's first talk about and make sense of high level semantics.

On Wed, Jun 14, 2017 at 11:05:33AM -0400, Waiman Long wrote:
> +In the example below, '+' corresponds to an enabled controller and
> +corresponds to a bypassed controller.
> +
> +   +   #   #   #   +
> +   A - B - C - D - E
> +         \ F
> +	   +
> +In this case, the effective hiearchy is:
> +
> +	A|B|C|D - E
> +	        \ F

I think that this definitely has potential.  While different
controllers may see differently abbreviated versions of the tree, they
can still be mapped to the same hierarchy and we can implement
cross-controller operations in a meaningful way, I think; however, it
does make some things really weird.

In the above example, how would A's resources be distributed.  Let's
say the resource knob in question is memory.high.  Because from memory
controller's point of view A|B|C|D are all bunched up and have E and F
as children, memory.high resource knobs on E and F would control how
A's memory gets distributed, right?

So, once a parent skips a controller with #, you can only determine
how its resources are actually distributed by scanning the entire
subtree to determine the span of '#' on the controller and any sort of
delegation - whether implicit or explicit - wouldn't be possible in
the middle, right?

Can you please think of / explain how this would work with delegation?
Making things clear with delegation is really helpful because it can
serve as the canary for the usual hierarchical operations.

Thanks.

-- 
tejun
