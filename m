From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 3/9] mm: memcontrol: retry reclaim for oom-disabled and
 __GFP_NOFAIL charges
Date: Thu, 8 May 2014 14:28:48 -0400
Message-ID: <20140508182848.GP19914@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-4-git-send-email-hannes@cmpxchg.org>
 <20140507144339.GI9489@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=7V/P5U9vfO4ovPcxfuhkVp4M7p3D6ntengR6k92/PjA=;
	b=q4p+y6uTmoyJ3+y7m4Zb783l+Hf806b4L3ail/IG+Zf75sIUzeg51k6kNP9vihbLUKe8wZ4hvj5POHUI66NsQEbfXeydQzHtLA744H1M+X30CkJx5sPNUxKbRi+DeQ8Q5ytDGDXQO0/F0pshHqWSs+IVwbtFBEmmPkdp/xRf0Ns=;
Content-Disposition: inline
In-Reply-To: <20140507144339.GI9489@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 04:43:39PM +0200, Michal Hocko wrote:
> On Wed 30-04-14 16:25:37, Johannes Weiner wrote:
> > There is no reason why oom-disabled and __GFP_NOFAIL charges should
> > try to reclaim only once when every other charge tries several times
> > before giving up.  Make them all retry the same number of times.
> 
> I guess the idea whas that oom disabled (THP) allocation can fallback to
> a smaller allocation. I would suspect this would increase latency for
> THP page faults.

If it does, we should probably teach THP to use __GFP_NORETRY.

On that note, __GFP_NORETRY is currently useless for memcg because it
has !__GFP_WAIT semantics...  I'll include a fix for that in v2.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
