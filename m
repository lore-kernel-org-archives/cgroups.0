From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 0/6] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Thu, 29 Aug 2019 09:18:07 +0200
Message-ID: <20190829071807.GR28313@dhcp22.suse.cz>
References: <20190826233240.11524-1-almasrymina@google.com>
 <20190828112340.GB7466@dhcp22.suse.cz>
 <CAHS8izPPhPoqh-J9LJ40NJUCbgTFS60oZNuDSHmgtMQiYw72RA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHS8izPPhPoqh-J9LJ40NJUCbgTFS60oZNuDSHmgtMQiYw72RA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>

[Cc cgroups maintainers]

On Wed 28-08-19 10:58:00, Mina Almasry wrote:
> On Wed, Aug 28, 2019 at 4:23 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 26-08-19 16:32:34, Mina Almasry wrote:
> > >  mm/hugetlb.c                                  | 493 ++++++++++++------
> > >  mm/hugetlb_cgroup.c                           | 187 +++++--
> >
> > This is a lot of changes to an already subtle code which hugetlb
> > reservations undoubly are.
> 
> For what it's worth, I think this patch series is a net decrease in
> the complexity of the reservation code, especially the region_*
> functions, which is where a lot of the complexity lies. I removed the
> race between region_del and region_{add|chg}, refactored the main
> logic into smaller code, moved common code to helpers and deleted the
> duplicates, and finally added lots of comments to the hard to
> understand pieces. I hope that when folks review the changes they will
> see that! :)

Post those improvements as standalone patches and sell them as
improvements. We can talk about the net additional complexity of the
controller much easier then.

> > Moreover cgroupv1 is feature frozen and I am
> > not aware of any plans to port the controller to v2.
> 
> Also for what it's worth, if porting the controller to v2 is a
> requisite to take this, I'm happy to do that. As far as I understand
> there is no reason hugetlb_cgroups shouldn't be in cgroups v2, and we
> see value in them.

Talk to cgroups maintainers why the hugegetlb controller hasn't been
enabled in v2. All I am saing is that v1 only features are really a hard
sell. Even without adding a lot of code to hugetlb which is quite
complex on its own.
-- 
Michal Hocko
SUSE Labs
