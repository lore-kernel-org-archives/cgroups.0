From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
Date: Thu, 16 Aug 2012 13:57:07 +0400
Message-ID: <502CC3F3.5060706@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-7-git-send-email-glommer@parallels.com> <20120814172540.GD6905@dhcp22.suse.cz> <502B6F00.8040207@parallels.com> <20120815130952.GI23985@dhcp22.suse.cz> <502BABCF.7020608@parallels.com> <20120815142338.GL23985@dhcp22.suse.cz> <502BB1E1.5080403@parallels.com> <20120816095309.GB2817@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120816095309.GB2817-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On 08/16/2012 01:53 PM, Michal Hocko wrote:
> On Wed 15-08-12 18:27:45, Glauber Costa wrote:
>>
>>>>
>>>> I see now, you seem to be right.
>>>
>>> No I am not because it seems that I am really blind these days...
>>> We were doing this in mem_cgroup_do_charge for ages:
>>> 	if (!(gfp_mask & __GFP_WAIT))
>>>                 return CHARGE_WOULDBLOCK;
>>>
>>> /me goes to hide and get with further feedback with a clean head.
>>>
>>> Sorry about that.
>>>
>> I am as well, since I went to look at mem_cgroup_do_charge() and missed
>> that.
> 
> I thought we are not doing atomic allocations in user pages accounting
> but I was obviously wrong because at least shmem uses atomic
> allocations for ages.
> 
>> Do you have any other concerns specific to this patch ?
> 
> I understood you changed also handle thingy. So the patch should be
> correct.
> Do you plan to send an updated version?
> 
That depends more on you than on me! =)

Do you still have any concerns regarding the u+k charging as it stands
now? That would be the last big concern I heard during this iteration.

If you are happy with the answers you got so far, and believe it is
acceptable to proceed with the charging this way, I will be ready to
send an updated version soon.

