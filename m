From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Tue, 29 Nov 2022 11:23:30 -0800
Message-ID: <CAHk-=wjMrsHq2ku9LeO23DnzGMZfQpZVSBFd86rZLLo3Q+H0VQ@mail.gmail.com>
References: <20221123181838.1373440-1-hannes@cmpxchg.org> <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
 <Y4TpCJ+5uCvWE6co@cmpxchg.org> <Y4ZYsrXLBFDIxuoO@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n82HVyeen1bMmFClFboMPGWDCdQZFtBvU3cG7O5fWI8=;
        b=MRtFC7hP8CY2xCqHP7rCYvfijtDEx8rfOpofNAGAenjjigPd8l2z/ynJKCzqdXRCs8
         8HqKcLlgR/Mh3Tm8fr5tI6H4dPIaUzK6LWHUAO8HRk8hG7k2Hl4tln+GqsEjL9CQGtlL
         znctiN96cf02+vcvkm8/vyh2JwKTdgt8JgeZU=
In-Reply-To: <Y4ZYsrXLBFDIxuoO-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 29, 2022 at 11:08 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> We can try limiting move candidates to present ptes. But maybe it's
> indeed time to deprecate the legacy charge moving altogether, and get
> rid of the entire complication.

Please. If that's what it takes..

           Linus
