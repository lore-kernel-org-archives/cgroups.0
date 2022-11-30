From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Wed, 30 Nov 2022 17:30:04 -0500
Message-ID: <Y4fZbFNVckh1g4WO@cmpxchg.org>
References: <20221123181838.1373440-1-hannes@cmpxchg.org>
 <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
 <Y4TpCJ+5uCvWE6co@cmpxchg.org>
 <Y4ZYsrXLBFDIxuoO@cmpxchg.org>
 <3659bbe0-ccf2-7feb-5465-b287593aa421@google.com>
 <CALvZod7_FjO-CjzHUpQTsCTm4-68a1eKi_qY=4XdF+g7yMLd4Q@mail.gmail.com>
 <e0918c92-90cd-e3ed-f4e6-92d02062c252@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YE7jXxz564+ij1F7ID7Smaf8XdVIpgEM18wsOYbg3aI=;
        b=m4nPay6NFvD+wrygzHoAAEj6bi16gjB6pd//RmTxx/BSfRxwShWVVNlw2v++ANe9sC
         IfryetzxwhkZR4y+YcM+nho/ywaN12FyGbqz00aSeE69Sm94NnBMjbg+iSGXMmd/i6B9
         +PA2NPIgAWqWYUcNRsnA9K7ZNvIBJzU7jjWh1cS7HlyHHGKBA91lnGA0Jjro5TDAjbTy
         DWXahcLLhg2Rh+MyDQ67llbSkztb1Gvq9AXWdjovY2IYRqGtWG38x5CDLtPgw2LHWRPx
         chO/8kccdpcFYRKhW97nNYycTog1y1uUq4x9LPJ5ol8ZdyP5TM4ABChtFHbMVgrG293S
         /SyQ==
Content-Disposition: inline
In-Reply-To: <e0918c92-90cd-e3ed-f4e6-92d02062c252-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 30, 2022 at 09:36:15AM -0800, Hugh Dickins wrote:
> On Wed, 30 Nov 2022, Shakeel Butt wrote:
> > 
> > 2. For 6.2 (or 6.3), remove the non-present pte migration with some
> > additional text in the warning and do the rmap cleanup.
> 
> I just had an idea for softening the impact of that change: a moment's
> more thought may prove it's a terrible idea, but right now I like it.
> 
> What if we keep the non-present pte migration throughout the deprecation
> period, but with a change to the where the folio_trylock() is done, and
> a refusal to move the charge on the page of a non-present pte, if that
> page/folio is currently mapped anywhere else - the folio lock preventing
> it from then becoming mapped while in mem_cgroup_move_account().

I would like that better too. Charge moving has always been lossy
(because of trylocking the page, and having to isolate it), but
categorically leaving private swap pages behind seems like a bit much
to sneak in quietly.

> There's an argument that that's a better implementation anyway: that
> we should not interfere with others' pages; but perhaps it would turn
> out to be unimplementable, or would make for less predictable behaviour.

Hm, I think the below should work for swap pages. Do you see anything
obviously wrong with it, or scenarios I haven't considered?

@@ -5637,6 +5645,46 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
         * we call find_get_page() with swapper_space directly.
         */
        page = find_get_page(swap_address_space(ent), swp_offset(ent));
+
+       /*
+        * Don't move shared charges. This isn't just for saner move
+        * semantics, it also ensures that page_mapped() is stable for
+        * the accounting in mem_cgroup_mapcount().
+        *
+        * We have to serialize against the following paths: fork
+        * (which may copy a page map or a swap pte), fault (which may
+        * change a swap pte into a page map), unmap (which may cause
+        * a page map or a swap pte to disappear), and reclaim (which
+        * may change a page map into a swap pte).
+        *
+        * - Without swapcache, we only want to move the charge if
+        *   there are no other swap ptes. With the pte lock, the
+        *   swapcount is stable against all of the above scenarios
+        *   when it's 1 (our pte), which is the case we care about.
+        *
+        * - When there is a page in swapcache, we only want to move
+        *   charges when neither the page nor the swap entry are
+        *   mapped elsewhere. The pte lock prevents our pte from
+        *   being forked or unmapped. The page lock will stop faults
+        *   against, and reclaim of, the swapcache page. So if the
+        *   page isn't mapped, and the swap count is 1 (our pte), the
+        *   test results are stable and the charge is exclusive.
+        */
+       if (!page && __swap_count(ent) != 1)
+               return NULL;
+
+       if (page) {
+               if (!trylock_page(page)) {
+                       put_page(page);
+                       return NULL;
+               }
+               if (page_mapped(page) || __swap_count(ent) != 1) {
+                       unlock_page(page);
+                       put_page(page);
+                       return NULL;
+               }
+       }
+
        entry->val = ent.val;
 
        return page;
