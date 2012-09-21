From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 12/13] execute the whole memcg freeing in rcu
 callback
Date: Fri, 21 Sep 2012 10:23:55 -0700
Message-ID: <20120921172355.GD7264@google.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-13-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YWxoAgqdSpyEjNNioRJtWyFzm0Q3J8XNh+oJmCEk73c=;
        b=NSQRct9OX244JRu5hpD5oiBfV0QMsU3VbPCdM+op5Q9qXQ5EmAV4iwnSvmit+dYogs
         h246un9nbDrWUNtsrL/+hVt4WRMxWxMBG+FD207aU+T5/PYNpGGBZOxgCtv8yXhMhTN5
         hQwOKy4uhfL5T/SYyzuhywC5+1FZJwNUiSi2LAoIFJYjdN626ijUwhdYJOh5Hb2UMad4
         +ROVuUM1krpaypiAtW9TH6fChmHUhYSZXTA9AkwJFFc2TXZeIqkuWMC7nplZSh4HENX4
         uYewlRxUH+eglWc7XWbybCVaTuveiGjoK5eDHgQAhkLMaKiwCW6jTa1FGZeX6U1MXNhm
         sUOw==
Content-Disposition: inline
In-Reply-To: <1347977050-29476-13-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Glauber.

On Tue, Sep 18, 2012 at 06:04:09PM +0400, Glauber Costa wrote:
> A lot of the initialization we do in mem_cgroup_create() is done with softirqs
> enabled. This include grabbing a css id, which holds &ss->id_lock->rlock, and
> the per-zone trees, which holds rtpz->lock->rlock. All of those signal to the
> lockdep mechanism that those locks can be used in SOFTIRQ-ON-W context. This
> means that the freeing of memcg structure must happen in a compatible context,
> otherwise we'll get a deadlock.

Lockdep requires lock to be softirq or irq safe iff the lock is
actually acquired from the said context.  Merely using a lock with bh
/ irq disabled doesn't signal that to lockdep; otherwise, we'll end up
with enormous number of spurious warnings.

> The reference counting mechanism we use allows the memcg structure to be freed
> later and outlive the actual memcg destruction from the filesystem. However, we
> have little, if any, means to guarantee in which context the last memcg_put
> will happen. The best we can do is test it and try to make sure no invalid
> context releases are happening. But as we add more code to memcg, the possible
> interactions grow in number and expose more ways to get context conflicts.
> 
> We already moved a part of the freeing to a worker thread to be context-safe
> for the static branches disabling. I see no reason not to do it for the whole
> freeing action. I consider this to be the safe choice.

And the above description too makes me scratch my head quite a bit.  I
can see what the patch is doing but can't understand the why.

* Why was it punting the freeing to workqueue anyway?  ISTR something
  about static_keys but my memory fails.  What changed?  Why don't we
  need it anymore?

* As for locking context, the above description seems a bit misleading
  to me.  Synchronization constructs involved there currently doesn't
  require softirq or irq safe context.  If that needs to change,
  that's fine but that's a completely different reason than given
  above.

Thanks.

-- 
tejun
