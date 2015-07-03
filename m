From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 28/51] writeback, blkcg: restructure
 blk_{set|clear}_queue_congested()
Date: Fri, 3 Jul 2015 14:16:11 +0200
Message-ID: <20150703121611.GI23329@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-29-git-send-email-tj@kernel.org>
 <20150630150254.GN7252@quack.suse.cz>
 <20150702013815.GE26440@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150702013815.GE26440-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Wed 01-07-15 21:38:15, Tejun Heo wrote:
> Hello, Jan.
> 
> On Tue, Jun 30, 2015 at 05:02:54PM +0200, Jan Kara wrote:
> > BTW, I'd prefer if this was merged with the following patch. I was
> > wondering for a while about the condition at the beginning of
> > blk_clear_congested() only to learn it gets modified to the one I'd expect
> > in the following patch :)
> 
> The patches are already merged, it's a bit too late to discuss but I
> usually try to keep each step quite granular.  e.g. I try hard to
> avoid combining code relocation / restructuring with actual functional
> changes so that the code change A -> B -> C where B is functionally
> identical to A and C is different from B only where the actual
> functional changes occur.

Yeah, I didn't mean this comment as something you should change even if the
series wasn't applied yet (it isn't that bad). I meant it more as a
feedback for future.
 
> I think your argument is that as C is the final form, introducing B is
> actually harder for reviewing.  I have to disagree with that pretty
> strongly.  When you only think about the functional transformations A
> -> C might seem easier but given that we also want to verify the
> changes - both during development and review - it's far more
> beneficial to go through the intermediate stage as that isolates
> functional changes from mere code transformation.
>
> Another thing to consider is that there's a difference when one is
> reviewing a patch series as a whole tracking the development of big
> picture and later when somebody tries to debug or bisect a bug the
> patchset introduces.  At that point, the general larger flow isn't
> really in the picture and combining structural and functional changes
> may make understanding what's going on significantly harder in
> addition to making such errors more likely and less detectable in the
> first place.

In general I agree with you - separating refactoring from functional
changes is useful. I just think you took it a bit to the extreme in this
series :) When I'm reviewing patches, I'm also checking whether the
function does what it's "supposed" to do. So in case of splitting patches
like this I have to go through the series and verify that in the end we end
up with what one would expect. And sometimes the correctness is so much
easier to verify when changes are split that the extra patch chasing is
worth it.  But in simple cases like this one, merged patch would have been
easier for me. I guess it's a matter of taste...

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
