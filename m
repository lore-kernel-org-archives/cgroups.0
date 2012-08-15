From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
Date: Wed, 15 Aug 2012 19:35:13 +0400
Message-ID: <502BC1B1.3010807@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-5-git-send-email-glommer@parallels.com> <20120814162144.GC6905@dhcp22.suse.cz> <502B6D03.1080804@parallels.com> <20120815123931.GF23985@dhcp22.suse.cz> <000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com> <502BBC35.809@parallels.com> <000001392aec1926-72b3a631-1fb1-460c-803d-38c4405151e1-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000001392aec1926-72b3a631-1fb1-460c-803d-38c4405151e1-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 08/15/2012 07:34 PM, Christoph Lameter wrote:
> On Wed, 15 Aug 2012, Glauber Costa wrote:
> 
>> On 08/15/2012 06:47 PM, Christoph Lameter wrote:
>>> On Wed, 15 Aug 2012, Michal Hocko wrote:
>>>
>>>>> That is not what the kernel does, in general. We assume that if he wants
>>>>> that memory and we can serve it, we should. Also, not all kernel memory
>>>>> is unreclaimable. We can shrink the slabs, for instance. Ying Han
>>>>> claims she has patches for that already...
>>>>
>>>> Are those patches somewhere around?
>>>
>>> You can already shrink the reclaimable slabs (dentries / inodes) via
>>> calls to the subsystem specific shrinkers. Did Ying Han do anything to
>>> go beyond that?
>>>
>> That is not enough for us.
>> We would like to make sure that the objects being discarded belong to
>> the memcg which is under pressure. We don't need to be perfect here, and
>> an occasional slip is totally fine. But if in general, shrinking from
>> memcg A will mostly wipe out objects from memcg B, we harmed the system
>> in return for nothing good.
> 
> How can you figure out which objects belong to which memcg? The ownerships
> of dentries and inodes is a dubious concept already.
> 

Remember we copy over the metadata and create copies of the caches
per-memcg. Therefore, a dentry belongs to a memcg if it was allocated
from the slab pertaining to that memcg.

It is not 100 % accurate, but it is good enough.
