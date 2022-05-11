From: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcontrol: Export memcg->watermark via sysfs for
 v2 memcg
Date: Wed, 11 May 2022 09:17:37 +0530
Message-ID: <CAPD3tpG+ZP2uLGkaPJowQhKVkF11rrg1m6D-LjmG=66YP+VkUQ@mail.gmail.com>
References: <20220507050916.GA13577@us192.sjc.aristanetworks.com> <Ynsj6cZa8hUVYmhu@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8DfmonqPmvYWBc2QfJoYX1TyXXOUpf1yte699p2vRko=;
        b=c4ONip93EWQzvqAbNrC5br9qHeXBQotwUU/+5KtFhNPKs0hB+IhK/cPXNIhJ6bf+gz
         HTyItcafAX+evVodrDCAmEcII02ETvE6RVKHUV/EwSvbb6mwv2i7+duGWnnRexG9V2zm
         dLG3cOoVJaUktsvn2xeZwzf3byuxD31e43umqHPSJTjzpXg3wd78d7eUIAi2pSRR2uxa
         VphWkk86A6Mx+Y4upe/x9Cza7mmKeTsIf8Mu4Wq57pL28N6lbb2oku0BD1D5cybdKFtg
         riq51SeEyG0FBHpCmXhw2LBGqgogN5W7mnhULeFKMPidliiOMzC6LSf5LpJegE2Ws9Ir
         LHRw==
In-Reply-To: <Ynsj6cZa8hUVYmhu@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, May 11, 2022 at 8:18 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> On Fri, May 06, 2022 at 10:09:16PM -0700, Ganesan Rajagopal wrote:
> > We run a lot of automated tests when building our software and run into
> > OOM scenarios when the tests run unbounded. v1 memcg exports
> > memcg->watermark as "memory.max_usage_in_bytes" in sysfs. We use this
> > metric to heuristically limit the number of tests that can run in
> > parallel based on per test historical data.
> >
> > This metric is currently not exported for v2 memcg and there is no
> > other easy way of getting this information. getrusage() syscall returns
> > "ru_maxrss" which can be used as an approximation but that's the max
> > RSS of a single child process across all children instead of the
> > aggregated max for all child processes. The only work around is to
> > periodically poll "memory.current" but that's not practical for
> > short-lived one-off cgroups.
> >
> > Hence, expose memcg->watermark as "memory.peak" for v2 memcg.
> >
> > Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
>
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>
> I've been asked a couple of times about this feature, so I think it's indeed
> useful.
>
> Thank you for adding it!

You're welcome and thank you for the Ack. Thank you, Shakeel and
Johannes for the review and Ack. The patch has been picked up for
mm-unstable.

Ganesan
