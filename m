From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 22/51] writeback: add {CONFIG|BDI_CAP|FS}_CGROUP_WRITEBACK
Date: Fri, 3 Jul 2015 12:49:57 +0200
Message-ID: <20150703104957.GH23329@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-23-git-send-email-tj@kernel.org>
 <20150630093751.GH7252@quack.suse.cz>
 <20150702011056.GC26440@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150702011056.GC26440@mtj.duckdns.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

On Wed 01-07-15 21:10:56, Tejun Heo wrote:
> Hello, Jan.
> 
> On Tue, Jun 30, 2015 at 11:37:51AM +0200, Jan Kara wrote:
> > Hum, you later changed this to use a per-sb flag instead of a per-fs-type
> > flag, right? We could do it as well here but OK.
> 
> The commits were already in stable branch at that point and landed in
> mainline during this merge window, so I'm afraid the review points
> will have to be addressed as additional patches.

Yeah, I know but I just didn't get to the series earlier. Anyway, I didn't
find fundamental issues so it's easy to change things in followup patches.

> > One more question - what does prevent us from supporting CGROUP_WRITEBACK
> > for all bdis capable of writeback? I guess the reason is that currently
> > blkcgs are bound to request_queue and we have to have blkcg(s) for
> > CGROUP_WRITEBACK to work, am I right? But in principle tracking writeback
> > state and doing writeback per memcg doesn't seem to be bound to any device
> > properties so we could do that right?
> 
> The main issue is that cgroup should somehow know how the processes
> are mapped to the underlying IO layer - the IO domain should somehow
> be defined.  We can introduce an intermediate abstraction which maps
> to blkcg and whatever other cgroup controllers which may define cgroup
> IO domains but given that such cases would be fairly niche, I think
> we'd be better off making those corner cases represent themselves
> using blkcg rather than introducing an additional layer.

Well, unless there is some specific mapping for the device, we could just
fall back to attributing everything to the root cgroup. We would still
account dirty pages in memcg, throttle writers in memcg when there are too
many dirty pages, issue writeback for inodes in memcg with enough dirty
pages etc. Just all IO from different memcgs would be equal so no
separation would be there. But it would still seem better that just
ignoring the split of dirty pages among memcgs as we do now... Thoughts?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
