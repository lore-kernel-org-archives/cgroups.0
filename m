From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v20 01/20] mm/memcg: warning on !memcg after readahead
 page charged
Date: Thu, 29 Oct 2020 09:43:46 -0400
Message-ID: <20201029134346.GB599825@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-2-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lMVsDoZ2rvYhRouYTnsQqKObuVh6EX/L2Iet4zmcg+0=;
        b=BqZ2R2ieXOiIyfj4R06JqpmwkZDKmSom+oB6s4vJ3gT+gZ0OND8K/gSscTX2Ax4YSL
         th+NpS/aAW9WU9gUbnUk6J2t8Tp6ot3gvUb+/Wqxbmh9oVvb4neSwLThNjXM4j2yFQUg
         Zt/qaKVHiCUkE6S2dy0ZLkpZ7hAoJZTPQ9hb2rwV67DMknJ8A1iSh8jHBADKov09dNWG
         wUL46gT3QRe9y0P/5t0OhMkwqxX8F/m+Py4topxcn5Ws8DywxAPZ/2FzlE6cx4EpvU/8
         XPEiPhhjlKLee4syFyTA3ZhySwdIZlKRhkhJCAVIDBlBVvgErA68e84xR75aHFHvDqiv
         lo/Q==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-2-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Michal Hocko <mhocko@kernel.org>

On Thu, Oct 29, 2020 at 06:44:46PM +0800, Alex Shi wrote:
> Add VM_WARN_ON_ONCE_PAGE() macro.
> 
> Since readahead page is charged on memcg too, in theory we don't have to
> check this exception now. Before safely remove them all, add a warning
> for the unexpected !memcg.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
