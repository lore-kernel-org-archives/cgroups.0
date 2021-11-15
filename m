From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 15 Nov 2021 16:27:57 -0500
Message-ID: <1426905d-f93a-7500-177b-a8e0fae467ab@redhat.com>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz> <YZK/A43T+zvu89dl@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637011689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eB9LIJ8wftWZtVC2tmoTuif+x3rpeL1vcMWkA0vO7Oo=;
        b=ixnw1mcTr19CdHQ0ch6Echv3BASAZnVEpZz0YjCPK9eKtIejvUoakitYWPPQVES4nM6EBK
        lk3l1ex7YCZJpwRdstvJlmwg2ksU5s+O7cmnjibbHb+BPc0ydoK8s5MB0jLOLs5g8Ez81s
        hrniOiO5d6CQB15ETzGKuLWEN0nELrU=
Content-Language: en-US
In-Reply-To: <YZK/A43T+zvu89dl@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>


On 11/15/21 15:11, Tejun Heo wrote:
> Hello,
>
> On Mon, Nov 15, 2021 at 08:31:22PM +0100, Michal Koutn=C3=BD wrote:
>> Now to the constraints and partition setups. I think it's useful to have
>> a model with which the implementation can be compared with.
>> I tried to condense some "simple rules" from the descriptions you posted
>> in v8 plus your response to my remarks in v7 [2]. These should only be
>> the "validity conditions", not "transition conditions".
> FWIW, my opinion is pretty much in line with Michal's in this regard. Oth=
er
> than that, everything looks pretty good to me.

Yes, I am going to streamline the documentation as suggested to make it=20
easier to understand.

Coding-wise, do you have other changes you want me to make?

Thanks,
Longman

