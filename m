From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 03/13] memcg: Uncharge all kmem when deleting a cgroup.
Date: Wed, 14 Mar 2012 15:59:28 +0400
Message-ID: <4F608820.8080006@parallels.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org> <1331325556-16447-4-git-send-email-ssouhlal@FreeBSD.org> <4F5C602B.4050806@parallels.com> <CABCjUKBUQ7QS-pJbzrN=8_AFj20uP+dgOH44AWfK4ZecpprybA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CABCjUKBUQ7QS-pJbzrN=8_AFj20uP+dgOH44AWfK4ZecpprybA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <suleiman@google.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, cl@linux.com, yinghan@google.com, hughd@google.com, gthelen@google.com, peterz@infradead.org, dan.magenheimer@oracle.com, hannes@cmpxchg.org, mgorman@suse.de, James.Bottomley@hansenpartnership.com, linux-mm@kvack.org, devel@openvz.org, linux-kernel@vger.kernel.org


>>> @@ -3719,6 +3721,8 @@ move_account:
>>>                 /* This is for making all *used* pages to be on LRU. */
>>>                 lru_add_drain_all();
>>>                 drain_all_stock_sync(memcg);
>>> +               if (!free_all)
>>> +                       memcg_kmem_move(memcg);
>>
>> Any reason we're not moving kmem charges when free_all is set as well?
>
> Because the slab moving code expects to be synchronized with
> allocations (and itself). We can't call it when there are still tasks
> in the cgroup.

Ok.

Please add an explanation about that.
Oh boy, reading it all now, I started to believe that "free_all" is a 
really poor name =(


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
