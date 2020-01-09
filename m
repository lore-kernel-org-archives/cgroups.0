From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm: thp: grab the lock before manipulation defer list
Date: Thu, 9 Jan 2020 09:34:38 +0100
Message-ID: <20200109083438.GG4951@dhcp22.suse.cz>
References: <20200103143407.1089-1-richardw.yang@linux.intel.com>
 <20200106102345.GE12699@dhcp22.suse.cz>
 <20200107012241.GA15341@richard>
 <20200107083808.GC32178@dhcp22.suse.cz>
 <20200108003543.GA13943@richard>
 <20200108094041.GQ32178@dhcp22.suse.cz>
 <20200109020319.GB31041@richard>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200109020319.GB31041@richard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, yang.shi@linux.alibaba.com

On Thu 09-01-20 10:03:19, Wei Yang wrote:
> On Wed, Jan 08, 2020 at 10:40:41AM +0100, Michal Hocko wrote:
[...]
> >Moreover, look at the code you are trying to fix. Sure extending the
> >locking seem straightforward but does it result in a correct code
> >though? See my question in the previous email. How do we know that the
> >page is actually enqued in a non-empty list?
> 
> I may not get your point for the last sentence.
> 
> The list_empty() doesn't check the queue is empty but check the list, here is
> the page, is not enqueued into any list. Is this your concern?

My bad. For some reason I have misread the code and thought this was
get_deferred_split_queue rather than page_deferred_list. Sorry about the
confusion.
-- 
Michal Hocko
SUSE Labs
