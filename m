From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH RFC v2] Opportunistic memory reclaim
Date: Mon, 5 Oct 2020 15:46:12 +0100
Message-ID: <20201005144612.GB108347@chrisdown.name>
References: <20201005081313.732745-1-andrea.righi@canonical.com>
 <20201005112555.GA108347@chrisdown.name>
 <20201005135130.GA850459@xps-13-7390>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bJDWLFQK3NHbczue04Ad/oGIga5mw5RnC9F1EX3+XdE=;
        b=hl2motqvUtv+mvTksLda5r+AFkPsIl17oAkAoCpovuZwVAOmI4uF6k4X0hrbeu5UIV
         4L63H25KQUKF8MNUkLWt/WneZgSx81pfLMMNxbhsI9ViwK7Q3zswPYsHmCMJd7yWREPt
         5ZNnY8RT6kVH5ja7Img8nnNnLSz+y+pOeFYeo=
Content-Disposition: inline
In-Reply-To: <20201005135130.GA850459@xps-13-7390>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Andrea Righi <andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Luigi Semenzato <semenzato-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Rafael J . Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Andrea Righi writes:
>senpai is focused at estimating the ideal memory requirements without
>affecting performance. And this covers the use case about reducing
>memory footprint.
>
>In my specific use-case (hibernation) I would let the system use as much
>memory as possible if it's doing any activity (reclaiming memory only
>when the kernel decides that it needs to reclaim memory) and apply a
>more aggressive memory reclaiming policy when the system is mostly idle.

 From this description, I don't see any reason why it needs to be implemented in 
kernel space. All of that information is available to userspace, and all of the 
knobs are there.

As it is I'm afraid of the "only when the system is mostly idle" comment, 
because it's usually after such periods that applications need to do large 
retrievals, and now they're going to be in slowpath (eg. periodic jobs).

Such tradeoffs for a specific situation might be fine in userspace as a 
distribution maintainer, but codifying them in the kernel seems premature to 
me, especially for a knob which we will have to maintain forever onwards.

>I could probably implement this behavior adjusting memory.high
>dynamically, like senpai, but I'm worried about potential sudden large
>allocations that may require to respond faster at increasing
>memory.high. I think the user-space triggered memory reclaim approach is
>a safer solution from this perspective.

Have you seen Shakeel's recent "per-memcg reclaim interface" patches? I suspect 
they may help you there.
