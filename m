From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v3 3/4] memcg: optimize memcg_get_hierarchical_limit
Date: Tue, 26 Jun 2012 11:45:44 +0900
Message-ID: <4FE92258.4040900@jp.fujitsu.com>
References: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com> <4FE834D9.8070903@jp.fujitsu.com> <20120625104357.GB12148@kernel> <20120625110926.GJ19805@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120625110926.GJ19805-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/06/25 20:09), Michal Hocko wrote:
> On Mon 25-06-12 18:43:57, Wanpeng Li wrote:
>> On Mon, Jun 25, 2012 at 06:52:25PM +0900, Kamezawa Hiroyuki wrote:
>>> (2012/06/25 17:44), Wanpeng Li wrote:
>>>> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>>
>>>> Optimize memcg_get_hierarchical_limit to save cpu cycle.
>>>>
>>>> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>
>>> I can't understand the benefit of this patch to the real world...
>>>
>>> So, if you wrote the patch description as "clean up" rather than optimize,
>>> ok, I'll agree.
>> OK, I will change to "Cleanup". Thank you Kame.
>
> Does this really clean something up?
>

I just thought unused variable is trash even if it disappears after complie.

Thanks,
-Kame

