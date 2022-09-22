From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Thu, 22 Sep 2022 07:41:29 -1000
Message-ID: <YyyeSVSk/lWdo/W4@slm.duckdns.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=YTw4/4H1DrZyYT8r3vAbsU7ElPYxgVDhU3+OM9JyucE=;
        b=ElLCbl1NZGRXMxpT6v5xRjFMH5pVD8Cb811OWdYBmSUbw6+6INd7SgCM411RdFKg2D
         3gBBwooCUeu9bguTScSkm/XZSKCxDniYvdgWCIhnkKXa/dj/aqMoxUdDf/Z4g4Z3Uyxz
         fJktrerUAVeMdfLrhHHvN0kbmKSsQmUR4AfFzNTL/auXAiED8nOxCign4vgffb5wAAha
         ODjUE/FYzl39vEFJ1jKVo1TaQdQR//fsoXDGhh7myPCV/CZ20tcFNpmeDfdQNQeVatLo
         Q6WOHGCkKXqSy8yRccfb+uwAOH7duIQ8LnHnLiFE59louwT8ra/ug4luSqNxIhGSaQle
         b8yw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hello,

(cc'ing memcg folks)

On Thu, Sep 22, 2022 at 10:10:37AM -0700, Kristen Carlson Accardi wrote:
> Add a new cgroup controller to regulate the distribution of SGX EPC memory,
> which is a subset of system RAM that is used to provide SGX-enabled
> applications with protected memory, and is otherwise inaccessible.
> 
> SGX EPC memory allocations are separate from normal RAM allocations,
> and is managed solely by the SGX subsystem. The existing cgroup memory
> controller cannot be used to limit or account for SGX EPC memory.
> 
> This patchset implements the sgx_epc cgroup controller, which will provide
> support for stats, events, and the following interface files:
> 
> sgx_epc.current
> 	A read-only value which represents the total amount of EPC
> 	memory currently being used on by the cgroup and its descendents.
> 
> sgx_epc.low
> 	A read-write value which is used to set best-effort protection
> 	of EPC usage. If the EPC usage of a cgroup drops below this value,
> 	then the cgroup's EPC memory will not be reclaimed if possible.
> 
> sgx_epc.high
> 	A read-write value which is used to set a best-effort limit
> 	on the amount of EPC usage a cgroup has. If a cgroup's usage
> 	goes past the high value, the EPC memory of that cgroup will
> 	get reclaimed back under the high limit.
> 
> sgx_epc.max
> 	A read-write value which is used to set a hard limit for
> 	cgroup EPC usage. If a cgroup's EPC usage reaches this limit,
> 	allocations are blocked until EPC memory can be reclaimed from
> 	the cgroup.

I don't know how SGX uses its memory but you said in the other message that
it's usually a really small portion of the memory and glancing the code it
looks like its own page aging and all. Can you give some concrete examples
on how it's used and why we need cgroup support for it? Also, do you really
need all three control knobs here? e.g. given that .high is only really
useful in conjunction with memory pressure and oom handling from userspace,
I don't see how this would actually be useful for something like this.

Thanks.

-- 
tejun
