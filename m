From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] memcg: extract memcg_vmstats from struct mem_cgroup
Date: Fri, 9 Sep 2022 02:26:40 +0200
Message-ID: <YxqIQOWzrsrPnff3@blackbook>
References: <20220907043537.3457014-1-shakeelb@google.com>
 <20220907043537.3457014-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662683202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oLbPE0Wn9MUv5iN+ZKgk87GvaSESM1SLfiGAHxsb7sE=;
        b=M74DCUqR4Zhu9qqowdIzC0yWGEoMxSvugFKMY6JydiDEwLYyXEwH+g1XQQml9JPnNg32Hz
        mbxmvw39Sc18R00K1lESxAGd+PBORN4d2sIqExz+Xv3FSi1hhzsEO6JM0hbam1jNxG//tS
        Ux5JGHlq845aLt0NMqCQKtgNo4wBibM=
Content-Disposition: inline
In-Reply-To: <20220907043537.3457014-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi.

On Wed, Sep 07, 2022 at 04:35:35AM +0000, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> This is a preparatory patch to reduce the memory overhead of memory
> cgroup. The struct memcg_vmstats is the largest object embedded into the
> struct mem_cgroup. 
> This patch extracts struct memcg_vmstats from struct
> mem_cgroup to ease the following patches in reducing the size of struct
> memcg_vmstats.

Is the reason for the extraction just moving things away from the header
file?
Or is the separate allocation+indirection somehow beneficial wrt, e.g.
fragmentation?

Thanks,
Michal
