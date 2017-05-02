From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 0/2] mm/memcontrol: fix reclaim bugs in mem_cgroup_iter
Date: Tue, 2 May 2017 16:03:57 +0200
Message-ID: <20170502140357.GL14593@dhcp22.suse.cz>
References: <1493416547-19212-1-git-send-email-sean.j.christopherson@intel.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1493416547-19212-1-git-send-email-sean.j.christopherson@intel.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri 28-04-17 14:55:45, Sean Christopherson wrote:
> This patch set contains two bug fixes for mem_cgroup_iter().  The bugs
> were found by code inspection and were confirmed via synthetic testing
> that forcefully setup the failing conditions.

I assume that you added some artificial sleeps to make those races more
probable, right? Or did you manage to hit those issue solely from the
userspace? I will have a look at those patches. It has been some time
since I've had it cached. It is pretty subtle code so I would like to
understand the urgency before I dive into this further.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
