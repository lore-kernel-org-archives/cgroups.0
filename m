From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm: thp: grab the lock before manipulation defer list
Date: Tue, 7 Jan 2020 09:38:08 +0100
Message-ID: <20200107083808.GC32178@dhcp22.suse.cz>
References: <20200103143407.1089-1-richardw.yang@linux.intel.com>
 <20200106102345.GE12699@dhcp22.suse.cz>
 <20200107012241.GA15341@richard>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200107012241.GA15341@richard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, yang.shi@linux.alibaba.com

On Tue 07-01-20 09:22:41, Wei Yang wrote:
> On Mon, Jan 06, 2020 at 11:23:45AM +0100, Michal Hocko wrote:
> >On Fri 03-01-20 22:34:07, Wei Yang wrote:
> >> As all the other places, we grab the lock before manipulate the defer list.
> >> Current implementation may face a race condition.
> >
> >Please always make sure to describe the effect of the change. Why a racy
> >list_empty check matters?
> >
> 
> Hmm... access the list without proper lock leads to many bad behaviors.

My point is that the changelog should describe that bad behavior.

> For example, if we grab the lock after checking list_empty, the page may
> already be removed from list in split_huge_page_list. And then list_del_init
> would trigger bug.

And how does list_empty check under the lock guarantee that the page is
on the deferred list?
-- 
Michal Hocko
SUSE Labs
