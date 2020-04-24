From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 15/18] mm: memcontrol: make swap tracking an integral
 part of memory control
Date: Fri, 24 Apr 2020 09:30:52 +0900
Message-ID: <20200424003051.GE13929@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-16-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L5XArOSUZwIEnxR3eCf7lGVK2eb+Bi3jkepM1WeX9QE=;
        b=YFPVrqX/oo9QxWP7xGzlaGJ9raYM+zVB0puskfyk362PScv39Lh67FW0q+PCC8NpeG
         pbW8NfRzGNkrdsK4jdMh/G1k2wT9sziF6YTxoVNJ/wmwmKVvOXPga05yfPr+cbBNtnDI
         QNRMbCkJyu5bU0tF+Gz2dR6hbULu4Z4ktTjvQUesjqAcBKSiBdYQGFv7OX83/2QS2vP6
         70MjjYA9OMDctxic2eG+QCQV3QVT8WcivhAvczc5+vH6amZtwibpZCabA//sCP+ITktv
         UJ6LOoeKeYB83s85iZxIxbmwLrOySFnUeMghkxwak+uK1NHrs8JDMAl9sHfTNN/+x9cj
         HC4A==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-16-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:23PM -0400, Johannes Weiner wrote:
> Without swap page tracking, users that are otherwise memory controlled
> can easily escape their containment and allocate significant amounts
> of memory that they're not being charged for. That's because swap does
> readahead, but without the cgroup records of who owned the page at
> swapout, readahead pages don't get charged until somebody actually
> faults them into their page table and we can identify an owner task.
> This can be maliciously exploited with MADV_WILLNEED, which triggers
> arbitrary readahead allocations without charging the pages.
> 
> Make swap swap page tracking an integral part of memcg and remove the
> Kconfig options. In the first place, it was only made configurable to
> allow users to save some memory. But the overhead of tracking cgroup
> ownership per swap page is minimal - 2 byte per page, or 512k per 1G
> of swap, or 0.04%. Saving that at the expense of broken containment
> semantics is not something we should present as a coequal option.
> 
> The swapaccount=0 boot option will continue to exist, and it will
> eliminate the page_counter overhead and hide the swap control files,
> but it won't disable swap slot ownership tracking.
> 
> This patch makes sure we always have the cgroup records at swapin
> time; the next patch will fix the actual bug by charging readahead
> swap pages at swapin time rather than at fault time.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

