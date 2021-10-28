From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg v3 3/3] memcg: prohibit unconditional exceeding the
 limit of dying tasks
Date: Thu, 28 Oct 2021 10:22:56 +0300
Message-ID: <ea14200f-ad2c-6901-25da-54900fe2ce14@virtuozzo.com>
References: <YXJ/63kIpTq8AOlD@dhcp22.suse.cz>
 <cover.1634994605.git.vvs@virtuozzo.com>
 <8f5cebbb-06da-4902-91f0-6566fc4b4203@virtuozzo.com>
 <YXZ6qaMJBomVfV8O@dhcp22.suse.cz>
 <20211027153608.9910f7db99d5ef574045370e@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y06wyIaTQk/vqnWTXXrbA0/17cWwIbbEVGj8aQ97gw=;
 b=v0E1eKyk5HkI9KAhSRzN5tvx7lbiK4uS9uNhLCAGMXtyZ39nTwFO6n93BCM75aEYeizhPiQwNeBAKbAJE/VbQkGLN+g699ubbOAQmQHXiS64YmlC+msidD4htb+7ITDU4j7Jbhhf/wcicsPqCRS78YUaYE0PrTHOjAp7l44JAeg=
In-Reply-To: <20211027153608.9910f7db99d5ef574045370e-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

On 28.10.2021 01:36, Andrew Morton wrote:
> On Mon, 25 Oct 2021 11:36:41 +0200 Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> 
>> My view on stable backport is similar to the previous patch. If we want
>> to have it there then let's wait for some time to see whether there are
>> any fallouts as this patch depends on the PF_OOM change.
> 
> It's strange that [1/3] doesn't have cc:stable, but [2/3] and [3/3] do
> not.  What is the thinking here?

My fault, I missed it.
All 3 patches should be backported,
I did it already to stables kernels since 4.4 and I'm ready to submit it in demand.

> I expect we'd be OK with merging these into 5.16-rc1.  This still gives
> another couple of months in -rc to shake out any problems.  But I
> suspect the -stable maintainers will merge and release the patches
> before they are released in 5.16.
> 
> In which case an alternative would be not to mark these patches
> cc:stable and to somehow remember to ask the -stable maintainers to
> merge them after 5.16 has been on the streets for a suitable period.
> 
> Greg, thoughts?

If you wish I can remind Greg in a month or even after 5.17 release.

Thank you,
	Vasily Averin

