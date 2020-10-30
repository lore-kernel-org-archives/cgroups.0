From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v20 04/20] mm/thp: use head for head page in
 lru_add_page_tail
Date: Fri, 30 Oct 2020 09:52:18 -0400
Message-ID: <20201030135218.GA666074@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-5-git-send-email-alex.shi@linux.alibaba.com>
 <20201029135047.GE599825@cmpxchg.org>
 <06a5b7d8-bbf2-51b7-1352-2b630186e15f@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=p1nkWHsTTJ1phk0MECInN7pnDwPUF1bojBnmQs9PZoM=;
        b=JsNIng18yHH5/LXDpPA+BwLTBHcs1T13ZwrR46DvSQd2iyr/I2H49p0AaTvTYPWxtu
         hRlzMwdMBF7gPpGJExMS3hcyvwcq2OLXMcHJRUYaIINATS2DLqUpB59uW/MCb8eG1cmy
         KIX7EF8KQzWW81n5ccWUkUQOY5wf00O99LDkOtjXk3o27fEMFo/HJDlPg7FqiHLAHTPP
         S8DBv/CExSuAh1XX/bl1C3LjbAgG1WJWjXBibLWMbrn+cWxhUD3vFLKq8SWWvl8XFGzZ
         1q1WFkMcp6/IugaIHT2dqvt7HYV96HeBabnklmKeSNKFtYP/mXrizgDpZLO2t9x51Da1
         lZsA==
Content-Disposition: inline
In-Reply-To: <06a5b7d8-bbf2-51b7-1352-2b630186e15f-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, Oct 30, 2020 at 10:46:54AM +0800, Alex Shi wrote:
> 在 2020/10/29 下午9:50, Johannes Weiner 写道:
> > It may be better to pick either
> > 	head and tail
> 
> Hi Johannes,
> 
> Thanks for comments!
> 
> Right, Consider functions in this file are using head/tail more as parameters
> I will change to use head/tail too. And then, the 04th, 05th, and 18th patch 
> will be changed accordingly.

That's great, thank you!

> From a9ee63a213f40eb4d5a69b52fbb348ff9cd7cf6c Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Date: Tue, 26 May 2020 16:49:22 +0800
> Subject: [PATCH v21 04/20] mm/thp: use head for head page in lru_add_page_tail
> 
> Since the first parameter is only used by head page, it's better to make
> it explicit.
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
