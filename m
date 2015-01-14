From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 2/2] mm: memcontrol: default hierarchy interface for
 memory
Date: Wed, 14 Jan 2015 11:01:01 -0500
Message-ID: <20150114160101.GA30018__38852.9386641041$1421251291$gmane$org@phnom.home.cmpxchg.org>
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
 <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
 <xr93a91mz2s7.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <xr93a91mz2s7.fsf@gthelen.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 03:20:08PM -0800, Greg Thelen wrote:
> 
> On Thu, Jan 08 2015, Johannes Weiner wrote:
> 
> > Introduce the basic control files to account, partition, and limit
> > memory using cgroups in default hierarchy mode.
> >
> > This interface versioning allows us to address fundamental design
> > issues in the existing memory cgroup interface, further explained
> > below.  The old interface will be maintained indefinitely, but a
> > clearer model and improved workload performance should encourage
> > existing users to switch over to the new one eventually.
> >
> > The control files are thus:
> >
> >   - memory.current shows the current consumption of the cgroup and its
> >     descendants, in bytes.
> >
> >   - memory.low configures the lower end of the cgroup's expected
> >     memory consumption range.  The kernel considers memory below that
> >     boundary to be a reserve - the minimum that the workload needs in
> >     order to make forward progress - and generally avoids reclaiming
> >     it, unless there is an imminent risk of entering an OOM situation.
> 
> So this is try-hard, but no-promises interface.  No complaints.  But I
> assume that an eventual extension is a more rigid memory.min which
> specifies a minimum working set under which an container would prefer an
> oom kill to thrashing.

Yes, memory.min would nicely complement memory.max and I wouldn't be
opposed to adding it.  However, that does require at least some level
of cgroup-awareness in the global OOM killer in order to route kills
meaningfully according to cgroup configuration, which is mainly why I
deferred it in this patch.
