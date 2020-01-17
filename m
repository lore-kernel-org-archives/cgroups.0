From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
Date: Fri, 17 Jan 2020 12:42:05 +0300
Message-ID: <11ba0af7-c2b2-83f9-ac55-7793cedb8028@virtuozzo.com>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
 <20200117091002.GM19428@dhcp22.suse.cz>
 <b67fe2bb-e7a6-29fe-925e-dd1ae176cc4b@virtuozzo.com>
 <alpine.DEB.2.21.2001170132090.20618@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.21.2001170132090.20618-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 17.01.2020 12:32, David Rientjes wrote:
> On Fri, 17 Jan 2020, Kirill Tkhai wrote:
> 
>>>> I think that's a good point, especially considering that the current code 
>>>> appears to unconditionally place any compound page on the deferred split 
>>>> queue of the destination memcg.  The correct list that it should appear 
>>>> on, I believe, depends on whether the pmd has been split for the process 
>>>> being moved: note the MC_TARGET_PAGE caveat in 
>>>> mem_cgroup_move_charge_pte_range() that does not move the charge for 
>>>> compound pages with split pmds.  So when mem_cgroup_move_account() is 
>>>> called with compound == true, we're moving the charge of the entire 
>>>> compound page: why would it appear on that memcg's deferred split queue?
>>>
>>> I believe Kirill asked how do we know that the page should be actually
>>> added to the deferred list just from the list_empty check. In other
>>> words what if the page hasn't been split at all?
>>
>> Yes, I'm talking about this. Function mem_cgroup_move_account() adds every
>> huge page to the deferred list, while we need to do that only for pages,
>> which are queued for splitting...
>>
> 
> Yup, and that appears broken before Wei's patch.  Since we only migrate 
> charges of entire compound pages (we have a mapping pmd, the underlying 
> page cannot be split), it should not appear on the deferred split queue 
> for any memcg, right?

Hm. Can't a huge page be mapped in two tasks:

1)the first task unmapped a part of page and initiated splitting,
2)the second task still refers the whole page,

then we move account for the second task?
