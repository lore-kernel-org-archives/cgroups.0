From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v3 00/28] kmem limitation for memcg
Date: Thu, 7 Jun 2012 16:00:45 +0200
Message-ID: <20120607140037.GG19842@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <20120607102604.GE19842@somewhere.redhat.com>
 <4FD08813.9070307@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=d3RqelBplTHLne/QCqWK2dYINlcfXzBjn2rlhnwHCVE=;
        b=oDzBBemolFo+0tUqbJsxzxUccJElTcTiqjykQ7f8WHrzP4cESTtvgY/hJjEgkB4VDK
         ZtII4TS5Lfqwksn6xmW10uFtHzTUYqffzS3EpsLUwO0nbT8qS60ZFn+XwlGQ50xzPz2e
         5XINiEXo5FAvQ0FqlEPOWUoxCS1ZLYYWQGlplDIiLSAFTsWVb9iRGcBclEHJl8Mtn1GL
         2Bb1VRo2LkiiEm9oremC6XlxCHQFF7Z+e2mXwahg+9jozL9Lbp46e7DODEcG8FgFUVbR
         mV8aKsOo4Vf54kekPrT0fOYwBQPLVp9erhnfUC6oyVK5WWLB6xW9EcjeU5ra64X3dywH
         nHnQ==
Content-Disposition: inline
In-Reply-To: <4FD08813.9070307@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, David Rientjes <rientjes@google.com>

On Thu, Jun 07, 2012 at 02:53:07PM +0400, Glauber Costa wrote:
> On 06/07/2012 02:26 PM, Frederic Weisbecker wrote:
> >On Fri, May 25, 2012 at 05:03:20PM +0400, Glauber Costa wrote:
> >>Hello All,
> >>
> >>This is my new take for the memcg kmem accounting. This should merge
> >>all of the previous comments from you, plus fix a bunch of bugs.
> >>
> >>At this point, I consider the series pretty mature. Since last submission
> >>2 weeks ago, I focused on broadening the testing coverage. Some bugs were
> >>fixed, but that of course doesn't mean no bugs exist.
> >>
> >>I believe some of the early patches here are already in some trees around.
> >>I don't know who should pick this, so if everyone agrees with what's in here,
> >>please just ack them and tell me which tree I should aim for (-mm? Hocko's?)
> >>and I'll rebase it.
> >>
> >>I should point out again that most, if not all, of the code in the caches
> >>are wrapped in static_key areas, meaning they will be completely patched out
> >>until the first limit is set. Enabling and disabling of static_keys incorporate
> >>the last fixes for sock memcg, and should be pretty robust.
> >>
> >>I also put a lot of effort, as you will all see, in the proper separation
> >>of the patches, so the review process is made as easy as the complexity of
> >>the work allows to.
> >
> >So I believe that if I want to implement a per kernel stack accounting/limitation,
> >I need to work on top of your patchset.
> >
> >What do you think about having some sub kmem accounting based on the caches?
> >For example there could be a specific accounting per kmem cache.
> >
> >Like if we use a specific kmem cache to allocate the kernel stack
> >(as is done by some archs but I can generalize that for those who want
> >kernel stack accounting), allocations are accounted globally in the memcg as
> >done in your patchset but also on a seperate counter only for this kmem cache
> >on the memcg, resulting in a kmem.stack.usage somewhere.
> >
> >The concept of per kmem cache accounting can be expanded more for any
> >kind of finegrained kmem accounting.
> >
> >Thoughts?
> 
> I believe a general separation is too much, and will lead to knob
> explosion. So I don't think it is a good idea.

Right. This could be an option in kmem_cache_create() or something.

> 
> Now, for the stack itself, it can be justified. The question that
> remains to be answered is:
> 
> Why do you need to set the stack value separately? Isn't accounting
> the stack value, and limiting against the global kmem limit enough?

Well, I may want to let my container have a full access to some kmem
resources (net, file, etc...) but defend against fork bombs or NR_PROC
rlimit exhaustion of other containers.

So I need to be able to set my limit precisely on kstack.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
