From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Tue, 29 Aug 2023 09:04:37 -0700
Message-ID: <CAJD7tkZ45VDjYyorgZ38unRkMeoy44OcCpPq_kdnMWEam3vssA@mail.gmail.com>
References: <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz> <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz> <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
 <CALvZod7uxDd3Lrd3VwTTC-SDvqhdj2Ly-dYVswO=TBM=XTnkcg@mail.gmail.com>
 <CAJD7tkbnvMCNfQwY_dmVe2SWR5NeN+3RzFhsVyimM1ATaX0D5A@mail.gmail.com>
 <599b167c-deaf-4b92-aa8b-5767b8608483@redhat.com> <ZO2d7dT8gulMyb8g@dhcp22.suse.cz>
 <5906501e-4dff-4c66-7ab3-e9193d312270@redhat.com> <ZO4MBNzsbhsi7adb@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693325114; x=1693929914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z79jhU7o/NUfJHuqLql7WhGDUVVNML8fOs/maDU7iyc=;
        b=HU/WionO7dHsradhblbEvF6SjWyz4OqPBhbtHC38sImO18QxSafcV5WjAP1HOaS88J
         rilbruX+yteYYkDBba6T/dOAbY5kVTXRyrLxtGcWAGkk47x8gDLQ6AJ1EQn9badyKsj9
         4Pj9lLwH6jStEmJipnLzXkgT9BdZUA7ob0Zy5yu6uXq85H26G+ggQS8FZhbieVjA0cHV
         50n570Yo0XzxwoYhkim7ah5t+gCGhoLXmfYrILMAeYyDdhAKpEKjc3mZsRbw1YoWWEml
         DzRd7bpK8CWPfob+UoExg1LMpr+yo8Yya+uJh3V+vhWVBxtOFdggG+lOB1291kz9XgW2
         xpMA==
In-Reply-To: <ZO4MBNzsbhsi7adb-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 29, 2023 at 8:17=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Tue 29-08-23 11:05:28, Waiman Long wrote:
> > On 8/29/23 03:27, Michal Hocko wrote:
> > > On Mon 28-08-23 13:27:23, Waiman Long wrote:
> > > > On 8/28/23 13:07, Yosry Ahmed wrote:
> > > > > > Here I agree with you. Let's go with the approach which is easy=
 to
> > > > > > undo for now. Though I prefer the new explicit interface for fl=
ushing,
> > > > > > that step would be very hard to undo. Let's reevaluate if the p=
roposed
> > > > > > approach shows negative impact on production traffic and I thin=
k
> > > > > > Cloudflare folks can give us the results soon.
> > > > > Do you prefer we also switch to using a mutex (with preemption
> > > > > disabled) to avoid the scenario Michal described where flushers g=
ive
> > > > > up the lock and sleep resulting in an unbounded wait time in the =
worst
> > > > > case?
> > > > Locking with mutex with preemption disabled is an oxymoron.
> > > I believe Yosry wanted to disable preemption _after_ the lock is take=
n
> > > to reduce the time spent while it is held. The idea to use the mutex =
is
> > > to reduce spinning and more importantly to get rid of lock dropping
> > > part. It is not really clear (but unlikely) we can drop it while
> > > preserving the spinlock as the thing scales with O(#cgroups x #cpus)
> > > in the worst case.
> >
> > As I have said later in my email, I am not against disabling preemption
> > selectively on some parts of the lock critical section where preemption=
 is
> > undesirable. However, I am against disabling preemption for the whole
> > duration of the code where the mutex lock is held as it defeats the pur=
pose
> > of using mutex in the first place.
>
> I certainly agree this is an antipattern.

So I guess the verdict is to avoid using a mutex here for now. I sent
a v2 which includes an additional small patch suggested by Michal
Koutny and an updated changelog for this patch to document this
discussion and possible alternatives we can do if things go wrong with
this approach:

https://lore.kernel.org/lkml/20230828233319.340712-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
