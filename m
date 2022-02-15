From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2 3/4] selftests: memcg: test high limit for single
 entry allocation
Date: Tue, 15 Feb 2022 15:28:24 -0800
Message-ID: <Ygw3GNtOiR33VNcv@carbon.dhcp.thefacebook.com>
References: <20220211064917.2028469-1-shakeelb@google.com>
 <20220211064917.2028469-4-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=zK/BJT8ShN+IBm7uvEiaW90Ejn5WUgbfZVHW/0A5CRs=;
 b=EgKsw2qC4G6smfqksf0N6QJdyMLLBQmFRu6/hTH+tJqwB61g3q1r+c4EQOTZ5LjMvcak
 8RtRvE25op4JcYP0ledZms9SThwpceWXJq7VGS7xl/ImYiplxRKFdYYzpK2tNjvr+CMA
 vjpri+8LLo7p8alhn33OddY6gStwEVn/QVU= 
Content-Disposition: inline
In-Reply-To: <20220211064917.2028469-4-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 10, 2022 at 10:49:16PM -0800, Shakeel Butt wrote:
> Test the enforcement of memory.high limit for large amount of memory
> allocation within a single kernel entry. There are valid use-cases
> where the application can trigger large amount of memory allocation
> within a single syscall e.g. mlock() or mmap(MAP_POPULATE). Make sure
> memory.high limit enforcement works for such use-cases.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> Changes since v1:
> - None

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
