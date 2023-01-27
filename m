From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Fri, 27 Jan 2023 11:44:19 -1000
Message-ID: <Y9RFs+90TyzVMs83@slm.duckdns.org>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <183372b80aac73e640d9f5ac3c742d505fc6c1f2.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IGyEe5r+NojLRSHukODHgweo3795xTuuhhKFb1p2rKo=;
        b=VVClLmEPsUs9mjKaayyyC5mh2eOFGjtp5LxcHfc7P9UlzPULKquyQZuXhdzBYjWskB
         cY+T8fXqgz2lgHkfuFYTZGXNLG8iTep3xXcGfGIQWrWDHFeT1iGMNzYJ79a7sLcFfgBj
         PHB9PbYr2Yi05ss+681fc7wf/O4e6J3vd4JedzmNXg00rXoD7/BGx25KLKKfzZb+35lR
         naDMMn14bOioHB5fz0Oic1JdIiO8eo99pOipmiC3OwSEhuAl8GzaAUemQpMQovnJ7YQ8
         S9hYzb1loWgT/dkcLt79/yjOfmkoPN42XN21dnWzctMUvZbbN9jpn95JVynnO1jQmvM6
         pT8g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <183372b80aac73e640d9f5ac3c742d505fc6c1f2.1674538665.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Jan 24, 2023 at 04:42:43PM +1100, Alistair Popple wrote:
> If too much memory in a system is pinned or locked it can lead to
> problems such as performance degredation or in the worst case
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

The use case makes some sense to me but I wonder whether this'd fit a lot
better in memcg rather than being its own controller.

Thanks.

-- 
tejun
