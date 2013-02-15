From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 0/7] memcg targeted shrinking
Date: Fri, 15 Feb 2013 14:42:02 +0400
Message-ID: <511E10FA.2040708@parallels.com>
References: <1360328857-28070-1-git-send-email-glommer@parallels.com> <xr93ip5unz52.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr93ip5unz52.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Dave Shrinnker <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 02/15/2013 05:28 AM, Greg Thelen wrote:
> On Fri, Feb 08 2013, Glauber Costa wrote:
> 
>> This patchset implements targeted shrinking for memcg when kmem limits are
>> present. So far, we've been accounting kernel objects but failing allocations
>> when short of memory. This is because our only option would be to call the
>> global shrinker, depleting objects from all caches and breaking isolation.
>>
>> This patchset builds upon the recent work from David Chinner
>> (http://oss.sgi.com/archives/xfs/2012-11/msg00643.html) to implement NUMA
>> aware per-node LRUs. I build heavily on its API, and its presence is implied.
>>
>> The main idea is to associate per-memcg lists with each of the LRUs. The main
>> LRU still provides a single entry point and when adding or removing an element
>> from the LRU, we use the page information to figure out which memcg it belongs
>> to and relay it to the right list.
>>
>> This patchset is still not perfect, and some uses cases still need to be
>> dealt with. But I wanted to get this out in the open sooner rather than
>> later. In particular, I have the following (noncomprehensive) todo list:
>>
>> TODO:
>> * shrink dead memcgs when global pressure kicks in.
>> * balance global reclaim among memcgs.
>> * improve testing and reliability (I am still seeing some stalls in some cases)
> 
> Do you have a git tree with these changes so I can see Dave's numa LRUs
> plus these changes?
> 
I've just uploaded the exact same thing I have sent here to:

  git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg.git

The branch is kmemcg-lru-shrinker. Note that there is also another
branch kmemcg-shrinker that contains some other simple patches that were
not yet taken and are more stable. I eventually have to merge the two.

I also still need to incorporate the feedback from you and Kame into
that. I will be traveling until next Wednesday, so expect changes in
there around Thursday.
