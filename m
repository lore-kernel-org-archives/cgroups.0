From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/8] mm: memcontrol: switch to rstat v2
Date: Fri, 5 Feb 2021 22:58:09 -0500
Message-ID: <YB4T0eX3XDiLPNI1@mtj.duckdns.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BOfhpI6Pct7YOvRYywamiqV90GYlguNDYCZVZfdMFF4=;
        b=ijefe/7VuijxV7fXltuMQCv2CDhZQmJb4GneqOJpBl03bFpQ9R7lm3ZJn2qvYC3egj
         JtayyTyxDBGm3+RUiEWCUhdEJoY14xs59Q0n+zDOpAJ5m2SDDFbtfzPkFCPD4c4zm5dm
         H9A8GxySd9zaO16fTZM6YGk2nIU5HSdfU8T15TZRVJ+0gAtd747GNaTGJOYiTe160uB6
         7J59DJnEIE74SZsWMQWBL8l4pW8wS/CZ+GDUblW8tX72x97QV9QcbEs9Y2INsOnM/rM6
         81dlxRd9+nXqNLk9taTp/JsBueaXBVFEDg4WjvMd6nxce0aiRvurouTa243dlx4OJI6j
         pexA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210205182806.17220-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Feb 05, 2021 at 01:27:58PM -0500, Johannes Weiner wrote:
> This is version 2 of the memcg rstat patches. Updates since v1:
> 
> - added cgroup selftest output (see test section below) (thanks Roman)
> - updated cgroup selftest to match new kernel implementation
> - added Fixes: tag to 'mm: memcontrol: fix cpuhotplug statistics flushing' (Shakeel)
> - collected review & ack tags
> - added rstat overview to 'mm: memcontrol: switch to rstat' changelog (Michal)
> - simplified memcg_flush_lruvec_page_state() and removed cpu==-1 case (Michal)

The whole series looks good to me. Please feel free to route the rstat
patches with the rest of the series.

Thanks.

-- 
tejun
