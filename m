From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] sched: add throttled time stat for throttled children
Date: Tue, 20 Jun 2023 11:28:21 -0700
Message-ID: <CABk29NtvNzG3A8CUXwukpRx65Drqynhr+agCcQG23qZVD7FqPw@mail.gmail.com>
References: <20230612232748.3948659-1-joshdon@google.com> <20230612232748.3948659-2-joshdon@google.com>
 <rs46fzspb2w46zcbgdjysqd2rcfqs4yk55xyf5syvnf75rjhfe@ku6i5chn5qrq>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687285713; x=1689877713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFbvkXsr4CwoXTBxubkyGQRrKVV7vjMo0YaS6cmSpvY=;
        b=s/c6tS2ooBamHjhW13lHYSQjuiL9w2u4j7wJkYXgvTp4qV2mzF6TcixK0rWzgIBnoW
         BstA/5FFTmUREVNKPxBC8p5k0unaa8BO4lbwg5+5HaWBTQ+EyIQcHvsqcdJke/3TcuH3
         q7pQHBT3Q6mhkyumpKUrcMMGdRlva7pmkR2tnUFFt+c7aCgwq0rR5RJIJ1pnPEIcE0Rk
         tDA3F7vlTCotGqsQJzU06iJwGm5oDGmLFEWRL4CuoogKHzHZzyaw5LBQ6XK8fmVFSBBj
         +MzONGmtCK3l/t2go7eX0LhtSbV+a6o9DZlaxEQEU4/qUt4wTv/xrw9OqtlbS0sxRtQ0
         bEgg==
In-Reply-To: <rs46fzspb2w46zcbgdjysqd2rcfqs4yk55xyf5syvnf75rjhfe@ku6i5chn5qrq>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xiangling Kong <xiangling-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Michal,

On Mon, Jun 19, 2023 at 10:53=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.c=
om> wrote:
>
> On Mon, Jun 12, 2023 at 04:27:48PM -0700, Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> w=
rote:
> > We currently export the total throttled time for cgroups that are given
> > a bandwidth limit.
>
> I assume you refer to cpu.stat:throttled_usec (from struct
> cfs_bandwidth) -- notice that the value is not properly hierarchical
> despite v2 filename.
>
> > This patch extends this accounting to also account the total time that
> > each children cgroup has been throttled.
>
> IIUC, this is visible on inner-nodes cpu cgroups (i.e. with no tasks)?
>
> IOW, wouldn't you get the intended information if hierarchical summing
> was added/fixed for cpu.stat:throttled_usec?

It isn't currently hierarchical in the sense that the inner-nodes
don't themselves account their throttled time, but the summation at
the top is still correct. This patch is intended to close the gap. I
suppose your question here is why not simply make the existing
throttled_usec export properly hierarchical, and avoid the extra stat
export here. I think it might be useful to still expose a
non-hierarchical metric indicating the throttled time due to the
group's own configured limit; the accounting can look strange with
nested bandwidth limits. Not strongly opposed to the idea, but your
hierarchical accounting proposal is essentially what this patch adds.
