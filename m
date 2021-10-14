From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] memcg: page_alloc: skip bulk allocator for
 __GFP_ACCOUNT
Date: Thu, 14 Oct 2021 13:53:49 -0400
Message-ID: <YWhurV5tLsMZQaA9@cmpxchg.org>
References: <20211014151607.2171970-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zJB8zVukIQ+/02Rc0y98q23z81gJRt8QzQtT1HzSbCg=;
        b=ELuQkXd9ubC+OOcBV7fXc70bOKtTagxKSxoApRUZ/4BsKndSk0l6tVMuHdx9fGF8zH
         GORoT66pFq9wl8kI1VG/IbM0ZkQtbmbFy28q5ZyHmlwRLBj6NWqSXekY1Otqk933Qbv7
         ZzzvXg8ECuwL+T68M4ziC52MUIzd1A/c3vjxaTKvNjOdZKbK5kJbRJOctsmBzxNUL/YD
         1THlLPXxUs/+yF6XR1swIr/l3cprEL6aLrnPAQw8H4lRzMDB8F20ARkbeGD9svke4yjt
         Whnosw86G4eJkcVRzBte5sAgcWStb1FwWIYYSpxBMgiIP2ZHEgXw9eYXD0AKGy59C/HR
         pa9w==
Content-Disposition: inline
In-Reply-To: <20211014151607.2171970-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 14, 2021 at 08:16:07AM -0700, Shakeel Butt wrote:
> The commit 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in
> __vmalloc_area_node()") switched to bulk page allocator for order 0
> allocation backing vmalloc. However bulk page allocator does not support
> __GFP_ACCOUNT allocations and there are several users of
> kvmalloc(__GFP_ACCOUNT).
> 
> For now make __GFP_ACCOUNT allocations bypass bulk page allocator. In
> future if there is workload that can be significantly improved with the
> bulk page allocator with __GFP_ACCCOUNT support, we can revisit the
> decision.
> 
> Fixes: 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()")
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
