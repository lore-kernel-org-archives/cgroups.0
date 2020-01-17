From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
Date: Fri, 17 Jan 2020 12:59:35 +0100
Message-ID: <20200117115935.GW19428@dhcp22.suse.cz>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
 <20200117091002.GM19428@dhcp22.suse.cz>
 <b67fe2bb-e7a6-29fe-925e-dd1ae176cc4b@virtuozzo.com>
 <alpine.DEB.2.21.2001170132090.20618@chino.kir.corp.google.com>
 <11ba0af7-c2b2-83f9-ac55-7793cedb8028@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11ba0af7-c2b2-83f9-ac55-7793cedb8028@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kirill Tkhai <ktkhai@virtuozzo.com>, g@suse.cz, kirill.shutemov@linux.intel.com
Cc: David Rientjes <rientjes@google.com>, Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.or, yang.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, stable@vger.kernel.org

On Fri 17-01-20 12:42:05, Kirill Tkhai wrote:
> On 17.01.2020 12:32, David Rientjes wrote:
> > On Fri, 17 Jan 2020, Kirill Tkhai wrote:
> > 
> >>>> I think that's a good point, especially considering that the current code 
> >>>> appears to unconditionally place any compound page on the deferred split 
> >>>> queue of the destination memcg.  The correct list that it should appear 
> >>>> on, I believe, depends on whether the pmd has been split for the process 
> >>>> being moved: note the MC_TARGET_PAGE caveat in 
> >>>> mem_cgroup_move_charge_pte_range() that does not move the charge for 
> >>>> compound pages with split pmds.  So when mem_cgroup_move_account() is 
> >>>> called with compound == true, we're moving the charge of the entire 
> >>>> compound page: why would it appear on that memcg's deferred split queue?
> >>>
> >>> I believe Kirill asked how do we know that the page should be actually
> >>> added to the deferred list just from the list_empty check. In other
> >>> words what if the page hasn't been split at all?
> >>
> >> Yes, I'm talking about this. Function mem_cgroup_move_account() adds every
> >> huge page to the deferred list, while we need to do that only for pages,
> >> which are queued for splitting...
> >>
> > 
> > Yup, and that appears broken before Wei's patch.  Since we only migrate 
> > charges of entire compound pages (we have a mapping pmd, the underlying 
> > page cannot be split), it should not appear on the deferred split queue 
> > for any memcg, right?
> 
> Hm. Can't a huge page be mapped in two tasks:

It can but it will get charged to only of the initially. I haven't
checked the THP code in that aspect but from what I remember subpages
shouldn't refer to different memcgs. Kirill Shutemov?
-- 
Michal Hocko
SUSE Labs
