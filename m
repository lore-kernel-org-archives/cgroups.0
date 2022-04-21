From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] MAINTAINERS: add corresponding kselftests to cgroup
 entry
Date: Thu, 21 Apr 2022 09:25:52 -1000
Message-ID: <YmGvwPIAA1LqCcku@slm.duckdns.org>
References: <20220415000133.3955987-1-roman.gushchin@linux.dev>
 <20220415000133.3955987-4-roman.gushchin@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cBrbiWDBHEqVzD/h6n2uk0w0Vf7EqWqgPo3W9iAFxx0=;
        b=HTZ57TThs2gZgtm09J297EO0M3RO62RHz/zVoetmYhSGSzXIWjGtQNVlcT/am6ElqW
         +cTLNQXaPDGTicHPztmAQxL3KOlCa0xow9uOS0FV7+JXKwDeZShuUEbBQiE0Rvus2mm5
         eLMesI2o5ptZFTctQwjDDGBVhqCeowgcfZNMhAiMxUibIPc0sbqguwSOhdL28aF/wAhR
         OZ5HsLcodEdCdqfjUtovF9t5paSvEko+HnTNyqgzeng1bpWq/xgmjewQjuDsQDeCZo73
         Hqyj9I01JfoH0aaOvVNTvMQISmhsF50hwZGJaZUherneAHdfPc/CDIR4kCzKfbNxpgrg
         5ujQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220415000133.3955987-4-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Thu, Apr 14, 2022 at 05:01:32PM -0700, Roman Gushchin wrote:
> List cgroup kselftests in the cgroup MAINTAINERS entry.
> These are tests covering core, freezer and cgroup.kill
> functionality.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I suppose this can go with the rest through -mm? Please let me know if I
should pick it up.

Thanks.

-- 
tejun
