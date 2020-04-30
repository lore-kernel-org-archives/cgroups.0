From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Thu, 30 Apr 2020 15:30:49 -0400
Message-ID: <20200430193049.GB2436@cmpxchg.org>
References: <20200430182712.237526-1-shakeelb@google.com>
 <20200430190610.GD339283@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d1RAIbvoo2s7JffYGXt74NgzLodAkoT3ooI15LWHF58=;
        b=vzffAZXtvSvTwq5dKjdHWx63DCplLMxMCM5nmf/g/K/RG0YfleeYDmRvgKuHb4ZBAd
         w2YgrTnrZz0xNEdHNQvnr7Rr9/lSsOBtgCIVzJqTwCkFrrJTKZfScnqXAh9N/HKrOH5p
         KDqWBDqRw8t0gcyIWMhcT6dVIVWd5hyJ0rx8dtXwXNRdAbkhSU9h1IjLTpcwxaWWEZ2W
         j4Zq1oNj1y0SZjQ8iuchSaNHjfge8ycZcukkuoKnOhqvm6D39kHQPGmFg2cEjgxGWAI0
         hvKc8DOcxkrD73j0wcVJDnqYPs/j7QqmM26IJdQVHb4T3TCVOqF6M9Jzr4l4JQqJO4lb
         SgXw==
Content-Disposition: inline
In-Reply-To: <20200430190610.GD339283-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 30, 2020 at 12:06:10PM -0700, Roman Gushchin wrote:
> On Thu, Apr 30, 2020 at 11:27:12AM -0700, Shakeel Butt wrote:
> > @@ -6106,7 +6107,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
> >  		}
> >  
> >  		memcg_memory_event(memcg, MEMCG_OOM);
> > -		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
> > +		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0, true))
> 
> I wonder if we can handle it automatically from the oom_killer side?
> We can suppress warnings if oc->memcg is set and the cgroup scanning
> showed that there are no belonging processes?

Note that we do remote charging for certain consumers, where memory
gets charged from the outside of the cgroup.

We would want to know if these cause OOMs on an empty cgroup, rather
than force-charge the allocations quietly.
