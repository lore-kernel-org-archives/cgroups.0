From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 2/3] mm: rmap: remove lock_page_memcg()
Date: Wed, 7 Dec 2022 16:36:39 -0800
Message-ID: <CALvZod7jy0gvXRHhsJ2aaj+rP=3if5c4+p+-kC-qo3WSU+tRqQ@mail.gmail.com>
References: <20221206171340.139790-1-hannes@cmpxchg.org> <20221206171340.139790-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qeBXIqzSfIuH6SAUQWNL+jPx2S1sL9td+8nqZ4xaU5o=;
        b=i8izx+NjrAcYy4Azi2gqPWXEKbDGdCxrPDPu+ynSN5Bk59ImL6T95Oo1WQs/o3O4Dv
         psw4F81s8kACsalYuCfa3YKVBUaWdt1dN1dLAoYO2bURSF/UvH71sAocuPgjbCHFDXAM
         /BfpE2un7nJiG6xpMzVfPOtcBBwkYXRlKNKXsR8yKpQI5Y5Asgu0Pbzs6N11XFobKotf
         IkSSSNBiGAgpC/2Dnet7amfL8e3kbgaIJuFInroYam92GkAtxrLFF98Ng380oqEdtEKn
         aDEn6p51I0QgovKxUPDyJugKpODyKOUt14FWakO7ddAbM+U7UBLTPVLiByTMRh8LYTJs
         2hHQ==
In-Reply-To: <20221206171340.139790-3-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 6, 2022 at 9:14 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> The previous patch made sure charge moving only touches pages for
> which page_mapped() is stable. lock_page_memcg() is no longer needed.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeelb@google.com>
