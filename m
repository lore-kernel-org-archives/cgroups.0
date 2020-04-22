From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/18] mm: memcontrol: switch to native NR_FILE_PAGES and
 NR_SHMEM counters
Date: Wed, 22 Apr 2020 15:42:34 +0900
Message-ID: <20200422064233.GI6780@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-10-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S4cmeJAIuJsYF1bOsD5QwAHBqMKC5f7P2yKTwX1eing=;
        b=GR52RWOyldaSx357kZpZdrxC4uXtpKfxWUcbhWtyoaAp4JIHvfVF5VJQGQwTjuY4GJ
         u+8Qyb9dA5RWz+ubh4UOpwTgoATfhFJmsw5LqmO+ImgXEYmEHFrJMQyuVC9iJ0/ubdq2
         fO0XZ6N/s1AnByjQyF33SGwwJPI7z96k4FpKJAHW9ZVME99CzXeXftQkDnzmzmmAHbbY
         iPVZrYtO1srOpH4Xn/Kqn4S1TfKxuCQIT/dKY0BDFM9jy4aAW8C2y0/Eqo5uhVVQ9VPE
         9cPEQKyDpRNvgzu3oGG5oJ7l0/KXEOdFpyoTC+hvoKVdiLiZxAcZVA2T0DLEeRljdTHk
         okPw==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-10-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:17PM -0400, Johannes Weiner wrote:
> Memcg maintains private MEMCG_CACHE and NR_SHMEM counters. This
> divergence from the generic VM accounting means unnecessary code
> overhead, and creates a dependency for memcg that page->mapping is set
> up at the time of charging, so that page types can be told apart.
> 
> Convert the generic accounting sites to mod_lruvec_page_state and
> friends to maintain the per-cgroup vmstat counters of NR_FILE_PAGES
> and NR_SHMEM. The page is already locked in these places, so
> page->mem_cgroup is stable; we only need minimal tweaks of two
> mem_cgroup_migrate() calls to ensure it's set up in time.
> 
> Then replace MEMCG_CACHE with NR_FILE_PAGES and delete the private
> NR_SHMEM accounting sites.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
