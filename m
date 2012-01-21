From: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH 1/3] idr: make idr_get_next() good for rcu_read_lock()
Date: Sat, 21 Jan 2012 12:43:02 -0800
Message-ID: <4F1B2356.4040302@xenotime.net>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils> <1326958401.1113.22.camel@edumazet-laptop> <CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com> <1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LSU.2.00.1201191235330.29542@eggly.anvils> <alpine.LSU.2.00.1201191247210.29542@eggly.anvils> <20120120154807.c55c9ac7.akpm@linux-foundation.org> <alpine.LSU.2.00.1201201922110.1396@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xenotime.net; s=default;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Subject:CC:To:MIME-Version:From:Date:Message-ID; bh=7bMKxmrBAHKQLODJxYds4eR6RtRP5WRiFiS9kzoW+sg=;
	b=bFmUIenXYshmBmpthR49bEZGAnGbm3WvsKXOAnxE40T2im79x5aGfFqIvGiknxHmb8S5a1/YUzLlfbMgp7is3ETN140GU4zpZk9gJv1fnYmfXid4RfOsdYGFYkZY8CO0;
In-Reply-To: <alpine.LSU.2.00.1201201922110.1396-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 01/20/2012 07:45 PM, Hugh Dickins wrote:
> On Fri, 20 Jan 2012, Andrew Morton wrote:
>> On Thu, 19 Jan 2012 12:48:48 -0800 (PST)
>> Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>> Copied comment on RCU locking from idr_find().
>>>
>>> + *
>>> + * This function can be called under rcu_read_lock(), given that the leaf
>>> + * pointers lifetimes are correctly managed.
>>
>> Awkward comment.  It translates to "..., because the leaf pointers
>> lifetimes are correctly managed".
>>
>> Is that what we really meant?  Or did we mean "..., provided the leaf
>> pointers lifetimes are correctly managed"?
> 
> You are right, and part of me realized that even as I copied in the
> comment.  I wanted to express the same optimism for idr_get_next() 
> as was already expressed for idr_find() - whatever it meant ;)
> 
> I thought it was meaning a bit of both: idr.c is managing its end well
> enough that rcu_read_lock() can now be used, but the caller has to
> manage their locking and lifetimes appropriately too.
> 
>>
>> Also, "pointers" should have been "pointer" or "pointer's"!
> 
> You're afraid of Linus turning his "its/it's" wrath from Al to yourself.
> 
> Since "lifetimes" is in the plural, I think it would have to be
> "pointers'" - I _think_ that's correct, rather than "pointers's".

That seems correct to me also.

> But then, it's not the lifetimes of the pointers, but the lifetimes
> of the objects that they point to, that's in question.  So what it
> ought to say is...
> 
> ... falls asleep.

ack.

and thanks for doing all of that radix tree test harness work, Hugh.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
