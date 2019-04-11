From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 0/2] mm/memcontrol: Finer-grained memory control
Date: Thu, 11 Apr 2019 17:24:15 +0200
Message-ID: <20190411152415.GA10383@dhcp22.suse.cz>
References: <20190410191321.9527-1-longman@redhat.com>
 <20190410195443.GL10383@dhcp22.suse.cz>
 <daef5f22-0bc2-a637-fa3d-833205623fb6@redhat.com>
 <20190411151911.GZ10383@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190411151911.GZ10383@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Aaron Lu <aaron.lu@intel.com>

On Thu 11-04-19 17:19:11, Michal Hocko wrote:
> On Thu 11-04-19 10:02:16, Waiman Long wrote:
> > On 04/10/2019 03:54 PM, Michal Hocko wrote:
> > > On Wed 10-04-19 15:13:19, Waiman Long wrote:
> > >> The current control mechanism for memory cgroup v2 lumps all the memory
> > >> together irrespective of the type of memory objects. However, there
> > >> are cases where users may have more concern about one type of memory
> > >> usage than the others.
> > >>
> > >> We have customer request to limit memory consumption on anonymous memory
> > >> only as they said the feature was available in other OSes like Solaris.
> > > Please be more specific about a usecase.
> > 
> > From that customer's point of view, page cache is more like common goods
> > that can typically be shared by a number of different groups. Depending
> > on which groups touch the pages first, it is possible that most of those
> > pages can be disproportionately attributed to one group than the others.
> > Anonymous memory, on the other hand, are not shared and so can more
> > correctly represent the memory footprint of an application. Of course,
> > there are certainly cases where an application can have large private
> > files that can consume a lot of cache pages. These are probably not the
> > case for the applications used by that customer.
> 
> So you are essentially interested in the page cache limiting, right?
> This has been proposed several times already and always rejected because
> this is not a good idea.

OK, so after reading other responses I've realized that I've
misunderstood your intention. You are really interested in the anon
memory limiting. But my objection still holds! I would like to hear much
more specific usecases. Is the page cache such a precious resource it
cannot be refaulted? With the storage speed these days I am quite not
sure. Also there is always way to delegate page cache pre-faulting to a
dedicated cgroup with a low limit protection if _some_ pagecache is
really important.

-- 
Michal Hocko
SUSE Labs
