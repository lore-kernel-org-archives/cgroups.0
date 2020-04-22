From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/18] mm: memcontrol: prepare uncharging for removal of
 private page type counters
Date: Wed, 22 Apr 2020 15:41:07 +0900
Message-ID: <20200422064106.GF6780@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FFXai4lc3A2Whp3tdpgUAfuzp8AdGL6AbM8bh1FKhoI=;
        b=aI4nuWwFYpWsS6XMk0wXURr5G6Xw02o7k3duOBm1u+gFfd6YvOPycF2KeoevA0D2RK
         DRoP8twmMMiHQSrfQT3OOXKpZhwn+UCkFN0U6C4rC6gX9mPO85rkRp2aATBkM5i3zVIX
         SPAivrjIQHswt90xXmtCxNwbGg4GJGIkc3dLR9NqM8238/dWYqSJVaILrB5TRAQqgQEk
         DVk6wig4C8alf433BjHDMXmdLyDmwAx6l0bFs0Z+HRUmslyho8mkVBlJoivHhEFu0NjB
         VRHSgcNdxRzUkD7b/uU110jv81DkhGL6B+XOLvW3t6FstiE8e7TJteA3XP+3f9bzqit0
         Hwvg==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-7-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:14PM -0400, Johannes Weiner wrote:
> The uncharge batching code adds up the anon, file, kmem counts to
> determine the total number of pages to uncharge and references to
> drop. But the next patches will remove the anon and file counters.
> 
> Maintain an aggregate nr_pages in the uncharge_gather struct.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
