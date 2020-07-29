From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v17 00/21] per memcg lru lock
Date: Wed, 29 Jul 2020 22:49:19 +0800
Message-ID: <c00ac587-7f69-768a-84ea-53cbf7469ae9@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <49d4f3bf-ccce-3c97-3a4c-f5cefe2d623a@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <49d4f3bf-ccce-3c97-3a4c-f5cefe2d623a-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org


Is there any comments or suggestion for this patchset?
Any hints will be very appreciated.

Thanks
Alex

在 2020/7/27 下午1:40, Alex Shi 写道:

> A standard for new page isolation steps like the following:
> 1, get_page(); #pin the page avoid be free
> 2, TestClearPageLRU(); #serialize other isolation, also memcg change
> 3, spin_lock on lru_lock; #serialize lru list access
> The step 2 could be optimzed/replaced in scenarios which page is unlikely
> be accessed by others.
> 
> 
> 
> 在 2020/7/25 下午8:59, Alex Shi 写道:
>> The new version which bases on v5.8-rc6. It includes Hugh Dickins fix in 
>> mm/swap.c and mm/mlock.c fix which Alexander Duyck pointed out, then
>> removes 'mm/mlock: reorder isolation sequence during munlock' 
>>
>> Hi Johanness & Hugh & Alexander & Willy,
>>
>> Could you like to give a reviewed by since you address much of issue and
>> give lots of suggestions! Many thanks!
