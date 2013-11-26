From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [Devel] [PATCH v11 00/15] kmemcg shrinkers
Date: Tue, 26 Nov 2013 16:55:43 +0400
Message-ID: <52949A4F.7030004@parallels.com>
References: <cover.1385377616.git.vdavydov@parallels.com> <20131125174135.GE22729@cmpxchg.org> <529443E4.7080602@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <529443E4.7080602-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 11/26/2013 10:47 AM, Vladimir Davydov wrote:
> Hi,
>
> Thank you for the review. I agree with all your comments and I'll 
> resend the fixed version soon.
>
> If anyone still has something to say about the patchset, I'd be glad 
> to hear from them.
>
> On 11/25/2013 09:41 PM, Johannes Weiner wrote:
>> I ran out of steam reviewing these because there were too many things
>> that should be changed in the first couple patches.
>>
>> I realize this is frustrating to see these type of complaints in v11
>> of a patch series, but the review bandwidth was simply exceeded back
>> when Glauber submitted this along with the kmem accounting patches.  A
>> lot of the kmemcg commits themselves don't even have review tags or
>> acks, but it all got merged anyway, and the author has moved on to
>> different projects...
>>
>> Too much stuff slips past the only two people that have more than one
>> usecase on their agenda and are willing to maintain this code base -
>> which is in desparate need of rework and pushback against even more
>> drive-by feature dumps.  I have repeatedly asked to split the memcg
>> tree out of the memory tree to better deal with the vastly different
>> developmental stages of memcg and the rest of the mm code, to no
>> avail.  So I don't know what to do anymore, but this is not working.
>>
>> Thoughts?
>
> That's a pity, because w/o this patchset kmemcg is in fact useless. 
> Perhaps, it's worth trying to split it? (not sure if it'll help much 
> though since first 11 patches are rather essential :-( )

What do you think about splitting this set into two main series as follows:

1) Prepare vmscan to kmemcg-aware shrinkers; would include patches 1-7 
of this set.
2) Make fs shrinkers memcg-aware; would include patches 9-11 of this set

and leave other patches, which are rather for optimization/extending 
functionality, for future?

Thanks.
