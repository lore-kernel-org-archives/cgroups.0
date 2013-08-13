From: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [RFC] kmemcg: remove union from memcg_params
Date: Tue, 13 Aug 2013 08:53:48 +0400
Message-ID: <CANaxB-zdt69+db0pprMEwmxhDRGprk9SwS0+ZCwhNqGTrxxKmQ@mail.gmail.com>
References: <1375995086-15456-1-git-send-email-avagin@openvz.org>
	<20130812152812.915d5e8ebe5467586a457eb0@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=rZiyXe55vLde1tHbK4qVXZAFsMcziDVL3I+EeS6Ane4=;
        b=uprAHgjiTohHD8vPoRUbgILFMLf7AoqTQNW/ohbF7ylojVxeehTqzuLdO1AQGyToj9
         ez0eH66Ii8807z5AdG9PhMRAr9BaIn2ikTkWRcCNno51MqHNI0bfue7IU59VIX8Aqw9o
         64KwaHTd4n72QpxWiLWd/HaLrh+sErVRTLpdH/afZWbw5/Rben6gFyzge7tgUvUKvoKy
         SQ39mUkrPQlTntreR+UB9f2hEkzTID3rpA9MtmenG7dMvzfDqss+u11Xx75KyR0+swsH
         GODpP3jikSXsSxxyaT/Jo4UwKTNxGlcTorRbovZGmRdAsWhDix5HrAS/d6L4SlSzIcTZ
         o6aA==
In-Reply-To: <20130812152812.915d5e8ebe5467586a457eb0-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

2013/8/13 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>:
> On Fri,  9 Aug 2013 00:51:26 +0400 Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>
>> struct memcg_cache_params {
>>         bool is_root_cache;
>>         union {
>>                 struct kmem_cache *memcg_caches[0];
>>                 struct {
>>                         struct mem_cgroup *memcg;
>>                         struct list_head list;
>>                         struct kmem_cache *root_cache;
>>                         bool dead;
>>                         atomic_t nr_pages;
>>                         struct work_struct destroy;
>>                 };
>>         };
>> };
>>
>> This union is a bit dangerous. //Andrew Morton
>>
>> The first problem was fixed in v3.10-rc5-67-gf101a94.
>> The second problem is that the size of memory for root
>> caches is calculated incorrectly:
>>
>>       ssize_t size = memcg_caches_array_size(num_groups);
>>
>>       size *= sizeof(void *);
>>       size += sizeof(struct memcg_cache_params);
>>
>> The last line should be fixed like this:
>>       size += offsetof(struct memcg_cache_params, memcg_caches)
>>
>> Andrew suggested to rework this code without union and
>> this patch tries to do that.
>
> hm, did I?

I reread your messages. I have seen in it, what I want. Sorry, you
suggested to rework this code how you explained bellow in this
message. "without union" is my fantasy.
http://lkml.indiana.edu/hypermail/linux/kernel/1305.3/01985.html

>
>> This patch removes is_root_cache and union. The size of the
>> memcg_cache_params structure is not changed.
>>
>
> It's a bit sad to consume more space because we're sucky programmers.
> It would be better to retain the union and to stop writing buggy code
> to handle it!

I decided to implement this approach, because it doesn't increase
memory consumptions. This patch is replace is_root_cache on a pointer,
but due to alignment the size of the structure is not changed.

but the size of struct kmem_cache is increased on one pointer, if
accounting of kernel memory is not enabled.

The overhead of this patch on a real system is about 1K if the kernel
memory accounting is disabled and the overhead is zero after enabling
the accounting.

>
> Maybe there are things we can do to reduce the likelihood of people
> mishandling the union - don't use anonymous fields, name each member,
> access it via helper functions, etc.

Ok, I wil try this way.

Thanks,
Andrey
