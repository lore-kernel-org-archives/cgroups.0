From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3] memcg: charge before adding to swapcache on swapin
Date: Fri, 5 Mar 2021 16:00:19 -0500
Message-ID: <YEKb4/MAVv8zDPNw@cmpxchg.org>
References: <20210304014229.521351-1-shakeelb@google.com>
 <alpine.LSU.2.11.2103042248590.18572@eggly.anvils>
 <YEJbZi+tpSATjsT/@cmpxchg.org>
 <CALvZod4iVF1tg8H-zcUVp6Kf+L9jeJBF62hNHuLNKrdcxyJXYQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=La3mwDa8nISUh2U9bi9oHzPu358czH3TeQ0ByYgJZqY=;
        b=VfhA/pXDD661QUgX1Mxa4DhK6hKrLISfubA84eRcP5m7HrACNGN9aEnYTpgLPqDTKl
         g4TbBNYRDsU/94H2jOc7T/WxPyFqm19l9G7+Q1geXVCnQcSU5+0ssJYshieCtlZBKv8G
         ZhfXtpPkowYLxrCPZDBq+iHGWe+2Ke52zeeoRbeMAElVHx7F1isMeyzGcS7h/D6oaDkV
         Ro/dMjTsOIUEVp7J0fkdOfo9OM7pFGQuyPmXZK2etHIsJqi+AAuIWwkhelx/s2kSoHn5
         0GHaF5UMUWdWwHNA8bAi9C2HW1FxI9M8Ef6GARBBntVKOnNojeQRWUUzzV0DCeMyIcnc
         o4Jg==
Content-Disposition: inline
In-Reply-To: <CALvZod4iVF1tg8H-zcUVp6Kf+L9jeJBF62hNHuLNKrdcxyJXYQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Fri, Mar 05, 2021 at 08:42:00AM -0800, Shakeel Butt wrote:
> On Fri, Mar 5, 2021 at 8:25 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> [...]
> > I'd also rename cgroup_memory_noswap to cgroup_swapaccount - to match
> > the commandline and (hopefully) make a bit clearer what it effects.
> 
> Do we really need to keep supporting "swapaccount=0"? Is swap
> page_counter really a performance issue for systems with memcg and
> swap? To me, deprecating "swapaccount=0" simplifies already
> complicated code.

Now that you mention it, it's probably really not worth it.

I'll replace my cleanup patch with a removal patch that eliminates
everything behind swapaccount= except for a deprecation warning...
