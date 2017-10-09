From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v11 2/6] mm: implement mem_cgroup_scan_tasks() for the root
 memory cgroup
Date: Mon, 9 Oct 2017 14:11:07 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710091410550.59643@chino.kir.corp.google.com>
References: <20171005130454.5590-1-guro@fb.com> <20171005130454.5590-3-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=VsxMpHA1jSV0F9RgW6H4C90MJqXInY4B5nBmA20dCtM=;
        b=th8EgZ+C4U+SskTVfsQrXLQzL0WC/4cLR/IXnaE2xnnRy3He2/R27dhw3hJASIiMse
         Rj9W7/9rJgN5MruSYeKZwx4JgFwNMGpPy1Ph3LD1WMXe7rX6q2M2WrNbDlDhUvCoPx3V
         f7/F4vXxkkPzlGyZmN0S3oP0W+38ijn1IMmBT5SvAboktuwRKTJmMA4AgUz3XwLPfoCD
         HSsOf3zvfh63rMZdpFOuS9oLpfu+xaOUIGQnr9f2co9LkeSjBzco3GSEI/B1YrJD7Np4
         lwnp4vzBcAW5AYNk0L5cGFdTTeJIpX42n9vtBsJY/oa70oFsvpiKDrO8QbmOM6cWosRg
         vzJA==
In-Reply-To: <20171005130454.5590-3-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 5 Oct 2017, Roman Gushchin wrote:

> Implement mem_cgroup_scan_tasks() functionality for the root
> memory cgroup to use this function for looking for a OOM victim
> task in the root memory cgroup by the cgroup-ware OOM killer.
> 
> The root memory cgroup is treated as a leaf cgroup, so only tasks
> which are directly belonging to the root cgroup are iterated over.
> 
> This patch doesn't introduce any functional change as
> mem_cgroup_scan_tasks() is never called for the root memcg.
> This is preparatory work for the cgroup-aware OOM killer,
> which will use this function to iterate over tasks belonging
> to the root memcg.
> 
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
