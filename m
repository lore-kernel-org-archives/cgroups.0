From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v4 15/16] memcg: enable accounting for tty-related objects
Date: Wed, 28 Apr 2021 09:38:03 +0200
Message-ID: <YIkQ232vjPzFittf@kroah.com>
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
 <e1446e9c-3878-f545-b33e-389d55bf1396@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619595486;
        bh=QBnMC6nBzJ7jyPXp0bvf8FizKe3kkFoosH+sK00xjf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IelduBmo8Z3egwJsjYkZqs/jOFjlgurmn6LjPrBRBFKU7Vy3L97eMta9CDfcaSOlo
         NMPhseosskZD/a38E8FYsfJeUfx6Dm4LWJPHpKMaqR+EiLmz8XZiwMzdiPEp/rZ33T
         Phenb4Jn/pCUyjFzMOyuFbhe3YdTbxqBjMXfsJ2s=
Content-Disposition: inline
In-Reply-To: <e1446e9c-3878-f545-b33e-389d55bf1396-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 28, 2021 at 09:54:16AM +0300, Vasily Averin wrote:
> At each login the user forces the kernel to create a new terminal and
> allocate up to ~1Kb memory for the tty-related structures.
> 
> By default it's allowed to create up to 4096 ptys with 1024 reserve for
> initial mount namespace only and the settings are controlled by host admin.
> 
> Though this default is not enough for hosters with thousands
> of containers per node. Host admin can be forced to increase it
> up to NR_UNIX98_PTY_MAX = 1<<20.
> 
> By default container is restricted by pty mount_opt.max = 1024,
> but admin inside container can change it via remount. As a result,
> one container can consume almost all allowed ptys
> and allocate up to 1Gb of unaccounted memory.
> 
> It is not enough per-se to trigger OOM on host, however anyway, it allows
> to significantly exceed the assigned memcg limit and leads to troubles
> on the over-committed node.
> 
> It makes sense to account for them to restrict the host's memory
> consumption from inside the memcg-limited container.
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
