From: Tejun Heo <tj@kernel.org>
Subject: Re: [LSF/MM TOPIC][ATTEND] Improving async io, specifically
 io_submit latencies
Date: Fri, 1 Mar 2013 08:20:38 -0800
Message-ID: <20130301162038.GA2481@mtj.dyndns.org>
References: <512FB91B.80102@suse.de>
 <20130228210318.GA3762@google.com>
 <x49k3pr2mcs.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=GDqKyElWjSEr+Dx+JrkO4NrKqsTYIV7kV+HBnbY6+10=;
        b=FE3Uz6Ok4i59qruinHAojVzpYsL+I8iYSJw80nSs8cUuoX2zOMKbZkkC6xVf8UiZjy
         NgRsYOtmSqiAvHWASgl/oDw03ipIF0cgNOdu3SaimEiMZENqYc9qI3XKptdSEIjYIwOT
         eKMDLyohkDZt9Vu0P3Zo6V1ApM8NIgwaDvRDe1DpquHDWbDwDXrqc4MnUyLRgXd54627
         ujYppcFmSFqp20/+9ABelRlWYEVLqq9wR9cCEqcXoNJNh5BYc3eTdIX9595IuEPrdzDC
         WgJD1oraEGqAIFf0vOEjDzsW22/Bm3ee8qOjBUg9IgrXp+RFclpNpCqFVOAtH7aeC7ir
         Latw==
Content-Disposition: inline
In-Reply-To: <x49k3pr2mcs.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, Ankit Jain <jankit@suse.de>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Zach Brown <zab@zabbo.net>, tytso@mit.edu, Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

(cc'ing Li and cgroups ML)

Hey, guys.

On Fri, Mar 01, 2013 at 10:03:47AM -0500, Jeff Moyer wrote:
> > This is even worse when a filesystem is involved and metadata operations
> > get stuck at the end of a huge queue.  By punting everything to
> > workqueue, all that's been accomplished is to hide the queueing and
> > shove it up a layer.
> 
> Slightly different issue there, but no need to hash it out in this
> thread.  One thing I do agree with is that, when you punt I/O to a
> workqueue, you lose the ability to account that I/O to the proper
> process.

Block layer now supports tagging bio's with the issuer's identity.

  int bio_associate_current(struct bio *bio);
  void bio_disassociate_task(struct bio *bio);

After bio_associate_current() is performed on a bio, block layer will
treat the bio as if it's being issued by the %current at the time of
association no matter which task ends up doing the actual submission
in terms of ioctx and blkcg.

Async IO handling of blkcg is still uttrely broken so it isn't as
useful at this point yet tho.

> > A similar problem exists with kernel memory usage, but it's even worse
> > there because most users aren't using memcg. If we're short on memery,
> > the processing doing aio really needs to be throttled in io_submit() ->
> > get_user_pages(); if it's punting everything to workqueue, now the other
> > processes may have to compete against 1000 worker threads calling
> > get_user_pages() simultaneously instead of just the process doing aio.
> 
> Right, this hits on the inability to track the i/o to the original
> submitting process.  I thought we had a plan to fix that (and I have
> some really old patches for this that I never quite finished).  Tejun?
> Jens?

For IO, I think bio tagging should be able to handle most of it,
eventually.  For memory, ultimately, we want the workqueue tasks to be
able to assume the resource role of the work item issuer.  Associating
dynamically is nasty given the variety of cgroups - e.g. there might
not be any common CPUs between the allowed sets to the workqueue and
the issuer, so I'm unsure whether we can reach a general solution;
however, workqueue is currently growing worker pools with custom
attributes which will eventually cover cgroup association and we can
use that for specific problem areas - ie. create a matching workqueue
for each aio context (the backed pool is shared so the overhead isn't
big).

One obstacle there is we currently don't have a way to say "this
workqueue belongs to this cgroup" as there is no "this" cgroup defined
(awesome design).  That part is being rectified but for the time being
we can probably say "this workqueue belongs to the same cgroups as
%current" which should be enough for aio contexts, I think.

Thanks.

-- 
tejun
