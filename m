From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] memcg: charge before adding to swapcache on swapin
Date: Fri, 5 Mar 2021 08:42:00 -0800
Message-ID: <CALvZod4iVF1tg8H-zcUVp6Kf+L9jeJBF62hNHuLNKrdcxyJXYQ@mail.gmail.com>
References: <20210304014229.521351-1-shakeelb@google.com> <alpine.LSU.2.11.2103042248590.18572@eggly.anvils>
 <YEJbZi+tpSATjsT/@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Idz6IhNVmVDwrmS9eS02rzcFdMoaAKDHYFFgO5wjPbU=;
        b=O2TrIrVFHinCDdMspBfmxsGMiJUlgXCqYQ5/0BckQ2Iqy1homQEhVrIQ0XJsIYpaiW
         +YcSkkOPteNMhOlE5U2GaaBp/HMTEYNawtAoNNIkRe/tsVEzJ4PZB1KAAThN973pDjue
         IjS6Zw/SOn6Xkj9MzXByMZP+d6xnuMFtlm3qOV4cT/bLE9T0j7pRISgBlXx8E+WEG+s0
         Ikc8YL/wTRFWi8DIjOcRUcsXe4QWct1oDvtVTIFV9IFP20cP91zKojuI6/SOhAOV27bO
         G/2Lnq7h5vsbliyITp9Bs3FcRyDoP2/5N+/HduaduYJDav5igamHgTT/8kSXaey2iA37
         KhHg==
In-Reply-To: <YEJbZi+tpSATjsT/@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Mar 5, 2021 at 8:25 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
[...]
> I'd also rename cgroup_memory_noswap to cgroup_swapaccount - to match
> the commandline and (hopefully) make a bit clearer what it effects.

Do we really need to keep supporting "swapaccount=0"? Is swap
page_counter really a performance issue for systems with memcg and
swap? To me, deprecating "swapaccount=0" simplifies already
complicated code.
