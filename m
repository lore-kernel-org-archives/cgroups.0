From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Wed, 11 Feb 2015 08:32:27 +0100
Message-ID: <20150211073227.GB30939@quack.suse.cz>
References: <20150204170656.GA18858@htj.dyndns.org>
 <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com>
 <20150205131514.GD25736@htj.dyndns.org>
 <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
 <20150205222522.GA10580@htj.dyndns.org>
 <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
 <20150206141746.GB10580@htj.dyndns.org>
 <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
 <20150207143839.GA9926@htj.dyndns.org>
 <20150211021906.GA21356@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150211021906.GA21356-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

  Hello Tejun,

On Tue 10-02-15 21:19:06, Tejun Heo wrote:
> On Sat, Feb 07, 2015 at 09:38:39AM -0500, Tejun Heo wrote:
> > If we can argue that memcg and blkcg having different views is
> > meaningful and characterize and justify the behaviors stemming from
> > the deviation, sure, that'd be fine, but I don't think we have that as
> > of now.
...
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
  I like this proposal. It looks simple enough and when inodes aren't
pernamently write-shared it converges to the blkcg that is currently
writing to the inode. So ack from me.

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
