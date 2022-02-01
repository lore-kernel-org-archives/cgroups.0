From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation
 from unspecified node
Date: Tue, 1 Feb 2022 00:42:37 +0000
Message-ID: <20220201004237.77nqe36aqut6kuxc@master>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220131014742.oxcrctcg6sqwvzij@master>
 <20220131143620.b619f24f5246b26bce2b717d@linux-foundation.org>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tM48J1r6RkVUujqg3c37yU/BycOtok0R6SCSR/HwO4I=;
        b=UUW3DPdsg1gI2lDGeDXFutTvvI5cYxgHl2wsh3p/ADj0fd46ifjisnczPrI4UjM8N/
         vOVnCmjP0puOYVDH6vyFuJWHTvvw3MF9QDhm52vgjSbVecXUHUwKGvLI7VCj03Yn+70n
         duOs6uAvOx3ewSYFheL0uw3EZlADa2KeTn0TK25CbE7pR7aGYginonT6BMbkFIFP6Wtp
         uc34SUM2eeQ0dXuMqc+tsTdjScmYBkC+RTH8qJyiP6GejSYPbid/1Fhvzj0l88X5dwUF
         xqdS53FSpXlQ7VTaC+JgrZgfimgH1Ox7lT0GtkHtEuRsFE3rYz5wLRlZjPaHOjQ3fDkw
         wphA==
Content-Disposition: inline
In-Reply-To: <20220131143620.b619f24f5246b26bce2b717d-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Jan 31, 2022 at 02:36:20PM -0800, Andrew Morton wrote:
>On Mon, 31 Jan 2022 01:47:42 +0000 Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hi, Andrew
>> 
>> Would you pick up this patch set, or prefer me to send a v2?
>> 
>
>It's unclear to me what's happening with [4/4].  At least a new
>changelog with more justification is expected?
>

As Michal and Roman suggested, this is not a hot-path. I would drop this one.

>So yes, please resend?

Sure.

-- 
Wei Yang
Help you, Help me
