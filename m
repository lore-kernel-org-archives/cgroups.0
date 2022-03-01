From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive
 codepaths
Date: Tue, 1 Mar 2022 18:57:03 +0100
Message-ID: <20220301175703.GA10867@blackbody.suse.cz>
References: <20220226002412.113819-1-shakeelb@google.com>
 <Yh3h33W45+YaMo92@dhcp22.suse.cz>
 <CALvZod7aF9xRc+XvY7GPN7OnDyPitt1H6Q4yrwzAXTFzv1LzWQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646157425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=buWeJHt6GiyDyp6c2t6RjOy396An8wRLpBnyIHHufHY=;
        b=Qa/tlCjNWZWBuQe2pEOePHVesePkJsxgpGAcf+RKInChvZEOpBSOv16KjCk6wN3eB9rRmD
        GZyyOTwaEbMN0GGXw2Xmw8uaT/U5BevMNkAopM6bozcI14rCPFaheJSxDUirS59knYxmsK
        6sub2e238Ivp/5yAAgjARKA1omAM1WM=
Content-Disposition: inline
In-Reply-To: <CALvZod7aF9xRc+XvY7GPN7OnDyPitt1H6Q4yrwzAXTFzv1LzWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Making decisions based on up to 2 s old information.

On Tue, Mar 01, 2022 at 09:21:12AM -0800, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Without flushing the worst that can happen in the refault path is
> false (or missed) activations of the refaulted page.

Yeah, this may under- or overestimate workingset size (when it's
changing), the result is likely only less efficient reclaim.

> For reclaim code, some heuristics (like deactivating active LRU or
> cache-trim) may act on old information.

Here, I'd be more careful whether such a delay cannot introduce some
unstable behavior (permanent oscillation in the worst case).

> Now, coming to your question, yes, we can remove the flushing from
> these performance critical codepaths as the stats at most will be 2
> second old due to periodic flush. 

Another aspect is that people will notice and report such a narrowly
located performance regression more easily than reduced/less predictable
reclaim behavior. (IMO the former is better, OTOH, it can also be
interpreted that noone notices (is able to notice).)

Michal
