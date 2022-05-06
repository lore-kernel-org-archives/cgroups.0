From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Export memcg->watermark via sysfs for v2
 memcg
Date: Fri, 6 May 2022 07:56:18 -0700
Message-ID: <YnU3EuaWCKL5LZLy@cmpxchg.org>
References: <20220505121329.GA32827@us192.sjc.aristanetworks.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UMiJdnXRi9aL2AL9Vognq71+6oZgB61YztBopTVtQsI=;
        b=OQ7BK+mietcxdA+xGJIfTtOaowVb7K7X3AIK/p0uNueclD7Y7fS3s2OecMUE77qV1X
         c5lrVZcv3qzT9iXvcohzhZThbkkrY27rW1TYJFoKXU87Fxb1hBAfMPjp+DroOAMnb6nN
         +RfzBqhZFn1AVmUXUpoBS9Trkeaxg0rtJvWx8qbh3OrPmSLNw5vnbauJAcTj0z0MhCcG
         mbYIi4s4dytVvlg4zrOl3UEGEs6uXvVXQF4xq6kn4ruyxufmUY7+/P7yQuNSuYV6koW5
         B/kpsin/bvmMqHv6TwomKQg2J7PkZUjlJwogTKj2UXnpv+Dy9OYdeHM54qs9blfKuACF
         kiIQ==
Content-Disposition: inline
In-Reply-To: <20220505121329.GA32827-pF7uKtACKh3GmWBmRUYTj5O0Dwfk+90YVpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, May 05, 2022 at 05:13:30AM -0700, Ganesan Rajagopal wrote:
> v1 memcg exports memcg->watermark as "memory.mem_usage_in_bytes" in
> sysfs. This is missing for v2 memcg though "memory.current" is exported.
> There is no other easy way of getting this information in Linux.
> getrsuage() returns ru_maxrss but that's the max RSS of a single process
> instead of the aggregated max RSS of all the processes. Hence, expose
> memcg->watermark as "memory.watermark" for v2 memcg.
> 
> Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>

This wasn't initially added to cgroup2 because its usefulness is very
specific: it's (mostly) useless on limited cgroups, on long-running
cgroups, and on cgroups that are recycled for multiple jobs. And I
expect these categories apply to the majority of cgroup usecases.

However, for the situation where you want to measure the footprint of
a short-lived, unlimited one-off cgroup, there really is no good
alternative. And it's a legitimate usecase. It doesn't cost much to
maintain this info. So I think we should go ahead with this patch.

But please add a blurb to Documentation/admin-guide/cgroup-v2.rst.
