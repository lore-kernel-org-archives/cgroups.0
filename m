From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Tue, 5 May 2020 09:13:24 +0200
Message-ID: <20200505071324.GB16322@dhcp22.suse.cz>
References: <20200430182712.237526-1-shakeelb@google.com>
 <20200504065600.GA22838@dhcp22.suse.cz>
 <CALvZod5Ao2PEFPEOckW6URBfxisp9nNpNeon1GuctuHehqk_6Q@mail.gmail.com>
 <20200504141136.GR22838@dhcp22.suse.cz>
 <CALvZod7Ls7rTDOr5vXwEiPneLqbq3JoxfFBxZZ71YWgvLkNr5A@mail.gmail.com>
 <20200504150052.GT22838@dhcp22.suse.cz>
 <CALvZod7EeQm-T4dsBddfMY_szYw3m8gRh5R5GfjQiuQAtCocug@mail.gmail.com>
 <20200504160613.GU22838@dhcp22.suse.cz>
 <CALvZod79hWns9366B+8ZK2Roz8c+vkdA80HqFNMep56_pumdRQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod79hWns9366B+8ZK2Roz8c+vkdA80HqFNMep56_pumdRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 04-05-20 12:23:51, Shakeel Butt wrote:
[...]
> *Potentially* useful for debugging versus actually beneficial for
> "sweep before tear down" use-case.

I definitely do not want to prevent you from achieving what you
want/need. Let's get back to your argument on why you cannot use
memory.high for this purpose and what is the actual difference from
memory.max on the "sweep before removal". You've said

: Yes that would work but remote charging concerns me. Remote charging
: can still happen after the memcg is offlined and at the moment, high
: reclaim does not work for remote memcg and the usage can go till max
: or global pressure. This is most probably a misconfiguration and we
: might not receive the warnings in the log ever. Setting memory.max to
: 0 will definitely give such warnings.

So essentially the only reason you are not using memory.high which would
effectively achieve the same level of reclaim for your usecase is that
potential future remote charges could get unnoticed. I have proposed to
warn when charging to an offline memcg because that looks like a sign of
bug to me. Having the hard limit clamped to 0 (or some other small
value) would complain loud by the oom report and no eligible tasks
message but it will unlikely help to stop such a usage because, well,
there is nothing reclaimable and we force the charge in that case. So
you are effectively in the memory.high like situation.

So instead of potentially removing a useful information can we focus on
the remote charging side of the problem and deal with it in a sensible
way? That would make memory.high usable for your usecase and I still
believe that this is what you should be using in the first place.
-- 
Michal Hocko
SUSE Labs
