From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: reduce size of memcg vmstats structures
Date: Wed, 7 Sep 2022 16:27:12 -0700
Message-ID: <Yxko0AxuVO6oiN5M@P9FQF9L96D.corp.robot.car>
References: <20220907043537.3457014-1-shakeelb@google.com>
 <20220907043537.3457014-4-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662593251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TaKcAPnW1Rv+P8V2WVmdtPwTsnlpyaGaJZ+gn5WE91Y=;
        b=ccqnbVj+QPPasLxHBGE6AFu8Yoq671MiQPkkyRGJgyLs7qpb2LL2u4wMhuPhWCx2es0Ow0
        vm2SBlmaYjH8gKdhHyNdc9jnyC4Ik2/2sgdVZTnqm7dxc35nofvltU0Mtl84Fx2WLrNhIZ
        DL6do2sxzUEfuACz0QOFL05zurqThbg=
Content-Disposition: inline
In-Reply-To: <20220907043537.3457014-4-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 07, 2022 at 04:35:37AM +0000, Shakeel Butt wrote:
> The struct memcg_vmstats and struct memcg_vmstats_percpu contains two
> arrays each for events of size NR_VM_EVENT_ITEMS which can be as large
> as 110. However the memcg v1 only uses 4 of those while memcg v2 uses
> 15. The union of both is 17. On a 64 bit system, we are wasting
> approximately ((110 - 17) * 8 * 2) * (nr_cpus + 1) bytes which is
> significant on large machines.
> 
> This patch reduces the size of the given structures by adding one
> indirection and only stores array of events which are actually used by
> the memcg code. With this patch, the size of memcg_vmstats has reduced
> from 2544 bytes to 1056 bytes while the size of memcg_vmstats_percpu has
> reduced from 2568 bytes to 1080 bytes.

This is pretty impressive!

Thank you, Shakeel!

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
for the series.

Thanks!
