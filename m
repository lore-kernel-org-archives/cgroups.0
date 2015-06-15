From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 3/3] writeback, blkio: add documentation for cgroup
 writeback support
Date: Mon, 15 Jun 2015 19:35:19 -0400
Message-ID: <20150615233519.GB30059@thunk.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
 <1434146254-26220-4-git-send-email-tj@kernel.org>
 <20150615172823.GA5783@redhat.com>
 <20150615182345.GB18517@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org; s=ef5046eb;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=4fPmbttVS111I7Tph9Dh6MUzU7mYct6r33isZewDDJE=;
	b=O2U4rBZ7SR+vtIArWodXzjp6kkNj/LjcjjPCS1SrXeW2Wh9DvuRZxJNCuY5dcp7w5Ef20g8Ad5H5hrHOo+1zecSASmYWAHCtDEEC6umlXZKJ8V7OjwWYAsHRk2J0aGbbKD1rP6o3gt0ObioMnpLrLzt2NLAioYI10SyjqGDVPXo=;
Content-Disposition: inline
In-Reply-To: <20150615182345.GB18517-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 15, 2015 at 02:23:45PM -0400, Tejun Heo wrote:
> 
> On ext2, there's nothing interlocking each other.  My understanding of
> ext4 is pretty limited but as long as the journal head doesn't
> overwrap and gets bloked on the slow one, it should be fine, so for
> most use cases, this shouldn't be a problem.

The writes to the journal in ext3/ext4 are done from the jbd/jbd2
kernel thread.  So writes to the journal shouldn't be a problem.  In
data=ordered mode inodes that have blocks that were allocated during
the current transaction do have to have their data blocks written out,
and this is done by the jbd/jbd2 thread using filemap_fdatawait().

If this gets throttled because blocks were originally dirtied by some
cgroup that didn't have much disk time quota, then all file system
activities will get stalled out until the ordered mode writeback
completes, which means if there are any high priority cgroups trying
to execute any system call that mutates file system state will block
until the commit has gotten past the initial setup stage, and so other
system activity could sputter to a halt --- at which point the commit
will be allowed to compete, and then all of the calls to
ext4_journal_start() will unblock, and the system will come back to
life.  :-)

Because ext3 doesn't have delayed allocation, it will orders of
magnitude more data=ordered block flushing, so this problem will be
far worse with ext3 compared to ext4.

So if there is some way we can signal to any cgroup that that might be
throttling writeback or disk I/O that the jbd/jbd2 process should be
considered privileged, that would be a good since it would allow us to
avoid a potential priority inversion problem. 

						- Ted
