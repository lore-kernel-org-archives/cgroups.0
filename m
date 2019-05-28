From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 0/7] mm: reparent slab memory on cgroup removal
Date: Tue, 28 May 2019 09:01:28 +0200
Message-ID: <20190528070128.GM1658@dhcp22.suse.cz>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190522214347.GA10082@tower.DHCP.thefacebook.com>
 <20190522145906.60c9e70ac0ed7ee3918a124c@linux-foundation.org>
 <20190522222254.GA5700@castle>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190522222254.GA5700@castle>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Waiman Long <longman@redhat.com>

On Wed 22-05-19 22:23:01, Roman Gushchin wrote:
> On Wed, May 22, 2019 at 02:59:06PM -0700, Andrew Morton wrote:
> > On Wed, 22 May 2019 21:43:54 +0000 Roman Gushchin <guro@fb.com> wrote:
> > 
> > > Is this patchset good to go? Or do you have any remaining concerns?
> > > 
> > > It has been carefully reviewed by Shakeel; and also Christoph and Waiman
> > > gave some attention to it.
> > > 
> > > Since commit 172b06c32b94 ("mm: slowly shrink slabs with a relatively")
> > > has been reverted, the memcg "leak" problem is open again, and I've heard
> > > from several independent people and companies that it's a real problem
> > > for them. So it will be nice to close it asap.
> > > 
> > > I suspect that the fix is too heavy for stable, unfortunately.
> > > 
> > > Please, let me know if you have any issues that preventing you
> > > from pulling it into the tree.
> > 
> > I looked, and put it on ice for a while, hoping to hear from
> > mhocko/hannes.  Did they look at the earlier versions?
> 
> Johannes has definitely looked at one of early versions of the patchset,
> and one of the outcomes was his own patchset about pushing memcg stats
> up by the tree, which eliminated the need to deal with memcg stats
> on kmem_cache reparenting.
> 
> The problem and the proposed solution have been discussed on latest LSFMM,
> and I didn't hear any opposition. So I assume that Michal is at least
> not against the idea in general. A careful code review is always welcome,
> of course.

I didn't get to review this properly (ETOOBUSY). This is a tricky area
so a careful review is definitely due. I would really appreciate if
Vladimir could have a look. I understand he is busy with other stuff but
a highlevel review from him would be really helpful.
-- 
Michal Hocko
SUSE Labs
