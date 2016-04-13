From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Wed, 13 Apr 2016 14:33:09 -0400
Message-ID: <20160413183309.GG3676@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X0B0EyVP6kwV9GajOUUCEPz0biCVTVPIAx3UgpZre0c=;
        b=eQPy05xPP/sq1JY0ZWQc5ERbnjL6+XN44UXTaMWIMNx/CeT+tmnGv0O4ncvzAIylf9
         rr4OczUE005kyeoQMQ1Tj0SLksM6+UvclDt4kOd9F7j7CrCV0sFkaJe5OHveI+axfjZh
         9raDCObcY9trVPN+96FcimQQr/BdOl8eLIvRshfCzvYpn1q3bJ2m3W5PK/M1g+a4yZC5
         HkWBCqC9VsIM3pwrLmEMorqXzUqIF3c5VeTPskVp6H+g44T63P5rpEng++aAPGUXDgDA
         XN7aKW94WoDQ9oOgBRPs1rE+EDiolh7zjdvCpi4SKmzTzs0OcdQP1QcUjOJx9uDMnpFj
         Cy3Q==
Content-Disposition: inline
In-Reply-To: <20160413094216.GC5774-KsEp0d+Q8qECVLCxKZUutA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Petr.

(cc'ing Johannes)

On Wed, Apr 13, 2016 at 11:42:16AM +0200, Petr Mladek wrote:
...
> By other words, "memcg_move_char/2860" flushes a work. But it cannot
> get flushed because one worker is blocked and another one could not
> get created. All these operations are blocked by the very same
> "memcg_move_char/2860".
> 
> Note that also "systemd/1" is waiting for "cgroup_mutex" in
> proc_cgroup_show(). But it seems that it is not in the main
> cycle causing the deadlock.
> 
> I am able to reproduce this problem quite easily (within few minutes).
> There are often even more tasks waiting for the cgroups-related locks
> but they are not causing the deadlock.
> 
> 
> The question is how to solve this problem. I see several possibilities:
> 
>   + avoid using workqueues in lru_add_drain_all()
> 
>   + make lru_add_drain_all() killable and restartable
> 
>   + do not block fork() when lru_add_drain_all() is running,
>     e.g. using some lazy techniques like RCU, workqueues
> 
>   + at least do not block fork of workers; AFAIK, they have a limited
>      cgroups usage anyway because they are marked with PF_NO_SETAFFINITY
> 
> 
> I am willing to test any potential fix or even work on the fix.
> But I do not have that big insight into the problem, so I would
> need some pointers.

An easy solution would be to make lru_add_drain_all() use a
WQ_MEM_RECLAIM workqueue.  A better way would be making charge moving
asynchronous similar to cpuset node migration but I don't know whether
that's realistic.  Will prep a patch to add a rescuer to
lru_add_drain_all().

Thanks.

-- 
tejun
