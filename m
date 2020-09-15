From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Tue, 15 Sep 2020 01:21:56 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009150112130.1550@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org> <alpine.LSU.2.11.2008241231460.1065@eggly.anvils> <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils> <61a42a87-eec9-e300-f710-992756f70de6@linux.alibaba.com> <alpine.LSU.2.11.2009091524260.10087@eggly.anvils> <855ad6ee-dba4-9729-78bd-23e392905cf6@linux.alibaba.com> <alpine.LSU.2.11.2009111634020.22739@eggly.anvils>
 <5cfc6142-752d-26e6-0108-38d13009268b@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=qwBcvIBU5LOYe6OskRbMqT6V676HBWZDqSyC3uftkyQ=;
        b=HslBmbeWTZm7v2sAgaH6pYCFXZ7p24g+9zKdqnDAv0NOj2E9u3HBm4SN0fyl+ARwBj
         Br5Fx3dCbNIxlooxtHo2kNsfpAA33mhnz/XMM3D1dxVbbccet/Cdnq0YPagKQVeT5G5Z
         5SH4ZPg/M3NnYHJMnQwe1o7DHXDijfry/Hkk8TniFYcpFEVfJKPAsZffKXxLz4fx/GNH
         2OVlsrZpPKckQsTMFVXe21TmD0mXmiuVW6p7flm6WGT8oZNNGxB2AKQhZvouWtHvIIpY
         /kn4MMUMqvaAB/HZgmb8IUarJy4R+n76AjBbuU7Twv7P+yN6t7ZUO6irhAOPgT+OiJ1g
         DCfA==
In-Reply-To: <5cfc6142-752d-26e6-0108-38d13009268b-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cai-J5quhbR+WMc@public.gmane.org

On Sun, 13 Sep 2020, Alex Shi wrote:
> 
> IIRC, all of comments are accepted and push to 
> https://github.com/alexshi/linux.git lruv19

I just had to relax for the weekend, so no progress from me.
I'll take a look at your tree tomorrow, er, later today.

> If you don't minder, could you change everything and send out a new version
> for further review?

Sorry, no.  Tiresome though it is for both of us, I'll continue
to send you comments, and leave all the posting to you.

> Uh, I updated the testing with some new results here:
> https://lkml.org/lkml/2020/8/26/212

Right, I missed that, that's better, thanks.  Any other test results?

Hugh
