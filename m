From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/18] mm: memcontrol: prepare cgroup vmstat
 infrastructure for native anon counters
Date: Wed, 22 Apr 2020 15:42:09 +0900
Message-ID: <20200422064208.GH6780@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Drc+56Q36eDpJcbMrcUJkfyYMbc4NMUbpx2Oj4m1kIA=;
        b=CUOUDClkinZimUWFeCOxuqvCFZL8oJ4l7+brBtc7xtSfkuDi8UsLA+VHKR4YMwKO8p
         nTywzbCpVQ7TjgRm20khS6C+SNQCruZOWGnqOuj/a8tv10tKQj7t1VUxfkSnU22gi/zI
         fR64Hpy+yb2ajCoVr8dBtKM84OyeQfsSxka9Uq8WLNa5NNMxZxDZ0n9bqHMHodAr6U5L
         95QzwG7l8owtJHvhyDE7oZTAgtceuXBsps0jjvvRYx1zKLY4P7ExdGyVtdz3CplwRa8z
         L5J0PLgzizfm6wou7IZP9dqjV8T114XHK+SjsE4lXC35XKT+LMJ4J8u035kjiJ69yIEJ
         l6dg==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-9-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:16PM -0400, Johannes Weiner wrote:
> Anonymous compound pages can be mapped by ptes, which means that if we
> want to track NR_MAPPED_ANON, NR_ANON_THPS on a per-cgroup basis, we
> have to be prepared to see tail pages in our accounting functions.
> 
> Make mod_lruvec_page_state() and lock_page_memcg() deal with tail
> pages correctly, namely by redirecting to the head page which has the
> page->mem_cgroup set up.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
