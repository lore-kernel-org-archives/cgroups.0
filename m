From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation
 from unspecified node
Date: Mon, 31 Jan 2022 14:36:20 -0800
Message-ID: <20220131143620.b619f24f5246b26bce2b717d@linux-foundation.org>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
        <20220131014742.oxcrctcg6sqwvzij@master>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643668581;
        bh=1JoJCnoSkTjuoMaPr44ixmEVlbNRYqEL/DOdLmDrv1k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MDvZuVHYqwuPV46o0TbHvDZjgaF9tt1yumFPV8NdVibS+QJwS4/uFLexxFzrTmkBd
         PvdDP7T1WiOpe6ADElmDyXx+qLwjBwUnMTSKNIMCWK5F5JCCSE7uLWzVjjobUm4BD6
         Erv5O5Vhdaf1Yc4OA2QlAIX4f80bBdqqrWhrTorI=
In-Reply-To: <20220131014742.oxcrctcg6sqwvzij@master>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, 31 Jan 2022 01:47:42 +0000 Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi, Andrew
> 
> Would you pick up this patch set, or prefer me to send a v2?
> 

It's unclear to me what's happening with [4/4].  At least a new
changelog with more justification is expected?

So yes, please resend?
