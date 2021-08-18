From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix occasional OOMs due to proportional
 memory.low reclaim
Date: Wed, 18 Aug 2021 10:16:59 -0400
Message-ID: <YR0WW2VvgtUHK1HL@cmpxchg.org>
References: <20210817180506.220056-1-hannes@cmpxchg.org>
 <CALvZod7097PHnXoOUZzPpmkASKpL3rV+2UJ+zp-NCdkpVoFTWg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QuwtlkiDGdVrCHQjEs+V1pH13gkXul/lhVEkHhu3sPg=;
        b=HGixUth5XmHhaExQjj0gkfLh0CcKhfT9fLJ8YT+dCDfj28MGFMjoiPk12fFJ75GriO
         T3vJh7OduH2ggAbsAw4pR2TMzK5OkotvAbwW5kg/WMKj9tVKuwutWoUoQqQ0mair1Ivn
         IXnMaAE+5G6/0DOyN2E24YF4TEN52GyJyeAHja0iPBTGhHdmzv72e37rv5SRqMwiX0jB
         0zAct3Jr3JADH5pG3y5yrxAkueO/MsBtxxTBZXMS87vYomrc7Gl69AVEtEHAd0dNxdAq
         BG3Rnqfq+rO/ArKUpIPfdWadeGYwTOuXPzo9l1ubVv0Dcpykxz3Wfu/DmKo5bFuvq0W4
         6vpg==
Content-Disposition: inline
In-Reply-To: <CALvZod7097PHnXoOUZzPpmkASKpL3rV+2UJ+zp-NCdkpVoFTWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, Aug 17, 2021 at 12:10:16PM -0700, Shakeel Butt wrote:
> On Tue, Aug 17, 2021 at 11:03 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > We've noticed occasional OOM killing when memory.low settings are in
> > effect for cgroups. This is unexpected and undesirable as memory.low
> > is supposed to express non-OOMing memory priorities between cgroups.
> >
> > The reason for this is proportional memory.low reclaim. When cgroups
> > are below their memory.low threshold, reclaim passes them over in the
> > first round, and then retries if it couldn't find pages anywhere else.
> > But when cgroups are slighly above their memory.low setting, page scan
> 
> *slightly
> 
> > force is scaled down and diminished in proportion to the overage, to
> > the point where it can cause reclaim to fail as well - only in that
> > case we currently don't retry, and instead trigger OOM.
> >
> > To fix this, hook proportional reclaim into the same retry logic we
> > have in place for when cgroups are skipped entirely. This way if
> > reclaim fails and some cgroups were scanned with dimished pressure,
> 
> *diminished

Oops. Andrew, would you mind folding these into the checkpatch fixlet?

> > we'll try another full-force cycle before giving up and OOMing.
> >
> > Reported-by: Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Should this be considered for stable?

Yes, I think so after all. Please see my reply to Roman.

> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks Shakeel!
