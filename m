From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3 00/28] kmem limitation for memcg
Date: Tue, 29 May 2012 10:07:39 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205290955270.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <20120525133441.GB30527@tiehlicka.suse.cz> <alpine.DEB.2.00.1205250933170.22597@router.home> <4FC3381C.9020608@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338304063; bh=uB2jMa1nZc+aXSAqCHSvYMz880P/+sgPwaSB6qce8NE=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=LSyvzVqZsRkTCc5YWzFekrycEPKQs/dIprwRxc1A/QUzXLDVSqW5bkZfvOj9cnDvvaA42ImboFeS+Io72PH4N8imA809ud1zta6lAZSr3BN5dsEUlLuuPGqiKgUQLZ8DNkcKrKt2TEEVE99asHiFY9bbKOUTmaPOcWj4XFzxWl4=
In-Reply-To: <4FC3381C.9020608@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>

On Mon, 28 May 2012, Glauber Costa wrote:

> > It would be best to merge these with my patchset to extract common code
> > from the allocators. The modifications of individual slab allocators would
> > then be not necessary anymore and it would save us a lot of work.
> >
> Some of them would not, some of them would still be. But also please note that
> the patches here that deal with differences between allocators are usually the
> low hanging fruits compared to the rest.
>
> I agree that long term it not only better, but inevitable, if we are going to
> merge both.
>
> But right now, I think we should agree with the implementation itself - so if
> you have any comments on how I am handling these, I'd be happy to hear. Then
> we can probably set up a tree that does both, or get your patches merged and
> I'll rebase, etc.

Just looked over the patchset and its quite intrusive. I have never been
fond of cgroups (IMHO hardware needs to be partitioned at physical
boundaries) so I have not too much insight into what is going on in that
area.

The idea to just duplicate the caches leads to some weird stuff like the
refcounting and the recovery of the arguments used during slab creation.

I think it may be simplest to only account for the pages used by a slab in
a memcg. That code could be added to the functions in the slab allocators
that interface with the page allocators. Those are not that performance
critical and would do not much harm.

If you need per object accounting then the cleanest solution would be to
duplicate the per node arrays per memcg (or only the statistics) and have
the kmem_cache structure only once in memory.

Its best if information is only in one place for design and for performance.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
