From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v0 5/5] cgroup: Assign subsystem IDs during compile time
Date: Thu, 16 Aug 2012 16:20:10 -0700
Message-ID: <20120816232010.GJ24861@google.com>
References: <1345126336-20755-1-git-send-email-wagi@monom.org>
 <1345126336-20755-6-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ey8upHpqT36eRvR09meTBJPsXzCuU/9NPObzJFLdkIQ=;
        b=VY/PivFbmgQbni2BL2OD0wpSjeep5awPbhP/7+GwGfyz+eVRhZLU77va2ppRNCE4zC
         iHKU5Qeci0ddGrI+OqWHz+MGiW7B1J51zIGL9vSFGT8/uBZrM18NeWyzsp7EJaB/bgGN
         +bQOH+ebEYJMVjGckFYcnZeHP2x+Iy8TY1vYRVhzK2h1iAsuuuMohZLmYIh+E9ZmaQVe
         vF7WbsxxBWfK4NiCyzGTbovb5oo+aVHpPgs/En59gV7EP5wU6zxdGFt26VDaL7vZbZ2S
         YCQTp5oFZYyP38zCXYsOU+nUZx+SxeK2U8FcWCHJ+hZENdNtVD4+2S5/8ItJnYrxSMNl
         oXrw==
Content-Disposition: inline
In-Reply-To: <1345126336-20755-6-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Thu, Aug 16, 2012 at 04:12:16PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> 
> We are able to safe some space when we assign the subsystem
> IDs at compile time. Instead of allocating per cgroup
> cgroup->subsys[CGROUP_SUBSYS_COUNT] where CGROUP_SUBSYS_COUNT is
> always 64, we allocate 12 + 1 at max (at this point there are 12
> subsystem).

So, IIUC, this is effectively removing the capability to implement
modularized controller which isn't known at kernel compile time.  Am I
right?

I don't think that's a bad idea but if we're doing that, can't we make
things even simpler?  Do we need to distinguish in-kernel and module
at all?

Li, what do you think about this?

Thanks.

-- 
tejun
