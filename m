From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: non-hierarchical mode is deprecated
Date: Tue, 5 Apr 2022 08:05:27 +0000
Message-ID: <20220405080527.6eoziuwyfc76xvry@master>
References: <20220403020833.26164-1-richard.weiyang@gmail.com>
 <Ykq6Gbt5MX9GCiKM@dhcp22.suse.cz>
 <20220405022218.53idmvm2ha2tzmy2@master>
 <YkvhMx2EVVisfjRG@dhcp22.suse.cz>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yyy8ZziaZgnmwLljTWyYhZF76iEy/skny2JVUymVUfc=;
        b=ZrPqW6X6T9AHIOoCE+8DXcGn6ONM3ECUQG7TA8kMbhD/l9G0Y5nl/2aIRaT4SRTqlJ
         iC7dDZTQEwT/ayXIVBtrvcfW3GdeHa2zVQON+czr57By8Bz0qkC8H5IaNBoxEbc8UWgz
         xFlGtjhVE7iZSxOYWyMsFOxQJgFA9YNX9booe1ijJGicN3y52sdh20P0e74Tk4nCLD6m
         G+qjItVnouOs6TR4SaQoEsLAZmfRWNgoDGL91oT0+yhSepn4IpC04eO2/33duVBa7OI7
         TkCrxA766VbsxvW9Q5kVCNu0E919RJy/hMkBS+QXbPg5qhOKSArA3qETqjQ1Ll5wH347
         Tbzg==
Content-Disposition: inline
In-Reply-To: <YkvhMx2EVVisfjRG-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Apr 05, 2022 at 08:26:59AM +0200, Michal Hocko wrote:
>On Tue 05-04-22 02:22:18, Wei Yang wrote:
>> On Mon, Apr 04, 2022 at 11:27:53AM +0200, Michal Hocko wrote:
>> >On Sun 03-04-22 02:08:33, Wei Yang wrote:
>> >> After commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical
>> >> mode"), we won't have a NULL parent except root_mem_cgroup. And this
>> >> case is handled when (memcg == root).
>> >> 
>> >> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> CC: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>> >> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> >
>> >Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>> >Thanks!
>> >
>> 
>> Thanks for the ack. When reading the code, I found one redundant check in
>> shrink_node_memcgs().
>> 
>>   shrink_node_memcgs
>>     mem_cgroup_below_min
>>       mem_cgroup_supports_protection
>>     mem_cgroup_below_low
>>       mem_cgroup_supports_protection
>> 
>> I am not sure it worthwhile to take it out.
>> 
>>   shrink_node_memcgs
>>     mem_cgroup_supports_protection
>>       mem_cgroup_below_min
>>       mem_cgroup_below_low
>> 
>> Look forward your opinion.
>
>I guess you refer to mem_cgroup_is_root check in mem_cgroup_supports_protection,
>right?
>
>You are right that the check is not really required because e{min,low}
>should always stay at 0 for the root memcg AFAICS. On the other hand the
>check is not in any hot path and it really adds clarity here because
>protection is not really supported on the root memcg. So I am not this
>is an overall win.

Agree.

>-- 
>Michal Hocko
>SUSE Labs

-- 
Wei Yang
Help you, Help me
