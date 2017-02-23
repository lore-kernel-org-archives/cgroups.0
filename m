From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 2/2] mm/cgroup: delay soft limit data allocation
Date: Thu, 23 Feb 2017 14:03:13 -0500
Message-ID: <20170223190313.GB6088@cmpxchg.org>
References: <1487856999-16581-1-git-send-email-ldufour@linux.vnet.ibm.com>
 <1487856999-16581-3-git-send-email-ldufour@linux.vnet.ibm.com>
 <20170223153107.GD29056@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LfqzPD4Fwee/0dPxRYunaaYpLCTefiRNbqL4x1obO1Y=; b=P/13gaHIuMzi/mE/vGvc050YDY
	7z5+kAVKc7SMj4imIsfrbvehyr5k2H3iJ2fYrI3kq7nNAodFrKbKR/w9/ym527Psv89fKGmIo2qll
	EM0/5rXVZKFBoxBb1wQ3LIIA6sWLDeZp3OZnRk/WNoPwfTRYJukm/TpUFmuAG8a8PB+4=;
Content-Disposition: inline
In-Reply-To: <20170223153107.GD29056@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Feb 23, 2017 at 04:31:07PM +0100, Michal Hocko wrote:
> On Thu 23-02-17 14:36:39, Laurent Dufour wrote:
> > Until a soft limit is set to a cgroup, the soft limit data are useless
> > so delay this allocation when a limit is set.
> 
> Hmm, I am still undecided whether this is actually worth it. On one hand
> distribution kernels tend to have quite large NUMA_SHIFT (e.g. SLES has
> NUMA_SHIFT=10 and then we will save 8kB+12kB which is not hell of a lot
> but always good if we can save that, especially for a rarely used
> feature. The code grown on the other hand (it was in __init section
> previously) which is a minus, on the other hand.
> 
> What do you think Johannes?

Hohumm, saving 5 pages on a NUMA machine vs. the additional complexity
and the increased risk of memory problems when somebody sets up a soft
limit after some uptime... I don't think I can give a strong yes or no
on this one, so inertia wins for me; I'd just leave it alone.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
