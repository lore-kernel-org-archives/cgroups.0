From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 28 Aug 2023 10:28:44 -0700
Message-ID: <CAJD7tkZsGfYXkWM5aa67v3JytTO04LS7_x+ooMDK82cBZ-C8eQ@mail.gmail.com>
References: <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz> <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz> <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz> <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz> <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz> <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
 <CALvZod7uxDd3Lrd3VwTTC-SDvqhdj2Ly-dYVswO=TBM=XTnkcg@mail.gmail.com>
 <CAJD7tkbnvMCNfQwY_dmVe2SWR5NeN+3RzFhsVyimM1ATaX0D5A@mail.gmail.com> <599b167c-deaf-4b92-aa8b-5767b8608483@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693243761; x=1693848561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GK5Myctzb4HCvCqui3EYmx9STCukfjOIgPFjIqcI5UM=;
        b=hgb9hJyvPYXJPFVPXQqoDWYVcBGpnGf2FfMAOzQMsAjShJbPiYdKARkA/T4RsZyIiW
         DkLK54mV+iphr8e0TC+RidGAq3nyCQtFP1jkkeZ5QS1GkcHP7JCWL2isYlIBj8q9gwJ/
         tFwTFkCvysffsiw2k8NhzcxM8PGuuMnaMcSJ1LnpxpFd6DpCZXLUq1QjT1NYN2IKDCwO
         fyyKyjgCPP48aYY7Ct4QuKsTtvFQItIJDW+Kp80EyaAenhkpa0VtBX7iQGK346tsXq7t
         zbzjBwftI8myJAR8xiT43UZul7aJsbYAQgQudc0Sz5PBDSRBxytVH35F+CmNNr/5wNPp
         7/nw==
In-Reply-To: <599b167c-deaf-4b92-aa8b-5767b8608483@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Waiman Long <longman@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 28, 2023 at 10:27=E2=80=AFAM Waiman Long <longman@redhat.com> w=
rote:
>
>
> On 8/28/23 13:07, Yosry Ahmed wrote:
> >
> >> Here I agree with you. Let's go with the approach which is easy to
> >> undo for now. Though I prefer the new explicit interface for flushing,
> >> that step would be very hard to undo. Let's reevaluate if the proposed
> >> approach shows negative impact on production traffic and I think
> >> Cloudflare folks can give us the results soon.
> > Do you prefer we also switch to using a mutex (with preemption
> > disabled) to avoid the scenario Michal described where flushers give
> > up the lock and sleep resulting in an unbounded wait time in the worst
> > case?
>
> Locking with mutex with preemption disabled is an oxymoron. Use spinlock
> if you want to have preemption disabled. The purpose of usiing mutex is
> to allow the lock owner to sleep, but you can't sleep with preemption
> disabled. You need to enable preemption first. You can disable
> preemption for a short time in a non-sleeping section of the lock
> critical section, but I would not recommend disabling preemption for the
> whole critical section.

I thought using a mutex with preemption disabled would at least allow
waiters to sleep rather than spin, is this not correct (or doesn't
matter) ?

>
> Cheers,
> Longman
>
