From: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Mon, 3 Jun 2013 12:09:22 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1306031159060.7956@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com> <20130530150539.GA18155@dhcp22.suse.cz> <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com> <20130531081052.GA32491@dhcp22.suse.cz> <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz> <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com> <20130601102058.GA19474@dhcp22.suse.cz> <alpine.DEB.2.02.1306031102480.7956@chino.kir.corp.google.com> <20130603185433.GK15576@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=tQUeHBHgCs2iZ/wTVzD7c9/Uq1HCA4YBXFda9QlKbik=;
        b=G87IDARoRRs3e5ToM/sO6R9X44OV/T1amxWLI8F53Idh5kkA5GNbg+fDrXtvfFP3FA
         rg8i7YXUl+72d/bnfgwdKwloZvLtDLxCA3KC9QwRKrlOqPMuIe2rln6jK0WPtKtTOXAD
         BdzzICi0umo29SM/gV6mbbF2dVrN40No+M6w9y1iXk5tYyodw27JNpwtFGDgUKyNGOU+
         zuy9PzYWVIq0BgMbAPKt3I7hpC9Dz6fJWHxrwQgkMU+TeDe81Oy+3242ll6g02rNrPdD
         S+OhaCWrxd2gf+LUPTI7RsxkX5haDCWjb5YHyenfjJNJXe0KH9Sn0eBnwn3/4Blcu0qA
         nHtg==
In-Reply-To: <20130603185433.GK15576@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon, 3 Jun 2013, Johannes Weiner wrote:

> > It's not necessarily harder if you assign the userspace oom handlers to 
> > the root of your subtree with access to more memory than the children.  
> > There is no "inability" to write a proper handler, but when you have 
> > dozens of individual users implementing their own userspace handlers with 
> > changing memcg limits over time, then you might find it hard to have 
> > perfection every time.  If we had perfection, we wouldn't have to worry 
> > about oom in the first place.  We can't just let these gazillion memcgs 
> > sit spinning forever because they get stuck, either.  That's why we've 
> > used this solution for years as a failsafe.  Disabling the oom killer 
> > entirely, even for a memcg, is ridiculous, and if you don't have a grace 
> > period then oom handlers themselves just don't work.
> 
> It's only ridiculous if your OOM handler is subject to the OOM
> situation it's trying to handle.
> 

You're suggesting the oom handler can't be subject to its own memcg 
limits, independent of the memcg it is handling?  If we demand that such a 
handler be attached to the root memcg, that breaks the memory isolation 
that memcg provides.  We constrain processes to a memcg for the purposes 
of that isolation, so it cannot use more resources than allotted.

> Don't act as if the oom disabling semantics were unreasonable or
> inconsistent with the rest of the system, memcgs were not really meant
> to be self-policed by the tasks running in them.  That's why we have
> the waitqueue, so that everybody sits there and waits until an outside
> force resolves the situation.  There is nothing wrong with that, you
> just have a new requirement.
> 

The waitqueue doesn't solve anything with regard to the memory, if the 
memcg sits there and deadlocks forever then it is using resources (memory, 
not cpu) that will never be freed.

> > I'm talking about the memory the kernel allocates when reading the "tasks" 
> > file, not userspace.  This can, and will, return -ENOMEM.
> 
> Do you mean due to kmem limitations?
> 

Yes.

> What we could do is allow one task in the group to be the dedicated
> OOM handler.  If we catch this task in the charge path during an OOM
> situation, we fall back to the kernel OOM handler.
> 

I'm not sure it even makes sense to have more than one oom handler per 
memcg and the synchronization that requires in userspace to get the right 
result, so I didn't consider dedicating a single oom handler.  That would 
be an entirely new interface, though, since we may have multiple processes 
waiting on memory.oom_control that aren't necessarily handlers; they grab 
a snapshot of memory, do logging, etc.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
