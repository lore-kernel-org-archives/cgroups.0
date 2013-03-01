From: Tejun Heo <tj@kernel.org>
Subject: Re: [LSF/MM TOPIC][ATTEND] Improving async io, specifically
 io_submit latencies
Date: Fri, 1 Mar 2013 08:31:21 -0800
Message-ID: <20130301163121.GB2481@mtj.dyndns.org>
References: <512FB91B.80102@suse.de>
 <20130228210318.GA3762@google.com>
 <x49k3pr2mcs.fsf@segfault.boston.devel.redhat.com>
 <20130301162038.GA2481@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=tOqZJC7AutsiALH8+8O/X+6/4okrJNGcbVDHoEWK3Y0=;
        b=D1b1fK7Kz6mXXZLguN5QR8JdD8gd4mu+JEappffuSSgLoQQ8qUA6DABCARTrdjDp0d
         rKQ1Uq1pbWsWy88tUx3SGKFG1U4XD+pJ7D4cNgDLaxjL6HBjnxQ5GFbIek39id9ajdI8
         UJmFOvCYrVTZvxrr40BEFKB20B41kl5NZhqme6+F+jJEE0pr3uAwlJFoZ4y2w9g98ayX
         Cbd0tYxpvMBNtE7Jmpak18Tfm+mjRO5O6xJg4JTaNvuJij2ap8UZdcyt5+AlO4/uhe+W
         iQf+RcC2EY6YO3HmZ+8/QV8TJeL5k8q/JBKHUBdt7eubWqHwfoGATsTEs1K0d7afJUuk
         fBdw==
Content-Disposition: inline
In-Reply-To: <20130301162038.GA2481@mtj.dyndns.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, Ankit Jain <jankit@suse.de>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Zach Brown <zab@zabbo.net>, tytso@mit.edu, Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

On Fri, Mar 01, 2013 at 08:20:38AM -0800, Tejun Heo wrote:
> One obstacle there is we currently don't have a way to say "this
> workqueue belongs to this cgroup" as there is no "this" cgroup defined
> (awesome design).  That part is being rectified but for the time being
> we can probably say "this workqueue belongs to the same cgroups as
> %current" which should be enough for aio contexts, I think.

Or maybe we should just add current->wq which always matches cgroup
associations of the task?

-- 
tejun
