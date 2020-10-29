From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v20 03/20] mm/thp: move lru_add_page_tail func to
 huge_memory.c
Date: Thu, 29 Oct 2020 09:47:36 -0400
Message-ID: <20201029134736.GD599825@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-4-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aaIMvQUgy5GfKnfOz1OmQc/tQFUJWmKT+5EU7lJnpIg=;
        b=Rkh4mNNWCGTBaZ0kV3h45r9aCfQYTEYCWwhRTXhZukO72CfLpaYAPvSKsRefVLAzBS
         XY2eapgWAFWjyUUoH7y9nXTAJxwWC0HpyKLRREWAnnPufo2nFhCVDJwAxmSRiG1SmYRt
         6de9omlzVlZi/CoRpBC8oLf0Zij5KZIx0kMdZbchDA9917NbYrk8f8zEeYVWy2US9YjA
         rcbo+L01DJPTZi0FIodyReVMGdqEpBmGzPA6I4C628VHdPh3HjvJyu+YvqWL6rvh+ovW
         n34QeAf/1/kiOVFLMOiZqY0/zzh8MIaom8wOQ4Bn/zCvhHIA8fL2jeT3TJy7SmFibzxX
         yETg==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-4-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Thu, Oct 29, 2020 at 06:44:48PM +0800, Alex Shi wrote:
> The func is only used in huge_memory.c, defining it in other file with a
> CONFIG_TRANSPARENT_HUGEPAGE macro restrict just looks weird.
> 
> Let's move it THP. And make it static as Hugh Dickin suggested.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
