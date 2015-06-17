From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 3/3] writeback, blkio: add documentation for cgroup
 writeback support
Date: Wed, 17 Jun 2015 17:48:52 -0400
Message-ID: <20150617214852.GE4076@thunk.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
 <1434146254-26220-4-git-send-email-tj@kernel.org>
 <20150615172823.GA5783@redhat.com>
 <20150615182345.GB18517@mtj.duckdns.org>
 <20150615233519.GB30059@thunk.org>
 <20150616215436.GE22637@mtj.duckdns.org>
 <20150617031540.GB4076@thunk.org>
 <20150617185237.GL22637@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org; s=ef5046eb;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=jTM+MS4JUXSnXklQHEqPzhxamesENTecK5xDscvL0sE=;
	b=JhAivyilqnYYcvXyKo4EP9/3e3QEHd0hF/ojvQ1CKt6YDCE9xPPMBj1flXc9z83M6Ee+8dlAcdgZmHYFuDSGCpAKhjTQm9WJni2w8Wu9Pphrd8EFwAhMRsE4szNS2zHufMb9I4rOxAwDXXC8/jCt0NjDoXgYChWu1IhPgKM4cos=;
Content-Disposition: inline
In-Reply-To: <20150617185237.GL22637-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 17, 2015 at 02:52:37PM -0400, Tejun Heo wrote:
> 
> Hmmm... so, overriding things *before* an bio is issued shouldn't be
> too difficult and as long as this sort of operations aren't prevalent
> we might be able to get away with just charging them against root.
> Especially if it's to avoid getting blocked on the journal which we
> already consider a shared overhead which is charged to root.  If this
> becomes large enough to require exacting charges, it'll be more
> complex but still way better than trying to raise priority on a bio
> which is already issued, which is likely to be excruciatingly painful
> if possible at all.

Yeah, just charging the overhead to root seems good enough.

I could imagine charging it to whatever cgroup the jbd/jbd2 thread
belongs to, which in turn would be the cgroup of the process that
mounted the file system.  The only problem with that is that if a
low-priority process is allowed to mount a file system, and it gets
traversed by a high priority process, the high priority process will
get impacted.  So maybe it's better to just say that it always get
charged to the root cgroup.

					- Ted
