From: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Thu, 27 Oct 2022 15:46:07 +0530
Message-ID: <5a6c29f9-1154-03af-c22e-55108feb155f@linux.ibm.com>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
 <Y1jpDfwBQId3GkJC@feng-clx> <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
 <d17698d2-c1b5-9aa3-6271-838830d36cc5@linux.ibm.com>
 <Y1kTz1qjfsY1UBPf@dhcp22.suse.cz>
 <44e485d4-acf5-865d-17fe-13be1c1b430b@linux.ibm.com>
 <Y1kmOaXvzwRv/tza@dhcp22.suse.cz>
 <22590f74-ec91-e673-32df-8a04b4ab3931@linux.ibm.com>
 <Y1pJG+d+kXJgjNMc@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f4tgvmYBFxXfft5Mybi5Aij8o0xpC0kpuLEaSBc9Rwo=;
 b=Uy7twgmedret5C+/JjPRsw88hU2t6zdgfhd08a45v9wczvIigEiYoh8HW4vls42ifOnP
 pS8M9bVWznY7Mn6wYQmd16gk6arS0EvS3jm9VVVWLkAnfNsWuo2z00iprObiqFKDjmxY
 drgZBU3rMg5xOjocfHX5tF95LfI34zpLRYmlwmF1zw9G3On0hdi5DBYl8vXzOh8G+QYx
 +JfpADeBpbT70bknNYwsZ1fCC8zFNkqoUVzwmQH38yRpsR8tpo3aR24MGIHxQ2Z0C+6f
 mx/u14bH5oWBVHmVTrP8MchrsPokhVqSHYe9H9Tk6q2UPHGGwj3Md3RlENsBTzeoWUhd Ag== 
Content-Language: en-US
In-Reply-To: <Y1pJG+d+kXJgjNMc-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 10/27/22 2:32 PM, Michal Hocko wrote:

>>
>> Sorry, I meant MAP_ANONYMOUS | MAP_SHARED. 
> 
> I am still not sure where you are targeting to be honest. MAP_SHARED or
> MAP_PRIVATE both can have page shared between several vmas.


What I was checking was w.r.t demotion and shared pages do we need to
cross-check all the related memory policies? On the page fault side, we don't do that.
ie, if the vma policy or the faulting task policy allowed pages to be allocated
from the demotion node, then we allocate the page even if there is a conflicting
policy from another thread. 

For ex: in the case of MAP_ANON | MAP_PRIVATE cow shared pages if the parent 
did allow allocation from the demotion node we can have pages in the demotion node
even though the child memory policy doesn't have the node in the node mask.

-aneesh
