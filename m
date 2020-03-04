From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] memcg: css_tryget_online cleanups
Date: Wed, 4 Mar 2020 13:32:17 +0100
Message-ID: <20200304123217.GK16139@dhcp22.suse.cz>
References: <20200302203109.179417-1-shakeelb@google.com>
 <20200303093251.GD4380@dhcp22.suse.cz>
 <CALvZod7C9nrS4S36AfTY74cx0=58LXNNh_b+mXzXNG1j9_6RZg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod7C9nrS4S36AfTY74cx0=58LXNNh_b+mXzXNG1j9_6RZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 03-03-20 15:49:41, Shakeel Butt wrote:
> On Tue, Mar 3, 2020 at 1:32 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
[...]
> > Could you be more specific about the swap in case please?
> >
> 
> With swap accounting enabled, if the memcg of the swapped out page is
> not online then the memcg extracted from the given 'mm' will be
> charged and if 'mm' is NULL then root memcg will be charged. However I
> could not find a code path where the given 'mm' will be NULL for
> swap-in case.

Yes, this is my understanding as well. All the paths are getting mm from
a vma AFAICS. This is a valuable information for the changelog.

-- 
Michal Hocko
SUSE Labs
