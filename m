From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Wed, 23 Nov 2022 10:34:27 -0800
Message-ID: <CALvZod488YStQ5tucPgc0b3FSwiqFhVJptPceFvaZjj2Ba24YA@mail.gmail.com>
References: <20221123181838.1373440-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tELD2VQL8vhWDECXZ4KBFxXiAPz5Gyk7j2brYG+e7vo=;
        b=MsY086PNmr0Enodb3X6kbiamRzMWU6bqnw3zAK/YhYEIMOzRtWLfMKo/hKzzyBUapk
         QcM9+DGMXq9/qqpaiec63a+VT4ELUKRbyCZ3+ZFDDW1CnwYEe+kwXwuGSUo01eohnJ5F
         C0P7zjWF88GUfhfkn/pJLlJMCoHR8O3Rb5bZIq80jG9kUd83cEOOhuOwSFI1Iv9KE2Kt
         jpufQUaMk2odO6mtmdK7EhfINsOo6DhuZtdaxlQPKXJFdVpjTqlArOKKI+4rFAIbY6xG
         0IMiw8bfVB7sDBvcxZYEOHndyy4gYsLtQor3yHI2KLjKXYbibhvPhJ9Hp8jsRO/bzHn/
         dEGg==
In-Reply-To: <20221123181838.1373440-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 10:18 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> rmap changes (mapping and unmapping) of a page currently take
> lock_page_memcg() to serialize 1) update of the mapcount and the
> cgroup mapped counter with 2) cgroup moving the page and updating the
> old cgroup and the new cgroup counters based on page_mapped().
>
> Before b2052564e66d ("mm: memcontrol: continue cache reclaim from
> offlined groups"), we used to reassign all pages that could be found
> on a cgroup's LRU list on deletion - something that rmap didn't
> naturally serialize against. Since that commit, however, the only
> pages that get moved are those mapped into page tables of a task
> that's being migrated. In that case, the pte lock is always held (and
> we know the page is mapped), which keeps rmap changes at bay already.
>
> The additional lock_page_memcg() by rmap is redundant. Remove it.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
