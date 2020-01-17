From: David Rientjes <rientjes@google.com>
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer
 list
Date: Fri, 17 Jan 2020 01:32:58 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001170132090.20618@chino.kir.corp.google.com>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com> <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com> <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com> <20200117091002.GM19428@dhcp22.suse.cz>
 <b67fe2bb-e7a6-29fe-925e-dd1ae176cc4b@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=p0FYXrhY0dK2Yq0ADqbuALXVIqL3DOBXcQh5lESagqw=;
        b=TF9fXgaUP4k4EAUC/Dy/SrOzwDt7ThZAFl1RiO2a29ruRoatv9IVB/khL4saK8kRVr
         jmQulM0N9UWJo1tVbMtZSwfUOSeBO82sunl63tNxOn9BFdV+BcFNIApGC+7vEbF5JCs/
         sFX4nSxwdD66o0jnSZQb+cuxIhTNSgQPJw+NbD6Yp2tQePUHbGgagbNBt9loJ1etUD8y
         ju0tJkK2IpWUyY0tP+T6wcrO6lkabPJHh0jysu0L3AYYtHptfY8IDpWqeHAFxNNvJ2PP
         2UZyeAiwnjYi/RrtKRf8YgfE3/Mwr3ec4ZhjQSrEwi+CGDiEwax83iA9qESUsmFSl9lm
         BKcw==
In-Reply-To: <b67fe2bb-e7a6-29fe-925e-dd1ae176cc4b@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, stable@vger.kernel.org

On Fri, 17 Jan 2020, Kirill Tkhai wrote:

> >> I think that's a good point, especially considering that the current code 
> >> appears to unconditionally place any compound page on the deferred split 
> >> queue of the destination memcg.  The correct list that it should appear 
> >> on, I believe, depends on whether the pmd has been split for the process 
> >> being moved: note the MC_TARGET_PAGE caveat in 
> >> mem_cgroup_move_charge_pte_range() that does not move the charge for 
> >> compound pages with split pmds.  So when mem_cgroup_move_account() is 
> >> called with compound == true, we're moving the charge of the entire 
> >> compound page: why would it appear on that memcg's deferred split queue?
> > 
> > I believe Kirill asked how do we know that the page should be actually
> > added to the deferred list just from the list_empty check. In other
> > words what if the page hasn't been split at all?
> 
> Yes, I'm talking about this. Function mem_cgroup_move_account() adds every
> huge page to the deferred list, while we need to do that only for pages,
> which are queued for splitting...
> 

Yup, and that appears broken before Wei's patch.  Since we only migrate 
charges of entire compound pages (we have a mapping pmd, the underlying 
page cannot be split), it should not appear on the deferred split queue 
for any memcg, right?
