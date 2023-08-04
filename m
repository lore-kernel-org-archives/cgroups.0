From: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v3] selftests: cgroup: fix test_kmem_basic slab1 check
Date: Fri, 4 Aug 2023 14:36:36 +0800
Message-ID: <22339C68-8BCA-4CB4-895B-9FE679D4D34B@linux.dev>
References: <zff2gqiy4cggy4px2hbcyna6eipy56qc4itx5cx5agtxlzdxt7@dvfdarqkucac>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691131041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MNm9pORzTgeogyqyW+mD8AlYYC8dXpJMUZdeirF8KCc=;
        b=lGU4btESR6WhEkMDXa2K6SgziaZU8b0hBHTqqAyF7szoZin5ZQ2hAjVHd1brkR/ab5Pt1E
        EBkiru/eTktl0j/74+CcJPbEcas/cdaQVsMEanF1vKFOevsW382PoWFv7lWAEZUBjxY5nV
        ozwpR2K+WN/7PlcwbrKAt776kTFudsg=
In-Reply-To: <zff2gqiy4cggy4px2hbcyna6eipy56qc4itx5cx5agtxlzdxt7@dvfdarqkucac>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



> On Aug 4, 2023, at 02:25, Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> test_kmem_basic creates 100,000 negative dentries, with each one mapping
> to a slab object. After memory.high is set, these are reclaimed through
> the shrink_slab function call which reclaims all 100,000 entries. The
> test passes the majority of the time because when slab1 is calculated,
> it is often above 0, however, 0 is also an acceptable value.
> 
> Signed-off-by: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks

