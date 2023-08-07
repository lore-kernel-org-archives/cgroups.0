From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup/rstat: Record the cumulative per-cpu time of
 cgroup and its descendants
Date: Mon, 7 Aug 2023 08:42:01 -1000
Message-ID: <ZNE6-U5zwKUguRJE@slm.duckdns.org>
References: <20230807032930.87785-1-jiahao.os@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691433723; x=1692038523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZjR5pXl0UuinG01FbgVJViJLXMyiirXmYlC8ixIZaWI=;
        b=LBJ/vxIxnRKTm7zQ76pErn2jwczKbYDq41bpll/TUjJBnW7H/rQJVuz1tyUkGcB6oM
         sV67vRXYiyxhwWeEsQLiJ0ID04XmOSbbo3N1w86bLzq6xWRNq49SI9OPgbvf4/AyPxLs
         qL4112juNxcf595WcqGthvXUXZhQWF/PBxa+jZ+4C7rjwk36arxNV9yw3hoY7vf+XO1r
         0TxQ8G0HUw0gsWJjOTe85l556gc0VS5FHct7gGGq0LhfJcw8uIHOTS6oK6fTMFklJiHn
         Yey8etyXTAmszbJjWEEybEs45+iZ77ajyB36HpRv1hA6Fqc7E+0qtnvqqxBV2B9+Qy4k
         XBcw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230807032930.87785-1-jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 07, 2023 at 11:29:30AM +0800, Hao Jia wrote:
> The member variable bstat of the structure cgroup_rstat_cpu
> records the per-cpu time of the cgroup itself, but does not
> include the per-cpu time of its descendants. The per-cpu time
> including descendants is very useful for calculating the
> per-cpu usage of cgroups.
> 
> Although we can indirectly obtain the total per-cpu time
> of the cgroup and its descendants by accumulating the per-cpu
> bstat of each descendant of the cgroup. But after a child cgroup
> is removed, we will lose its bstat information. This will cause
> the cumulative value to be non-monotonic, thus affecting
> the accuracy of cgroup per-cpu usage.
> 
> So we add the subtree_bstat variable to record the total
> per-cpu time of this cgroup and its descendants, which is
> similar to "cpuacct.usage*" in cgroup v1. And this is
> also helpful for the migration from cgroup v1 to cgroup v2.
> After adding this variable, we can obtain the per-cpu time of
> cgroup and its descendants in user mode through eBPF/drgn, etc.
> And we are still trying to determine how to expose it in the
> cgroupfs interface.
> 
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
