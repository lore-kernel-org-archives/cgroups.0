From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Wed, 14 Mar 2018 12:57:11 -0700
Message-ID: <20180314195711.GD2943022@devbig577.frc2.facebook.com>
References: <1520609707-16582-1-git-send-email-longman@redhat.com>
 <1520613285.12489.36.camel@gmx.de>
 <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
 <1520619426.27998.18.camel@gmx.de>
 <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
 <1520624424.27998.76.camel@gmx.de>
 <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
 <20180309221736.GB5926@hirez.programming.kicks-ass.net>
 <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
 <1520653648.12749.20.camel@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=mNzR5KMENUVyWqgjSK1EivG7Spr6h4RxAlgh2Yc24WM=;
        b=XTvqYQXK1C1k9E21UsRSJOZN/kIIyps4bpjY0Qon060BgZjLa97m9DhwCdsw6xpKaL
         v6kTgRV0HG1aGOUvExuxD89UmM8piax+7xnkbxX1mkxRAyQmAWsDhoixas0TAz3oPjsD
         APqP4YEDdUXG+lyOULY18qKn+/cN3AZWIt9mKem3HgQxHcNdV03fPVVl32sL1uJZejkE
         1bKwJU4wWxOaG2pO1vM1/S9a2nUUdsHjKnofq+lpBvPg7KtRVIC8aPvmV9tqrwSX3EAm
         fImguSpAIVjBIWVvKdg0s4JdxAQ6eVcZBDycC9PwMRb5fpKrqAh0QUWQnEssc5RaDEze
         UYwg==
Content-Disposition: inline
In-Reply-To: <1520653648.12749.20.camel@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Mike Galbraith <efault@gmx.de>
Cc: Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

Hello,

On Sat, Mar 10, 2018 at 04:47:28AM +0100, Mike Galbraith wrote:
> Some form of cpu_exclusive (preferably exactly that, but something else
> could replace it) is needed to define sets that must not overlap any
> other set at creation time or any time thereafter. =A0A set with property
> 'exclusive' is the enabler for fundamentally exclusive (but dynamic!)
> set properties such as 'isolated' (etc etc).

I'm not sure cpu_exclusive makes sense.  A controller knob can either
belong to the parent or the cgroup itself and cpu_exclusive doesn't
make sense in either case.

1. cpu_exclusive is owned by the parent as other usual resource
   control knobs.  IOW, it's not delegatable.

   This is weird because it's asking the kernel to protect against its
   own misconfiguration and there's nothing preventing cpu_exclusive
   itself being cleared by the same entitya.

2. cpu_exclusive is owned by the cgroup itself like memory.oom_group.
   IOW, it's delegatable.

   This allows a cgroup to affect what its siblings can or cannot do,
   which is broken.  Semantically, it doesn't make much sense either.

I don't think it's a good idea to add a kernel mechanism to prevent
misconfiguration from a single entity.

Thanks.

--=20
tejun
