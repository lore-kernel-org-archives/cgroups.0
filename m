From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 13:54:40 +0000
Message-ID: <20191217135440.GB58496@chrisdown.name>
References: <87fthjh2ib.wl-kuninori.morimoto.gx@renesas.com>
 <20191217095329.GD31063@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0tDf420l6OJe0Bwhn9GE+pW7tyo0iSFruHkLYhzOzAo=;
        b=NBYb0wmeeE28IfoeJrHNR1nDrO2AHN8CdVfPvDeRfkbZeQiKbRNDWRDE53oyz1Qvin
         1Z7E0QX1fhIgd7ApaTelr4wPdPP3JqfQJRxyV4VIziwJGIJr6WzgZDPtcapqvqlqReR7
         Ylo8CwcB1K3wbYJWKBlqC8Kc8tQAW16Bt76kA=
Content-Disposition: inline
In-Reply-To: <20191217095329.GD31063@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hi Kuninori,

Michal Hocko writes:
>On Tue 17-12-19 15:47:40, Kuninori Morimoto wrote:
>> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>>
>> mem_cgroup_id_get_many() is used under CONFIG_MMU.
>
>Not really. It is used when SWAP is enabled currently. But it is not
>really bound to the swap functionality by any means. It just happens
>that we do not have other users currently. We might put it under
>CONFIG_SWAP but I do not really think it is a big improvement.

Agreed, I think we shouldn't wrap this in preprocessor conditionals it since 
it's entirely possible it will end up used elsewhere and we'll end up with a 
mess of #ifdefs.

>> This patch moves it to under CONFIG_MMU.
>> We will get below warning without this patch
>> if .config doesn't have CONFIG_MMU.
>>
>> 	LINUX/mm/memcontrol.c:4814:13: warning: 'mem_cgroup_id_get_many'\
>> 		defined but not used [-Wunused-function]
>> 	static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
>> 	^~~~~~~~~~~~~~~~~~~~~~
>
>Is this warning really a big deal? The function is not used, alright,
>and the compiler will likely just drop it.

Let's just add __maybe_unused, since it seems like what we want in this 
scenario -- it avoids new users having to enter preprocessor madness, while 
also not polluting the build output.

Once you've done that, I'll send over my ack. :-)

Thanks.
