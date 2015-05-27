From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 11/51] memcg: implement mem_cgroup_css_from_page()
Date: Wed, 27 May 2015 08:58:42 -0400
Message-ID: <20150527125842.GA19856@cmpxchg.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-12-git-send-email-tj@kernel.org>
 <20150522232831.GB6485@cmpxchg.org>
 <20150524212440.GD7099@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150524212440.GD7099-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Sun, May 24, 2015 at 05:24:40PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Fri, May 22, 2015 at 07:28:31PM -0400, Johannes Weiner wrote:
> > replace_page_cache() can clear page->mem_cgroup even when the page
> > still has references, so unfortunately you must hold the page lock
> > when calling this function.
> > 
> > I haven't checked how you use this - chances are you always have the
> > page locked anyways - but it probably needs a comment.
> 
> Hmmm... as replace_page_cache_page() is used only by fuse and fuse's
> bdi doesn't go through the usual writeback accounting which is
> necessary for cgroup writeback support anyway, so I don't think this
> presents an actual problem.  I'll add a warning in
> replace_page_cache_page() which triggers when it's used on a bdi which
> has cgroup writeback enabled and add comments explaining what's going
> on.

Okay, so that's no problem then as long as it's documented.

In the long term, it would probably still be a good idea to restore
the invariant that page->mem_cgroup never changes on live pages.  For
the old interface that ship has sailed as live pages can move around
different cgroups; in unified hierarchy, however, we currently only
move charges when migrating pages between page frames.  That can be
switched to duplicating the charge instead and leaving the old page
alone until the final put - which is expected to occur soon after.

Accounting the same page twice for a short period during migration
should be an acceptable trade-off when considering how much simpler it
makes the synchronization rules.  We only have to make sure to clearly
mark interfaces and functions that are only safe for use with unified
hierarchy code.
