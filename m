From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 5/9] sched/psi: don't create cgroup PSI files when
 psi_disabled
Date: Mon, 25 Jul 2022 12:41:31 -0400
Message-ID: <Yt7Hu141PirDh/pw@cmpxchg.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-6-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v0Fv+XIjssvZKgFM5LQcb8oFSEVF6SdtJS8HXkaCGG0=;
        b=3QxjhGAUDPV3GRaFaoJVT9T+OOXNTZ13AG3KfIqthhNKATudxFjJHRZqCYOcuJtIK0
         RFbJelGraAA7ADvrFcTvoACcPEmPO9FHdXoZ8scMvZ8Py8hJjbUAcm3mrHZG2a+8dfiu
         jJz3k9uorP5zoWG0g9A1yrNwZjfRedzU3BbJtPZQy11Ts4/OnsNOyxJfizhK/cSQsr1W
         dhxkuga64cCsmfd+mdYtgYPikV83NIg0g+yxgnVHXe6T3jDOUIlyWm/irCW4nWCcsXY0
         fG5mlS4HNpuKW4RgHgsxzBFfLfZn5aWfNFilSvvdsrIe8toMNQLojl9mc2J6c2NUYEOI
         IXKg==
Content-Disposition: inline
In-Reply-To: <20220721040439.2651-6-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 21, 2022 at 12:04:35PM +0800, Chengming Zhou wrote:
> commit 3958e2d0c34e ("cgroup: make per-cgroup pressure stall tracking configurable")
> make PSI can be configured to skip per-cgroup stall accounting. And
> doesn't expose PSI files in cgroup hierarchy.
> 
> This patch do the same thing when psi_disabled.
> 
> Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
