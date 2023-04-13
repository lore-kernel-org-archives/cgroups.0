From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 20:55:55 -0400
Message-ID: <1b8d9128-d076-7d37-767d-11d6af314662@redhat.com>
References: <20230412153758.3088111-1-longman@redhat.com>
 <ZDcGVebCpyktxyWh@slm.duckdns.org>
 <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
 <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
 <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
 <ZDdG1K0kTETZMTCu@slm.duckdns.org>
 <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c@redhat.com>
 <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681347360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hRJHLQRX436psVY4dEg5oBAGIW2fFsn/wgOTxNFdgEo=;
        b=NgRsBlDxw6tHXbbdP5ueghd1h7Ed8t62lD6HFOmt6YPDljhjkYbMRRbb7CY4a/O+/vovTY
        vPcbruKUG2ekiceAcHOFuVt3XMQbmofo0rgTigRa/B3oe8PdL+B8B2ffENFNUYY4YHFu7A
        FhkdfqmSJ9UZfOV9eocIs43XgvGq6rw=
Content-Language: en-US
In-Reply-To: <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>


On 4/12/23 20:33, Tejun Heo wrote:
> Hello,
>
> On Wed, Apr 12, 2023 at 08:26:03PM -0400, Waiman Long wrote:
>>  =C2=A0 If the "cpuset.cpus.isolated" isn't set, the existing rules appl=
ies. If it
>> is set, the new rule will be used.
>>
>> Does that look reasonable to you?
> Sounds a bit contrived. Does it need to be something defined in the root
> cgroup?

Yes, because we need to take away the isolated CPUs from the effective=20
cpus of the root cgroup. So it needs to start from the root. That is=20
also why we have the partition rule that the parent of a partition has=20
to be a partition root itself. With the new scheme, we don't need a=20
special cgroup to hold the isolated CPUs. The new root cgroup file will=20
be enough to inform the system what CPUs will have to be isolated.

My current thinking is that the root's "cpuset.cpus.isolated" will start=20
with whatever have been set in the "isolcpus" or "nohz_full" boot=20
command line and can be extended from there but not shrank below that as=20
there can be additional isolation attributes with those isolated CPUs.

Cheers,
Longman

> The only thing that's needed is that a cgroup needs to claim CPUs
> exclusively without using them, right? Let's say we add a new interface
> file, say, cpuset.cpus.reserve which is always exclusive and can be consu=
med
> by children whichever way they want, wouldn't that be sufficient? Then,
> there would be nothing to describe in the root cgroup.
>
> Thanks.
>

