From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] memcg: Limit the number of events registered on
 oom_control
Date: Wed, 7 Aug 2013 09:47:41 -0400
Message-ID: <20130807134741.GF27006@htj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
 <20130807130836.GB27006@htj.dyndns.org>
 <20130807133746.GI8184@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Md6gEeAgeZRgs4d/P9huxj1dbDAE5n+8fSyfAcogIK8=;
        b=T6U4aIM5ZYnvwj4J1kYdMTQkPQq69qTY2YkCWpy7GQkdt0vEkYfjctZ7heNTskM8Uf
         2nGX7ziiICailQztCKI0weV78Y7fNccAPboHwzmhWuXwgVDFP+BLsYrozcrAszWpCYr4
         wF/jKwRSmEjRHBedCTYwp24ucn46kqtf0w9PgkDIXn8qqjPhibJDmjrs8t9pNGXJHFv7
         MQbMvXGVQmZbXfvxvRJcXdY+D4HXJQ2cobfYA7Tv1R0jjaysk8/oI24GjnraKKkbFua3
         9uE6ysnU7ed/Emu8s9LSPDkE4F0l/NKgX8ls5AcUNA0tsuWTUPwqIjqigQeatHyyAFeA
         pjXw==
Content-Disposition: inline
In-Reply-To: <20130807133746.GI8184@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Anton Vorontsov <anton.vorontsov@linaro.org>

Hello,

On Wed, Aug 07, 2013 at 03:37:46PM +0200, Michal Hocko wrote:
> > It isn't different from listening from epoll, for example.
> 
> epoll limits the number of watchers, no?

Not that I know of.  It'll be limited by max open fds but I don't
think there are other limits.  Why would there be?

> > If there needs to be kernel memory limit, shouldn't that be handled by
> > kmemcg?
> 
> kmemcg would surely help but turning it on just because of potential
> abuse of the event registration API sounds like an overkill.
> 
> I think having a cap for user trigable kernel resources is a good thing
> in general.

I don't know.  It's just very arbitrary because listening to events
itself isn't (and shouldn't) be something which consumes resource
which isn't attributed to the listener and this artificially creates a
global resource.  The problem with memory usage event is breaching
that rule with shared kmalloc() so putting well-defined limit on it is
fine but the latter two create additional artificial restrictions
which are both unnecessary and unconventional.  No?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
