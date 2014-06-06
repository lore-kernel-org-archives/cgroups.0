From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
Date: Fri, 6 Jun 2014 11:10:42 +0200
Message-ID: <20140606091042.GB26253@dhcp22.suse.cz>
References: <1401976841-3899-1-git-send-email-richard@nod.at>
 <1401976841-3899-2-git-send-email-richard@nod.at>
 <20140605150025.GB15939@dhcp22.suse.cz>
 <alpine.DEB.2.02.1406051358210.18119@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406051358210.18119@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Richard Weinberger <richard@nod.at>, hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org, handai.szj@taobao.com, oleg@redhat.com, rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu 05-06-14 14:01:02, David Rientjes wrote:
> On Thu, 5 Jun 2014, Michal Hocko wrote:
> 
> > If we are printing too much then OK, let's remove those parts which are
> > not that useful but hiding information which tells us more about the oom
> > decision doesn't sound right to me.
> > 
> 
> Memcg oom killer printing is controlled mostly by 
> mem_cgroup_print_oom_info(), I don't see anything in the generic oom 
> killer that should be removed and that I have not used even for memcg ooms 
> in the past.

Yes, I find most of the information printed during OOM very helpful.
After 58cf188ed649 (memcg, oom: provide more precise dump info while
memcg oom happening) even memcg oom info is helpful.

> Perhaps there could be a case made for suppressing some of the 
> hierarchical stats from being printed for memcg ooms and controlled by 
> another memcg knob, but it doesn't sound vital.

Agreed.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
