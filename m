From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Wed, 11 Feb 2015 10:28:44 -0800
Message-ID: <CAHH2K0aHM=jmzbgkSCdFX0NxWbHBcVXqi3EAr0MS-gE3Txk93w@mail.gmail.com>
References: <CAHH2K0aSPjNgt30uJQa_6r=AXZso3SitjWOm96dtJF32CumZjQ@mail.gmail.com>
 <20150204170656.GA18858@htj.dyndns.org> <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com>
 <20150205131514.GD25736@htj.dyndns.org> <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
 <20150205222522.GA10580@htj.dyndns.org> <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
 <20150206141746.GB10580@htj.dyndns.org> <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
 <20150207143839.GA9926@htj.dyndns.org> <20150211021906.GA21356@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=RTpw5O3+7qxZxAEv5nOA31kq8218yoRN2oIY1+/8kL0=;
        b=lcRVjqlHFxOFDFj+4/SbQP3j+yZWgwrkJMI6cfP5waRuzsTD/QiL5nVqs52+irpGcC
         H7IYxoshCpBpcrUX5OKztozQLk0q1PIvoW86gqd7vQ9RVND9hgiOtKQtqSSYmWYPMkBS
         vh+Nc4PhYo+TAgjf3IdWQ+uzLWS2k0Un1ptwNSw4vBWPmeQRBfNeDlCb+2190QmUuOMW
         oE7sFRMGpEwG3lqhVP2+HzHvGGhd6XgJtRry7gpqf4Sy2r0PNVP/5PU6wnasGtmX6U0D
         6XC1zn55Yr47IPPJ5SkJOQo2lSsUChhbMlQuVJ2Jw2n88dW3ntGApXmHemGcXHZ/R8Cn
         faRQ==
In-Reply-To: <20150211021906.GA21356-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Feb 10, 2015 at 6:19 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, again.
>
> On Sat, Feb 07, 2015 at 09:38:39AM -0500, Tejun Heo wrote:
>> If we can argue that memcg and blkcg having different views is
>> meaningful and characterize and justify the behaviors stemming from
>> the deviation, sure, that'd be fine, but I don't think we have that as
>> of now.
>
> If we assume that memcg and blkcg having different views is something
> which represents an acceptable compromise considering the use cases
> and implementation convenience - IOW, if we assume that read-sharing
> is something which can happen regularly while write sharing is a
> corner case and that while not completely correct the existing
> self-corrective behavior from tracking ownership per-page at the point
> of instantiation is good enough (as a memcg under pressure is likely
> to give up shared pages to be re-instantiated by another sharer w/
> more budget), we need to do the impedance matching between memcg and
> blkcg at the writeback layer.
>
> The main issue there is that the last chain of IO pressure propagation
> is realized by making individual dirtying tasks to converge on a
> common target dirty ratio point which naturally depending on those
> tasks seeing the same picture in terms of the current write bandwidth
> and available memory and how much of it is dirty.  Tasks dirtying
> pages belonging to the same memcg while some of them are mostly being
> written out by a different blkcg would wreck the mechanism.  It won't
> be difficult for one subset to make the other to consider themselves
> under severe IO pressure when there actually isn't one in that group
> possibly stalling and starving those tasks unduly.  At more basic
> level, it's just wrong for one group to be writing out significant
> amount for another.
>
> These issues can persist indefinitely if we follow the same
> instantiator-owns rule for inode writebacks.  Even if we reset the
> ownership when an inode becomes clea, it wouldn't work as it can be
> dirtied over and over again while under writeback, and when things
> like this happen, the behavior may become extremely difficult to
> understand or characterize.  We don't have visibility into how
> individual pages of an inode get distributed across multiple cgroups,
> who's currently responsible for writing back a specific inode or how
> dirty ratio mechanism is behaving in the face of the unexpected
> combination of parameters.
>
> Even if we assume that write sharing is a fringe case, we need
> something better than first-whatever rule when choosing which blkcg is
> responsible for writing a shared inode out.  There needs to be a
> constant corrective pressure so that incidental and temporary sharings
> don't end up screwing up the mechanism for an extended period of time.
>
> Greg mentioned chossing the closest ancestor of the sharers, which
> basically pushes inode sharing policy implmentation down to writeback
> from memcg.  This could work but we end up with the same collusion
> problem as when this is used for memcg and it's even more difficult to
> solve this at writeback layer - we'd have to communicate the shared
> state all the way down to block layer and then implement a mechanism
> there to take corrective measures and even after that we're likely to
> end up with prolonged state where dirty ratio propagation is
> essentially broken as the dirtier and writer would be seeing different
> pictures.
>
> So, based on the assumption that write sharings are mostly incidental
> and temporary (ie. we're basically declaring that we don't support
> persistent write sharing), how about something like the following?
>
> 1. memcg contiues per-page tracking.
>
> 2. Each inode is associated with a single blkcg at a given time and
>    written out by that blkcg.
>
> 3. While writing back, if the number of pages from foreign memcg's is
>    higher than certain ratio of total written pages, the inode is
>    marked as disowned and the writeback instance is optionally
>    terminated early.  e.g. if the ratio of foreign pages is over 50%
>    after writing out the number of pages matching 5s worth of write
>    bandwidth for the bdi, mark the inode as disowned.
>
> 4. On the following dirtying of the inode, the inode is associated
>    with the matching blkcg of the dirtied page.  Note that this could
>    be the next cycle as the inode could already have been marked dirty
>    by the time the above condition triggered.  In that case, the
>    following writeback would be terminated early too.
>
> This should provide sufficient corrective pressure so that incidental
> and temporary sharing of an inode doesn't become a persistent issue
> while keeping the complexity necessary for implementing such pressure
> fairly minimal and self-contained.  Also, the changes necessary for
> individual filesystems would be minimal.
>
> I think this should work well enough as long as the forementioned
> assumptions are true - IOW, if we maintain that write sharing is
> unsupported.
>
> What do you think?
>
> Thanks.
>
> --
> tejun

This seems good.  I assume that blkcg writeback would query
corresponding memcg for dirty page count to determine if over
background limit.  And balance_dirty_pages() would query memcg's dirty
page count to throttle based on blkcg's bandwidth.  Note: memcg
doesn't yet have dirty page counts, but several of us have made
attempts at adding the counters.  And it shouldn't be hard to get them
merged.
