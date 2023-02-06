From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Mon, 6 Feb 2023 11:14:30 -1000
Message-ID: <Y+Fttp1ozejoSQzl@slm.duckdns.org>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EOmjkak4hSmRchvmEJgN6IqY5BTXXjlVuAkqhp03RaU=;
        b=Q5VBT+2LKQxS9wiyf3Xi/Hm7NsRvScNG1exKySJO4Dq2OSUmrEmfapxLhGvnAj+nzj
         lIs5CgcCVS5i90KKIQDoyqNgoIhyL/L16hvRw+RHgrv8d0OuvPx2RucHIaT6yM3eeI6c
         VodL4y1qwpNmToerzPOBpI9hUs9WPe9VxU0AY0n5FjEY5lqGxPNXDE8SVCw8TqAECtt0
         4Jwk2uo/SS/hCwspgO7ijlzCfuWtcM16cBVAqg8W72f7DguU3s5ZYlTBHALexjIcU+jV
         vHZv/KMeqeQiRVHoToYdVOBy2maKr2y4PsNiIcD8qcXTG1sC1F1l4/mm5VckTwB7eo9k
         dkUw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Feb 06, 2023 at 06:47:51PM +1100, Alistair Popple wrote:
> If too much memory in a system is pinned or locked it can lead to
> problems such as performance degradation or in the worst case
> out-of-memory errors as such memory cannot be moved or paged out.
> 
> In order to prevent users without CAP_IPC_LOCK from causing these
> issues the amount of memory that can be pinned is typically limited by
> RLIMIT_MEMLOCK. However this is inflexible as limits can't be shared
> between tasks and the enforcement of these limits is inconsistent
> between in-kernel users of pinned memory such as mlock() and device
> drivers which may also pin pages with pin_user_pages().
> 
> To allow for a single limit to be set introduce a cgroup controller
> which can be used to limit the number of pages being pinned by all
> tasks in the cgroup.

As I wrote before, I think this might fit better as a part of memcg than as
its own controller.

Thanks.

-- 
tejun
