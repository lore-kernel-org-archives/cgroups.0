From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm, memcg: add oom killer delay
Date: Mon, 3 Jun 2013 21:31:47 +0200
Message-ID: <20130603193147.GC23659@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
 <20130601102058.GA19474@dhcp22.suse.cz>
 <alpine.DEB.2.02.1306031102480.7956@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HUjry6SWERFa5NqdosWkfi2+JRq5iItfcdtyLN8fDSM=;
        b=MrVse/+ZoLrQS/5M3hIekCsytCgtfiUsBZ5ttQJnlHlq5rhXcYKpxMNeegwODiPDpc
         MpBbjaFvMzBpNa3gVlo3inldjH7vQhrYnt5XmKzOxdxSFdVvXi4AGj3USNuK/vi99K8z
         AffKOZ5krv5NHmaB/10qnQRGWEswAlqJptwbG5L/Rb6TD6Tz5RLeM6rH80YTq41jjd9v
         vpr3upx0r5AxaHliaktx3lkMdZRvoyyVDsfLp7A3+CRBNIeaqUPAtKaUXd6KB4wHmDFx
         lFo13w8j8NUwczEe+zhZt+11VavK8f5094thVp/wU+RIZ9cPuilqZbysT5YYL+yBeIhO
         bREg==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306031102480.7956@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon 03-06-13 11:18:09, David Rientjes wrote:
> On Sat, 1 Jun 2013, Michal Hocko wrote:
[...]
> > I still do not see why you cannot simply read tasks file into a
> > preallocated buffer. This would be few pages even for thousands of pids.
> > You do not have to track processes as they come and go.
> > 
> 
> What do you suggest when you read the "tasks" file and it returns -ENOMEM 
> because kmalloc() fails because the userspace oom handler's memcg is also 
> oom? 

That would require that you track kernel allocations which is currently
done only for explicit caches.

> Obviously it's not a situation we want to get into, but unless you 
> know that handler's exact memory usage across multiple versions, nothing 
> else is sharing that memcg, and it's a perfect implementation, you can't 
> guarantee it.  We need to address real world problems that occur in 
> practice.

If you really need to have such a guarantee then you can have a _global_
watchdog observing oom_control of all groups that provide such a vague
requirements for oom user handlers.

> > As I said before. oom_delay_millisecs is actually really easy to be done
> > from userspace. If you really need a safety break then you can register
> > such a handler as a fallback. I am not familiar with eventfd internals
> > much but I guess that multiple handlers are possible. The fallback might
> > be enforeced by the admin (when a new group is created) or by the
> > container itself. Would something like this work for your use case?
> > 
> 
> You're suggesting another userspace process that solely waits for a set 
> duration and then reenables the oom killer?

Yes which kicks the oom killer.

> It faces all the same problems as the true userspace oom handler: it's
> own perfect implementation and it's own memcg constraints.

But that solution might be implemented as a global policy living in a
group with some reservations.

[...]
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
