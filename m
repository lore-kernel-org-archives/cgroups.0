From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm: Make mem_cgroup_id_get_many dependent on MMU and
 MEMCG_SWAP
Date: Thu, 5 Mar 2020 18:34:26 +0000
Message-ID: <20200305183426.GA752201@chrisdown.name>
References: <20200304142348.48167-1-vincenzo.frascino@arm.com>
 <20200304165336.GO16139@dhcp22.suse.cz>
 <8c489836-b824-184e-7cfe-25e55ab73000@arm.com>
 <20200305160929.GA1166@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wJ+dZCI2bt1Xd92Q8gcINy/Mjz00mboTvZOgg2MiZ/Q=;
        b=Az2s3X855Yee9bmXQu46ijVabcCPfzqRWC0fXIWABql9qvdRJREScafWu3/RuhgSZu
         j4zu1EG9DYlfH1ymfLDTZX07SiFFS4XIvrkPVnNZt41vphnMSbVDpEJJ5ssq1hWz3/L/
         xc3wSL5sORqcP4T1T/bEHP3MxEhe85fLbf6ZQ=
Content-Disposition: inline
In-Reply-To: <20200305160929.GA1166-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Vincenzo Frascino <vincenzo.frascino-5wv7dgnIgG8@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Johannes Weiner writes:
>I would ack a patch that adds __maybe_unused.
>
>This is a tiny function. If we keep it around a few releases after
>removing the last user, it costs us absolutely nothing. Eventually
>somebody will notice and send a patch to remove it. No big deal.
>
>There is, however, real cost in keeping bogus warnings around and
>telling people to ignore them. It's actively lowering the
>signal-to-noise ratio and normalizing warnings to developers. That's
>the kind of thing that will actually hide problems in the kernel.
>
>We know that the function can be unused in certain scenarios. It's
>silly to let the compiler continue to warn about it. That's exactly
>what __maybe_unused is for, so let's use it here.

Yeah, this is exactly what I was trying to express in the first one[0]. The 
fact that this patch came around a second time, as expected, just solidifies my 
concern around the waste to human time.

I would also ack a patch that adds __maybe_unused.

0: https://lore.kernel.org/linux-mm/20191217143720.GB131030-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org/
