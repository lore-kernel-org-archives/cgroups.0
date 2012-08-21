From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Date: Tue, 21 Aug 2012 16:29:53 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1208211606580.2383@eggly.anvils>
References: <20120816174453.154143248@napanee.usersys.redhat.com> <20120816174454.087507415@napanee.usersys.redhat.com> <20120816200006.GG24861@google.com> <50340110.50607@redhat.com> <20120821214856.GC32596@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=5xtBItZC5Ukk/gwgnxv5z1yrIweIUh/ZLfuw6KQOv8Y=;
        b=Q25nq01V8tlXxjO3CP1d3J0V/1JuGjL+oTt9/+iMHrdOkf9zi5h9k4fnFG2o6CyDEh
         9ThB81Y/G+G8ooO4g9M0RRznvniRoHwr+C4/pL06o6szBo84dqQSjOeVgkx5qG+RKODI
         kwtz2WEJmH/nl7eEa4VIZ+Rw5SKEl3KgAaoZf0AVPgM+luPDvSKo2zAy/5+7IiuEEbVG
         sUw6I1PtOecGPbWYLRkwf/EAGlRjZbROYiai6mQkvy4cH2mu5oDWUShPcJVfEJxAdFZR
         C3pXwzUtjbDh/O/QsqDcytqV4eVOy5dZqu7y2y/pArBECHYmnWEw8uo8FkKPXJWVbtpF
         wIOQ==
In-Reply-To: <20120821214856.GC32596@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lennart Poettering <lpoetter@redhat.com>, aris@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Hillf Danton <dhillf@gmail.com>

On Tue, 21 Aug 2012, Tejun Heo wrote:
> On Tue, Aug 21, 2012 at 11:43:44PM +0200, Lennart Poettering wrote:
> > >I'm not against this but unsure whether using kmem is enough for the
> > >suggested use case.  Lennart, would this suit systemd?  How much
> > >metadata are we talking about?
> > 
> > Just small things, like values, PIDs, i.e. a few 100 bytes or so per
> > cgroup should be more than sufficient for our needs.

That is reasonable.

> 
> Alright, then.  I think there's gonna be one more round to address
> Hugh's comments.  Hugh, how should this be routed?  Is there some git
> branch that tmpfs changes can go in so that cgroup tree can pull?

No git tree, but we can easily handle it in one of two ways.

include/linux/shmem_fs.h and mm/shmem.c usually go to Linus from Andrew
from his mmotm tree (which includes and is included in linux-next,
by some magic escaping infinite recursion).

Are we expecting Aristeu+Zefan's simple_xattr patches to go into 3.7?
I don't have anything planned for shmem.c for 3.7 beyond a bugfix,
which shouldn't interact with the simple_xattr changes at all
(I could remove info->lock, but will not do so this time around,
precisely so as not to interfere with those patches).

So it should be perfectly workable for you to take Aristeu+Zefan's
shmem patches into your cgroup tree, then any further mods from
mmotm will get layered on top.

But if you prefer to leave shmem.c changes to Andrew, then it would
also be perfectly workable for Aristeu to split the 1/4 into two:
one for you which updates fs/xattr.c and include/linux/xattr.h with
simple_xattr code stolen from mm/shmem.c and include/linux/shmem_fs.h;
and one for Andrew which updates mm/shmem.c and include/linux/shmem_fs.h
to delete its shmem_xattr stuff and use simple_xattr interfaces instead.

Either approach is fine with me.

Hugh
