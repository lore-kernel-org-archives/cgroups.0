From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH -mm -v7 2/9] mm, memcg: Support to charge/uncharge
 multiple swap entries
Date: Fri, 31 Mar 2017 10:59:06 -0400
Message-ID: <20170331145906.GC6408@cmpxchg.org>
References: <20170328053209.25876-1-ying.huang@intel.com>
 <20170328053209.25876-3-ying.huang@intel.com>
 <20170329165722.GB31821@cmpxchg.org>
 <87k277twip.fsf@yhuang-dev.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tO32wVMcjHnIiAKcMGypT+pqmueDQMNyi2KimB0JnPM=; b=e88wwFUwT8+6VNSR2h5vNFXXUO
        Z4y6cvQ/tmRIi12jaVniuoaGuLzRfYEgsFY0iA3zoCossMwpzaAbkHxkePao47u8jP+k4y47Gzazz
        zy7ap+RzERKaIn3vzU8BRJ+Nn4cWyU1/v8a7VuaGBtxjwM6BOo8P4Bj5G6dIeHF7Lxvg=;
Content-Disposition: inline
In-Reply-To: <87k277twip.fsf-5/hDr2MS57EDqwDYnZuMFFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 30, 2017 at 08:53:50AM +0800, Huang, Ying wrote:
> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:
> > but there doesn't seem to be a reason to
> > pass @nr_entries when we have the struct page. Why can't this function
> > just check PageTransHuge() by itself?
> 
> Because sometimes we need to charge one swap entry for a THP.  Please
> take a look at the original add_to_swap() implementation.  For a THP,
> one swap entry will be allocated and charged to the mem cgroup before
> the THP is split.  And I think it is not easy to change this, because we
> don't want to split THP if the mem cgroup for swap exceeds its limit.

I think we do. Let's continue this discussion in the 9/9 subthread.
