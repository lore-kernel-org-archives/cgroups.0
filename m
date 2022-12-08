From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: memcontrol: skip moving non-present pages that
 are mapped elsewhere
Date: Wed, 7 Dec 2022 16:36:07 -0800
Message-ID: <CALvZod4RxpYOeVurV-vrTc7MY7m8tDCJPOsX+JNGv5BsuFMEFA@mail.gmail.com>
References: <20221206171340.139790-1-hannes@cmpxchg.org> <20221206171340.139790-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hnwjKeWBS3gGbPLTonrsO/3QESDmxRzIhrG9LgstSBg=;
        b=NlFKm5a2bnfBu0WaavUk4T4534i2Ffeaod/IcsY3hbfl5pfgAHlWwatoI96o/JhxVY
         wv4jmxKJolkcLNfPjePOus4PgAoxfKxZa11QwswwKUrxbVgfpHCGZsLmLLpLRBARa5FD
         KNO2NlvY1X3gGX7GblLaLaMZ6NYgxW2EGxv2OS1UPupWVD0MOlRVlBmqHZ/ZU6UtEOYh
         XmzzI29PN659tu4HW9S9xkSazS6K1wt/sjeiwL4GMroztNtIq1BewgZTmaHVRqjEebmV
         rsbYmjDqi2YDUT9xod5OiRzgobIh9Oc1bvJH3yUAIXl2GAmgY4Qg039o4TksWbGj30XX
         26lw==
In-Reply-To: <20221206171340.139790-2-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 6, 2022 at 9:14 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> During charge moving, the pte lock and the page lock cover nearly all
> cases of stabilizing page_mapped(). The only exception is when we're
> looking at a non-present pte and find a page in the page cache or in
> the swapcache: if the page is mapped elsewhere, it can become unmapped
> outside of our control. For this reason, rmap needs lock_page_memcg().
>
> We don't like cgroup-specific locks in generic MM code - especially in
> performance-critical MM code - and for a legacy feature that's
> unlikely to have many users left - if any.
>
> So remove the exception. Arguably that's better semantics anyway: the
> page is shared, and another process seems to be the more active user.
>
> Once we stop moving such pages, rmap doesn't need lock_page_memcg()
> anymore. The next patch will remove it.
>
> Suggested-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
