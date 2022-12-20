From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/2] mm: kmem: optimize get_obj_cgroup_from_current()
Date: Tue, 20 Dec 2022 11:55:34 -0800
Message-ID: <CALvZod5q0koAckpTr4VBq-_KiQpsmC86bE4eP9gzX71PzRdicA@mail.gmail.com>
References: <20221220182745.1903540-1-roman.gushchin@linux.dev> <20221220182745.1903540-2-roman.gushchin@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T6Ibv8lELNGtBRxXq2xqbZ6XNIWdISjKd5l36khEMAE=;
        b=KSZwcjFTFFO55WSmVmRgONnRwskWoYawCL4xr2GcTp5EfCyO5dWsx7AbSD6Ir/ybby
         C7hVXroJGbjMZ6JZecHbZizIkqMntO9LCfTQjh70KYV62x3n7GT3pigY+IdDXJ6+hW0U
         mEwxE2cJuzhZ473p3CRLSLMKt5y1k+WqODiXLaurmLprlQIu83KIRui/7aB62vVSerFG
         oJ6BbA0p2cayN9RAavaPE83CL3JFmwg8mr83/EY4R4NMFXcDSamu5fqDMXFsJi4+yNTL
         KYFBpfYMu9bW5ttoTGe9B6d7fqichfkqe1iiFZLjZZbtB+BAkuBEyxDREF+RcnvyviBH
         sPNw==
In-Reply-To: <20221220182745.1903540-2-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Dec 20, 2022 at 10:28 AM Roman Gushchin
<roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> Manually inline memcg_kmem_bypass() and active_memcg() to speed up
> get_obj_cgroup_from_current() by avoiding duplicate in_task() checks
> and active_memcg() readings.
>
> Also add a likely() macro to __get_obj_cgroup_from_memcg():
> obj_cgroup_tryget() should succeed at almost all times except
> a very unlikely race with the memcg deletion path.
>
> Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Can you please add your performance experiment setup and result of
this patch in the commit description of this patch as well?

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
