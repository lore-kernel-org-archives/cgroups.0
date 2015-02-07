From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Sat, 7 Feb 2015 09:38:39 -0500
Message-ID: <20150207143839.GA9926@htj.dyndns.org>
References: <20150202194608.GA8169@htj.dyndns.org>
 <CAHH2K0aSPjNgt30uJQa_6r=AXZso3SitjWOm96dtJF32CumZjQ@mail.gmail.com>
 <20150204170656.GA18858@htj.dyndns.org>
 <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com>
 <20150205131514.GD25736@htj.dyndns.org>
 <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
 <20150205222522.GA10580@htj.dyndns.org>
 <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
 <20150206141746.GB10580@htj.dyndns.org>
 <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NYquaWCHLZA9qnVohjRc3xeKvRqdHkIzbN5wHTwMnRI=;
        b=bjwW8kYmLOy+SmYHt20cConHlqVu8LyAJftTRjwNC6k1FxO4RmGSkaeIWbhtyFJsJN
         7Ow2DXYU+jyLI4PKgF+6p9/tMo6eBZDsu/BqXVPd7kLQm+FpPwUcB5Sc1yzDvtaTrqMv
         zXPZqc1S3YmdTYizDkZ6xVjbtmNtzEBvQ8v1YMMzKwuLrkjdlistEYOF4MyrU0l/s2tC
         3VTstnseR90vU0j0kAXP54ivw1pY832nRBtr5+LPGTjOdOZbLprMjzejrfxB3QMAxXzG
         f4sKvr2JeMTi8Imq+22gNsWUNt5fQk4Fiutn2tMGutBwPRV6A+1mK0Y6GJQLb0YfTBrW
         7nVg==
Content-Disposition: inline
In-Reply-To: <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Greg.

On Fri, Feb 06, 2015 at 03:43:11PM -0800, Greg Thelen wrote:
> If cgroups are about isolation then writing to shared files should be
> rare, so I'm willing to say that we don't need to handle shared
> writers well.  Shared readers seem like a more valuable use cases
> (thin provisioning).  I'm getting overwhelmed with the thought
> exercise of automatically moving inodes to common ancestors and back
> charging the sharers for shared_usage.  I haven't wrapped my head
> around how these shared data pages will get protected.  It seems like
> they'd no longer be protected by child min watermarks.

Yes, this is challenging and what my current thought is around taking
the maximum of the low settings of the sharing children but I need to
think more about it.  One problem is that the shared inodes will
preemptively take away the amount shared from the children's low
protection.  They won't compete fairly with other inodes or anons but
they can't really as they don't really belong to any single sharer.

> So I know this thread opened with the claim "both memcg and blkcg must
> be looking at the same picture.  Deviating them is highly likely to
> lead to long-term issues forcing us to look at this again anyway, only
> with far more baggage."  But I'm still wondering if the following is
> simpler:
> (1) leave memcg as a per page controller.
> (2) maintain a per inode i_memcg which is set to the common dirtying
> ancestor.  If not shared then it'll point to the memcg that the page
> was charged to.
> (3) when memcg dirtying page pressure is seen, walk up the cgroup tree
> writing dirty inodes, this will write shared inodes using blkcg
> priority of the respective levels.
> (4) background limit wb_check_background_flush() and time based
> wb_check_old_data_flush() can feel free to attack shared inodes to
> hopefully restore them to non-shared state.
> For non-shared inodes, this should behave the same.  For shared inodes
> it should only affect those in the hierarchy which is sharing.

The thing which breaks when you de-couple what memcg sees from the
rest of the stack is that the amount of memory which may be available
to a given cgroup and how much of that is dirty is the main linkage
propagating IO pressure to actual dirtying tasks.  If you decouple the
two worldviews, you lose the ability to propagate IO pressure to
dirtiers in a controlled manner and that's why anything inside a memcg
currently is always triggering direct reclaim path instead of being
properly dirty throttled.

You can argue that an inode being actively dirtied from multiple
cgroups is a rare case which we can sweep under the rug and that
*might* be the case but I have a nagging feeling that that would be a
decision which is made merely out of immediate convenience and would
much prefer having a well defined model of sharing inodes and anons
across cgroups so that the behaviors shown in thoses cases aren't mere
accidental consequences without any innate meaning.

If we can argue that memcg and blkcg having different views is
meaningful and characterize and justify the behaviors stemming from
the deviation, sure, that'd be fine, but I don't think we have that as
of now.

Thanks.

-- 
tejun
