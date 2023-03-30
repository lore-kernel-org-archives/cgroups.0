From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 7/9] workingset: memcg: sleep when flushing stats in
 workingset_refault()
Date: Thu, 30 Mar 2023 09:39:34 +0200
Message-ID: <ZCU8tjqzg8cDbobQ@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-8-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680161975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g18B/GLg5ItJpD8zvJQQFzAO1axtsluF41GXm3XAUWQ=;
        b=ET0uIz8SFpap4Z0OGPb9kwXXtyHW/o/NGozAbd+0d3gbFzcP0A1LuFuJJJfq/l87AkaSbV
        PgKMOzdr17x6a4N6mNu8/3S0yq7fyz8szN2RSGvlRHH+6oHlgPx7hTfNDt5u9aESoovany
        8D/iM3t2ToRiYsbtSkzNzWdUvaSrkg0=
Content-Disposition: inline
In-Reply-To: <20230328221644.803272-8-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 28-03-23 22:16:42, Yosry Ahmed wrote:
> In workingset_refault(), we call
> mem_cgroup_flush_stats_atomic_ratelimited() to flush stats within an
> RCU read section and with sleeping disallowed. Move the call above
> the RCU read section and allow sleeping to avoid unnecessarily
> performing a lot of work without sleeping.

Could you say few words why the flushing is done before counters are
updated rather than after (the RCU section)?
-- 
Michal Hocko
SUSE Labs
