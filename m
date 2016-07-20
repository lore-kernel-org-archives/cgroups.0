From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Wed, 20 Jul 2016 11:51:47 -0400
Message-ID: <20160720155147.GG4574@htj.duckdns.org>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/eDcMA2cq4TuXRjGcbnWhY1M8C7zfAI9cPgjU0B7bzA=;
        b=GCz8xT2+AeKilK7aPKEo+Cp0lEGDfasCg+I3XCqbJkSiTTqMHrtM5fuTn3Dc6W+R86
         Zx7pgOucaYO5cRZiO8Bv51etRfe+v1sutB/1n6FEfaXtw+S/MDCi2C4hrmky0UumDaUu
         Cb3LpH7qQPWp1EBeydFg5h9zppEYfwgLUeay+Wiy08kmAewFTLnptZet122B1jxOTO/2
         kLxmpOxYhQFX5WujufEEpKj9ltttQ6Rt3sCP+CMTnlVtXPvzbzKzm2mV2jCpQq26OXjZ
         NS/cWHZP3IMO0lyj7dXzzEU7p4m4rTO1ounRhKanUaXx5xU1zi//YLvPHUjmmIKmvhg0
         jiqA==
Content-Disposition: inline
In-Reply-To: <20160718161816.13040-4-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

Hello, Aleksa.

On Tue, Jul 19, 2016 at 02:18:16AM +1000, Aleksa Sarai wrote:
> If we're moving from a parent to a direct descendant, the only end
> result (on cgroupv2 hierarchies) is that the process experiences more
> restrictive resource limits. Thus, there's no reason to restrict
> processes from moving to direct descendants based on whether or not they
> have cgroup.procs write access to their current cgroup.
> 
> This is important for unprivileged subtree management, as it allows
> unprivileged processes to move to their newly create subtrees.

I don't think we can do this as this allows a sub-cgroup to steal an
ancestor's process whether the ancestor likes it or not.  A process
being put in a context where it's more restricted without whatever is
managing that part of cgroup hierarchy is not ok, at all.  Please also
note that nobody expects its processes to be stolen underneath it.
This would be a management nightmare.

Thanks.

-- 
tejun
