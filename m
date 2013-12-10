From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v13 00/16] kmemcg shrinkers
Date: Tue, 10 Dec 2013 12:02:26 +0400
Message-ID: <CAA6-i6rSE+PvnvmnE_6jBZvsJ+ZJmX1pSwPBE_JZw-OTotNSxQ@mail.gmail.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Q1FklkM8CN7kjSrGY5bEJg9YOFbCrS1XBuvlQ7DVV+I=;
        b=eI7I8PpIB4hUDq1cgm/c8zQ6Wp3ib456Caz1qCLoD/UYTBYdb7YD6PsAtr3pK1FMjP
         F9I5XW+OVq4KDGq2kBHbjKOUaLwKwjt7FTgsJNW0EhgvOcQMEdXOIfMMXg6DHF8l8n1K
         7X1ioAuHkE4DUZ7s+5Y70dfhVYE0ndbZHC1o3Qu2TLZWe1i7KnVrVHKzHwWlnCNIPy/+
         pqnOJ/J1tlmcSIhSJweCWI6mD/XkpHfL5JpO8ux2gPxrofrkEmvGelmN5GjoNGLl+xdu
         34avNWrBzbqcY4My9HhX2iKWFKNy501fRE6lLAEVRxxJB9SzPGEAjf9rKEmKqMvdY5M3
         2lqg==
In-Reply-To: <cover.1386571280.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Glauber Costa <glommer@openvz.org>

> Please note that in contrast to previous versions this patch-set implements
> slab shrinking only when we hit the user memory limit so that kmem allocations
> will still fail if we are below the user memory limit, but close to the kmem
> limit. This is, because the implementation of kmem-only reclaim was rather
> incomplete - we had to fail GFP_NOFS allocations since everything we could
> reclaim was only FS data. I will try to improve this and send in a separate
> patch-set, but currently it is only worthwhile setting the kmem limit to be
> greater than the user mem limit just to enable per-memcg slab accounting and
> reclaim.

That is unfortunate, but it makes sense as a first step.



-- 
E Mare, Libertas

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
