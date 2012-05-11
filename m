From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
Date: Fri, 11 May 2012 14:09:15 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205111407280.386@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com> <alpine.DEB.2.00.1205111305570.386@router.home>
 <4FAD566C.3000804@parallels.com> <alpine.DEB.2.00.1205111316540.386@router.home> <4FAD585A.4070007@parallels.com> <alpine.DEB.2.00.1205111331010.386@router.home> <4FAD5DA2.70803@parallels.com> <alpine.DEB.2.00.1205111354540.386@router.home>
 <4FAD6169.8090409@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1336763359; bh=DJPzprHkxREodaS1nwhxWQnoTZRphutBEq/p1KK80xc=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=JwciYZKpFsjQVFsA6kF7WvnZN2TDXYGzttNs2Yhdxs+NxBLXygDMLMyKbayVL18Cx7Lbv3slXodrCJv4gERE1v/0aC3XoWzl4hs2tIh258A0CI1ch/KF9RmqHWNZqgRqX5UsjM4NKtkw3WM+hEhXGKLEATB0K4BpkGDDlhPam6U=
In-Reply-To: <4FAD6169.8090409@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, 11 May 2012, Glauber Costa wrote:

> On 05/11/2012 03:56 PM, Christoph Lameter wrote:
> > On Fri, 11 May 2012, Glauber Costa wrote:
> >
> > > So we don't mix pages from multiple memcgs in the same cache - we believe
> > > that
> > > would be too confusing.
> >
> > Well subsystem create caches and other things that are shared between
> > multiple processes. How can you track that?
>
> Each process that belongs to a memcg triggers the creation of a new child kmem
> cache.

I see that. But there are other subsystems from slab allocators that do
the same. There are also objects that may be used by multiple processes.
F.e what about shm?

> > > /proc/slabinfo reflects this information, by listing the memcg-specific
> > > slabs.
> >
> > What about /sys/kernel/slab/*?
>
> From the PoV of the global system, what you'll see is something like:
> dentry , dentry(2:memcg1), dentry(2:memcg2), etc.

Hmmm.. Would be better to have a hierachy there. /proc/slabinfo is more
legacy.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
