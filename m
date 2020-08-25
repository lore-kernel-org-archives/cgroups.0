From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Resend PATCH 1/6] mm/memcg: warning on !memcg after readahead
 page charged
Date: Mon, 24 Aug 2020 19:04:53 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2008241849020.1171@eggly.anvils>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com> <20200820145850.GA4622@lca.pw> <20200821080127.GD32537@dhcp22.suse.cz> <20200821123934.GA4314@lca.pw> <20200821134842.GF32537@dhcp22.suse.cz> <20200824151013.GB3415@dhcp22.suse.cz>
 <12425e06-38ce-7ff4-28ce-b0418353fc67@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=xCEzVSHJfiSnfhxabuVNC9t0rkX2zX2AVt5dsDA1M40=;
        b=Qx7zECjPFmyvrTTs8F/ocW7tCcVkTwhnunAlXDXZ02SD4HEo5pHK0qvUZ8cmV197QW
         23MJoL24elKzlrQkZr8Yc7T8ZQWrmKbeOUd4hY5pKufw1Z5VW9CMRTRZfbjXU1Za+2yc
         qRLjAl0KCQd2veC9jbi1F0Watbt0V5rKLyNSxNLUGzhHJw2G/qIDuCpOTi/JiHnQg6Lr
         gSCfATvLRBLoL6yZredvS7LzkNyRekKGV1W4rh92bKf6/LJkuKnmLxgLMp2gUOAexBpV
         MmYNyURSACJ5Zg10joqtevQml+/+IDZ7wYzyaTgpNw8011WUWi4XwnMLAStJVcudiGaV
         qJuw==
In-Reply-To: <12425e06-38ce-7ff4-28ce-b0418353fc67-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nao.horiguchi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org

On Tue, 25 Aug 2020, Alex Shi wrote:
> reproduce using our linux-mm random bug collection on NUMA systems.
> >>
> >> OK, I must have missed that this was on ppc. The order makes more sense
> >> now. I will have a look at this next week.
> > 
> > OK, so I've had a look and I know what's going on there. The
> > move_pages12 is migrating hugetlb pages. Those are not charged to any
> > memcg. We have completely missed this case. There are two ways going
> > around that. Drop the warning and update the comment so that we do not
> > forget about that or special case hugetlb pages.
> > 
> > I think the first option is better.
> > 
> 
> 
> Hi Michal,
> 
> Compare to ignore the warning which is designed to give, seems addressing
> the hugetlb out of charge issue is a better solution, otherwise the memcg
> memory usage is out of control on hugetlb, is that right?

Please don't suppose that this is peculiar to hugetlb: I'm not
testing hugetlb at all (sorry), but I see the VM_WARN_ON_ONCE from
mem_cgroup_page_lruvec(), and from mem_cgroup_migrate(), and from
mem_cgroup_swapout().

In all cases seen on a PageAnon page (well, in one case PageKsm).
And not related to THP either: seen also on machine incapable of THP.

Maybe there's an independent change in 5.9-rc that's defeating
expectations here, or maybe they were never valid.  Worth
investigating, even though the patch is currently removed,
to find out why expectations were wrong.

You'll ask me for more info, stacktraces etc, and I'll say sorry,
no time today.  Please try the swapping tests I sent before.

And may I say, the comment
/* Readahead page is charged too, to see if other page uncharged */
is nonsensical to me, and much better deleted: maybe it would make
some sense if the reader could see the comment it replaces - as
they can in the patch - but not in the resulting source file.

Hugh
