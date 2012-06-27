From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: unify mem_control_xxx to memcg_xxx
Date: Wed, 27 Jun 2012 13:00:20 +0400
Message-ID: <4FEACBA4.10202@parallels.com>
References: <1340756175-3420-1-git-send-email-liwp.linux@gmail.com> <4FEAC7C6.7030601@parallels.com> <20120627085917.GA5683@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120627085917.GA5683-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/27/2012 12:59 PM, Michal Hocko wrote:
> On Wed 27-06-12 12:43:50, Glauber Costa wrote:
>> On 06/27/2012 04:16 AM, Wanpeng Li wrote:
>>> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>
>>> Changelog:
>>>
>>> V2 -> V1:
>>>
>>> * replace memory_cgroup_xxx by memcg_xxx
>>>
>>> Unify memcg functions to memcg_xxx.
>>
>>
>> This patch achieves nothing.
>> You're changing a couple of function names. Andrew stated goal was
>> to change *all* function names from mem_cgroup_xxx to memcg_xxx, not
>> just one or two.
>
> No mass things now, please.
> git grep mem_cgroup_ mm/ include/ | wc -l
> 863
>
> This will be real pain for merging.
>
It's either that, or I have my new functions named memcg_ and we live 
with the inconsistency.

Point is, changing one function name as he did, achieves nothing.

