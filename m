From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [patch] mm, memcg: provide a stat to describe reclaimable memory
Date: Wed, 15 Jul 2020 14:10:48 +0100
Message-ID: <20200715131048.GA176092@chrisdown.name>
References: <alpine.DEB.2.23.453.2007142018150.2667860@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vkCY6kDWjByVF/jAwqrMxG8bXNVZTl6QD0EIHDVYVvg=;
        b=T5LhLO42jFeK8otjiZMlFd/9dTVrSG8T1SXlUDpXXePwRFiDaTChrtR6/5AL6KIw+w
         ALeafWne74XeJ2cUm9BH8jJSRMagzJn/pbb+aT1MdoID6XNOyc+4V0p63UKIS2c9IKC5
         cVuDvv+F2sZfzwkL5EzZEvsqqahRgwwtZYias=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2007142018150.2667860-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi David,

I'm somewhat against adding more metrics which try to approximate availability 
of memory when we already know it not to generally manifest very well in 
practice, especially since this *is* calculable by userspace (albeit with some 
knowledge of mm internals). Users and applications often vastly overestimate 
the reliability of these metrics, especially since they heavily depend on 
transient page states and whatever reclaim efficacy happens to be achieved at 
the time there is demand.

What do you intend to do with these metrics and how do you envisage other users 
should use them? Is it not possible to rework the strategy to use pressure 
information and/or workingset pressurisation instead?

Thanks,

Chris
