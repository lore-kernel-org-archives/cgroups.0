From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 44/51] writeback: implement bdi_wait_for_completion()
Date: Fri, 3 Jul 2015 14:36:42 +0200
Message-ID: <20150703123642.GL23329@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-45-git-send-email-tj@kernel.org>
 <20150701160437.GG7252@quack.suse.cz>
 <20150702030624.GM26440@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150702030624.GM26440@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

On Wed 01-07-15 23:06:24, Tejun Heo wrote:
> Hello, Jan.
> 
> On Wed, Jul 01, 2015 at 06:04:37PM +0200, Jan Kara wrote:
> > I'd find it better to extend completions to allow doing what you need. It
> > isn't that special. It seems it would be enough to implement
> > 
> > void wait_for_completions(struct completion *x, int n);
> > 
> > where @n is the number of completions to wait for. And the implementation
> > can stay as is, only in do_wait_for_common() we change checks for x->done ==
> > 0 to "x->done < n". That's about it...
> 
> I don't know.  While I agree that it'd be nice to have a generic event
> count & trigger mechanism in the kernel, I don't think extending
> completion is a good idea - the count then works both ways as the
> event counter && listener counter and effectively becomes a semaphore
> which usually doesn't end well.  There are very few cases where we
> want the counter works both ways and I personally think we'd be far
> better served if those rare cases implement something custom rather
> than generic mechanism becoming cryptic trying to cover everything.

Let me phrase my objection this differently: Instead of implementing custom
synchronization mechanism, you could as well do:

int count_submitted;	/* Number of submitted works we want to wait for */
struct completion done;
...
submit works with 'done' as completion.
...
while (count_submitted--)
	wait_for_completion(&done);

And we could also easily optimize that loop and put it in
kernel/sched/completion.c. The less synchronization mechanisms we have the
better I'd think...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
