From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 20:26:03 -0400
Message-ID: <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c@redhat.com>
References: <20230412153758.3088111-1-longman@redhat.com>
 <ZDcGVebCpyktxyWh@slm.duckdns.org>
 <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
 <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
 <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
 <ZDdG1K0kTETZMTCu@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681345565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=haXTThtMgpsseSV6p+uwEaprdsyUVtg4Cg56AUYX6Mw=;
        b=atY2hVPcYAmNrssV1TOHzKcBSBD5RX/xyhdodRoEyHsMVL+qe5ytCyE4Qk7rCdKrEmeEfB
        rCXEXPjnn4hE1il+To8Zm5jkDNJjbfV/rnH5yYeAgTkZVtwEN049ful64Xw6qNK9eZ7uJx
        FVXiUq7mTMLSU2vKsWzXZdBhtX6wQMA=
Content-Language: en-US
In-Reply-To: <ZDdG1K0kTETZMTCu@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>


On 4/12/23 20:03, Tejun Heo wrote:
> Hello,
>
> On Wed, Apr 12, 2023 at 04:33:29PM -0400, Waiman Long wrote:
>> I think we can. You mean having a new "cpuset.cpus.isolated" cgroupfs fi=
le.
>> So there will be one in the root cgroup that defines all the isolated CP=
Us
>> one can have. It is then distributed down the hierarchy and can be claim=
ed
>> only if a cgroup becomes an "isolated" partition. There will be a slight
> Yeah, that seems a lot more congruent with the typical pattern.
>
>> change in the semantics of an "isolated" partition, but I doubt there wi=
ll
>> be much users out there.
> I haven't thought through it too hard but what prevents staying compatible
> with the current behavior?

It is possible to stay compatible with existing behavior. It is just=20
that a break from existing behavior will make the solution more clean.

So the new behavior will be:

 =C2=A0 If the "cpuset.cpus.isolated" isn't set, the existing rules applies=
.=20
If it is set, the new rule will be used.

Does that look reasonable to you?

Cheers,
Longman

