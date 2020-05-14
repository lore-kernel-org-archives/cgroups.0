From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/19 V2] mm: memcontrol: charge swapin pages on
 instantiation
Date: Thu, 14 May 2020 21:04:53 +1000
Message-ID: <f6a474e3-b491-dbf2-c404-f04999b039ff@gmail.com>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200513113032.GA93568@dev-dsk-sblbir-1c-a524888b.ap-northeast-1.amazon.com>
 <20200513123545.GB488426@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZMXJJmn4oIa+JQJYqBoFnxPMqQn52lyOsqRLxMD4w8M=;
        b=dOXhUBHkmcRcqC6sZCJHlAmTMHFYPALmKXWIC7fdx6azSSyt1YVXktUWn7/BrnQ2QS
         eBpbHXGT0bwSzLEXpB4eWFBTl8AWd7qE582wwQEJmtdrrwyYPbY9lz4Sr//I5F6EPyJb
         vT+EfPkP/ISnItuSOf4UM76jnCZO/rHDFqxVfhXOxWIaVqZC3XxTvCpsBLsP8SGw/RHa
         bilmMONguFO/cjHo99nsLV7sQpHe/uBCbdGlxMWeK+r7KRm1Us6aszBgcpD6GIkGIlkD
         2t6WZUTUlJgUx4f+O1rm85EnM2Os64rvrHme0ErrsjYw2+3z5nlED3VtZS5KbH9xWsih
         YIow==
In-Reply-To: <20200513123545.GB488426-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org



On 13/5/20 10:35 pm, Johannes Weiner wrote:
> As a result, the memcg gets a breakdown for memory.stat without having
> to have private knowledge of what a page cache page is - how to test
> it, when it's safe to test it, whether there can be huge pages in the
> page cache, etc. pp. Memcg can focus on counting bytes, and the VM
> code that is specialized in dealing with the page cache (or anon
> pages, or shmem pages) can fill in those kinds of details for us.
> 
> Less dependencies, less duplication, simpler API rules.
> 
> The memory.stat output is the same, it's just much simpler code.

Makes sense! Thanks, I should spend some time to re-read all of the memcontrol.c code :)

Balbir Singh.
