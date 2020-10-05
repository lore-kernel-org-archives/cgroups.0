From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH RFC v2] Opportunistic memory reclaim
Date: Mon, 5 Oct 2020 12:25:55 +0100
Message-ID: <20201005112555.GA108347@chrisdown.name>
References: <20201005081313.732745-1-andrea.righi@canonical.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dPmPVQgoIn6sm4yJEL6Gt5bZe3D8XUPMyhu5lemsH1w=;
        b=JosLptL0NIYq+WTt2D0GcnMU8aGMTGaKjauLfSJh/SVg8Fre3RjwOL+f/2Qg5zcYBt
         yycq3AmSW1jW+/cKoAFeJBtiQ2pPJYKD7TsXrW+AvAeW/VThIIijdDj3eD7cuBZOKPpE
         FEeXT4yrqri3+HgiZxDuKbeQZwMpctrogyfI4=
Content-Disposition: inline
In-Reply-To: <20201005081313.732745-1-andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Andrea Righi <andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Luigi Semenzato <semenzato-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Rafael J . Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Andrea Righi writes:
>This feature has been successfully used to improve hibernation time of
>cloud computing instances.
>
>Certain cloud providers allow to run "spot instances": low-priority
>instances that run when there are spare resources available and can be
>stopped at any time to prioritize other more privileged instances [2].
>
>Hibernation can be used to stop these low-priority instances nicely,
>rather than losing state when the instance is shut down. Being able to
>quickly stop low-priority instances can be critical to provide a better
>quality of service in the overall cloud infrastructure [1].
>
>The main bottleneck of hibernation is represented by the I/O generated
>to write all the main memory (hibernation image) to a persistent
>storage.
>
>Opportunistic memory reclaimed can be used to reduce the size of the
>hibernation image in advance, for example if the system is idle for a
>certain amount of time, so if an hibernation request happens, the kernel
>has already saved most of the memory to the swap device (caches have
>been dropped, etc.) and hibernation can complete quickly.

Hmm, why does this need to be implemented in kernelspace? We already have 
userspace shrinkers using memory pressure information as part of PID control 
already (eg. senpai). Using memory.high and pressure information looks a lot 
easier to reason about than having to choose an absolute number ahead of time 
and hoping it works.
