From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/4] memcg: optimize memcg_get_hierarchical_limit
Date: Mon, 25 Jun 2012 19:19:29 +0800
Message-ID: <20120625111929.GC12148@kernel>
References: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com>
 <4FE834D9.8070903@jp.fujitsu.com>
 <20120625104357.GB12148@kernel>
 <20120625110926.GJ19805@tiehlicka.suse.cz>
Reply-To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LRttCSiO7Hm/+/NL50B9tAOj/lNlqbfoM00X9WruJcc=;
        b=jzsicagEDDIlYM2rrReu+Qr46VQipy+BfzvN3u8lCmRZXtbJuk2cz8/8Kmv6dntHcR
         RIQ6mfEC0zP6Skye86iK4qPuWLZb4oVCm9GDmXrDdkN09/MABF0Q7olUwK+H/FL2i0gR
         tqlha1o29UMx6mMrOmQ/zEJwXTQBzLlwHmv4daR0ioRjZY+ZtzH8NZTuLb1ONlXinGS4
         /xw6FwpWB6rwFspXlqWWCh6j+8NeUUYTujsMBFht2iqZT1OqZrB/65pap6vFKnZUoJTO
         LBrP3C6ahIl2q3TyuGIUjLBGE/gAnt/bRTTu7/LFqTBDIFJiXp/XOT3zUtyXhNQ8lEtA
         /Rfw==
Content-Disposition: inline
In-Reply-To: <20120625110926.GJ19805-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Jun 25, 2012 at 01:09:26PM +0200, Michal Hocko wrote:
>On Mon 25-06-12 18:43:57, Wanpeng Li wrote:
>> On Mon, Jun 25, 2012 at 06:52:25PM +0900, Kamezawa Hiroyuki wrote:
>> >(2012/06/25 17:44), Wanpeng Li wrote:
>> >> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> >> 
>> >> Optimize memcg_get_hierarchical_limit to save cpu cycle.
>> >> 
>> >> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >
>> >I can't understand the benefit of this patch to the real world...
>> >
>> >So, if you wrote the patch description as "clean up" rather than optimize,
>> >ok, I'll agree.
>> OK, I will change to "Cleanup". Thank you Kame.
>
>Does this really clean something up?

OK, just drop it and resend the patch. Hopefully, you can applied! :-)

Best Regards,
Wanpeng Li

>-- 
>Michal Hocko
>SUSE Labs
>SUSE LINUX s.r.o.
>Lihovarska 1060/12
>190 00 Praha 9    
>Czech Republic
