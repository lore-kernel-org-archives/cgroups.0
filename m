From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: non-hierarchical mode is deprecated
Date: Tue, 5 Apr 2022 02:22:18 +0000
Message-ID: <20220405022218.53idmvm2ha2tzmy2@master>
References: <20220403020833.26164-1-richard.weiyang@gmail.com>
 <Ykq6Gbt5MX9GCiKM@dhcp22.suse.cz>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PGMcc6BBrVtiS+i2Ug0VtK3wbbeBQEHvMN1RCK8rtJM=;
        b=T7b/kFnop+W+o3vMn+4faNMaH/6FVivfWcDvLooM6SXo3IuYPc5Pc/iLnyOFOYM4Lx
         +PEnWnwS+79f6ahrGXwHJKWetACHMgs7G8t1cyqZ/8gcnVcaAmosyjvJMWlkARoO3RmJ
         AZzav9BHLYzjA2Y//zznKm9QPwReL4zr+QJcHW1TNKytJQfT/NVLXQ2Tcmumf69mJ0vk
         MssrfEYgxZ2RJN81lAy3kL3NgqjHh9yzfbCWWLeIznHl8O3kh/X4EH2kRL6VK4TcYF9r
         CUsz2CB0x9Zg/1pD4IlLrggiu8K3gzEViK9SKYb1Z86W1Gqv7qXkzGy1TvdQIrf8gxkB
         ULcQ==
Content-Disposition: inline
In-Reply-To: <Ykq6Gbt5MX9GCiKM-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, Apr 04, 2022 at 11:27:53AM +0200, Michal Hocko wrote:
>On Sun 03-04-22 02:08:33, Wei Yang wrote:
>> After commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical
>> mode"), we won't have a NULL parent except root_mem_cgroup. And this
>> case is handled when (memcg == root).
>> 
>> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> CC: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>
>Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>Thanks!
>

Thanks for the ack. When reading the code, I found one redundant check in
shrink_node_memcgs().

  shrink_node_memcgs
    mem_cgroup_below_min
      mem_cgroup_supports_protection
    mem_cgroup_below_low
      mem_cgroup_supports_protection

I am not sure it worthwhile to take it out.

  shrink_node_memcgs
    mem_cgroup_supports_protection
      mem_cgroup_below_min
      mem_cgroup_below_low

Look forward your opinion.

-- 
Wei Yang
Help you, Help me
