From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] doc: cgroup: update note about conditions when oom
 killer is invoked
Date: Mon, 11 May 2020 12:13:22 +0200
Message-ID: <20200511101322.GE29153@dhcp22.suse.cz>
References: <158894738928.208854.5244393925922074518.stgit@buzz>
 <20200511083904.GB29153@dhcp22.suse.cz>
 <0ddb8e58-5bfd-7754-6979-4276acf5b4c8@yandex-team.ru>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0ddb8e58-5bfd-7754-6979-4276acf5b4c8@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Mon 11-05-20 12:34:00, Konstantin Khlebnikov wrote:
> 
> 
> On 11/05/2020 11.39, Michal Hocko wrote:
> > On Fri 08-05-20 17:16:29, Konstantin Khlebnikov wrote:
> > > Starting from v4.19 commit 29ef680ae7c2 ("memcg, oom: move out_of_memory
> > > back to the charge path") cgroup oom killer is no longer invoked only from
> > > page faults. Now it implements the same semantics as global OOM killer:
> > > allocation context invokes OOM killer and keeps retrying until success.
> > > 
> > > Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > 
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > 
> > > ---
> > >   Documentation/admin-guide/cgroup-v2.rst |   17 ++++++++---------
> > >   1 file changed, 8 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > > index bcc80269bb6a..1bb9a8f6ebe1 100644
> > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > @@ -1172,6 +1172,13 @@ PAGE_SIZE multiple when read back.
> > >   	Under certain circumstances, the usage may go over the limit
> > >   	temporarily.
> > > +	In default configuration regular 0-order allocation always
> > > +	succeed unless OOM killer choose current task as a victim.
> > > +
> > > +	Some kinds of allocations don't invoke the OOM killer.
> > > +	Caller could retry them differently, return into userspace
> > > +	as -ENOMEM or silently ignore in cases like disk readahead.
> > 
> > I would probably add -EFAULT but the less error codes we document the
> > better.
> 
> Yeah, EFAULT was a most obscure result of memory shortage.
> Fortunately with new behaviour this shouldn't happens a lot.

Yes, it shouldn't really happen very often. gup was the most prominent
example but this one should be taken care of by triggering the OOM
killer. But I wouldn't bet my hat there are no potential cases anymore.

> Actually where it is still possible? THP always fallback to 0-order.
> I mean EFAULT could appear inside kernel only if task is killed so
> nobody would see it.

Yes fatal_signal_pending paths are ok. And no I do not have any specific
examples. But as you've said EFAULT was a real surprise so I thought it
would be nice to still keep a reference for it around. Even when it is
unlikely.

-- 
Michal Hocko
SUSE Labs
