From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Possible mem cgroup bug in kernels between 4.18.0 and 5.3-rc1.
Date: Fri, 2 Aug 2019 15:40:21 +0200
Message-ID: <20190802134021.GJ6461@dhcp22.suse.cz>
References: <20190802121059.13192-1-hdanton@sina.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190802121059.13192-1-hdanton@sina.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton@sina.com>
Cc: Masoud Sharbiani <msharbiani@apple.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>

On Fri 02-08-19 20:10:58, Hillf Danton wrote:
> 
> On Fri, 2 Aug 2019 16:18:40 +0800 Michal Hocko wrote:
[...]
> > Huh, what? You are effectively saying that we should fail the charge
> > when the requested nr_pages would fit in. This doesn't make much sense
> > to me. What are you trying to achive here?
> 
> The report looks like the result of a tight loop.
> I want to break it and make the end result of do_page_fault unsuccessful
> if nr_retries rounds of page reclaiming fail to get work done. What made
> me a bit over stretched is how to determine if the chargee is a memhog
> in memcg's vocabulary.
> What I prefer here is that do_page_fault succeeds, even if the chargee
> exhausts its memory quota/budget granted, as long as more than nr_pages
> can be reclaimed _within_ nr_retries rounds. IOW the deadline for memhog
> is nr_retries, and no more.

No, this really doesn't really make sense because it leads to pre-mature
charge failures. The charge path is funadamentally not different from
the page allocator path. We do try to reclaim and retry the allocation.
We keep retrying for ever for non-costly order requests in both cases
(modulo some corner cases like oom victims etc.).
-- 
Michal Hocko
SUSE Labs
