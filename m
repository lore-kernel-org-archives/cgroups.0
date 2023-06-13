From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] cgroup: rstat: Simplified
 cgroup_base_stat_flush() update last_bstat logic
Date: Tue, 13 Jun 2023 13:52:07 +0200
Message-ID: <ssbelevnb6zpeeqwcdmbzepl6igw42azaxcfw3sn5zlubmjwl2@3ipsbldccyiy>
References: <20230518124142.57644-1-jiahao.os@bytedance.com>
 <f39b9229-e59c-2b1c-7f3f-1aeedfad44dc@bytedance.com>
 <5g73i4yvi4ub4dqrf4dnq5qghkyckoygmgd2st6be3gg7twww2@w6zim6nxpt3b>
 <4d49f7e7-2488-9690-258e-34e617cfef6f@bytedance.com>
 <remnwctqmxleig7ywt6puhxnpmzjo7xm6hlfhpnul46ulfnw7j@36sbuxhuatto>
 <d6d19a61-a584-1839-e6cc-ea63479ca800@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686657129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xGuAwbZ+ToWocWzlF7uUFTALD/7tV0uI1p0rTYe0rOw=;
        b=T0wn9mJWbyZjRwsgG82QNi/GH9v/gfKYllIRa19GYFZfIeFrZxnN05r2NBWG31Gv0BdOHE
        Xa99ZbS/k4wu7P+HIBADAToF6+U6kIrNU9rgZG7dNRKB3/b8irgVVlRdBEaXCAOQFx1HxL
        jWyJMAbrq2xqZg9KY/6T5D6RkZ9pPXg=
Content-Disposition: inline
In-Reply-To: <d6d19a61-a584-1839-e6cc-ea63479ca800-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 12, 2023 at 11:13:41AM +0800, Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> Sorry for replying you so late. I am using RDTSC on my machine (an Intel
> Xeon(R) Platinum 8260 CPU@2.40GHz machine with 2 NUMA nodes each of which
> has 24 cores with SMT2 enabled, so 96 CPUs in total.) to compare the time
> consumption of arithmetics vs copying. There is almost no difference in the
> time consumption between arithmetics and copying.

Thanks for carrying out and sharing this despite not convincing towards
the change.

Michal
