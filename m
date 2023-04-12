From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 10:22:23 -1000
Message-ID: <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
References: <20230412153758.3088111-1-longman@redhat.com>
 <ZDcGVebCpyktxyWh@slm.duckdns.org>
 <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681330945; x=1683922945;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yu2Dt9jJPuiCFFL8ILGJGVl5zgqQrKcJL03w0OHhJOI=;
        b=Ci8M+KzEkrHqeQxO/tndGcOSzpGiOY1qY8jnZMCv3LEbIRy1ZBZPfioPbFKwOSXfcv
         TF2Q6ICj/3ro+Q+D6DA1OPKj4KFoeAoUDfXnbdmYn6LKKyzYt1tipZlEZkxLysCiteM7
         nGdQPOKFrpEKxt/bL4qceuGyRY1HTfJ5uLQRANULDdPl9MyiAuDKdDHGGgIKkiyhhnxf
         GX0szzqLngq3xUQA90p+LgPLA1BP3pPAE8OKJADsoBs0xIM4OD+ll/C7Xl5bWBvsKba9
         J8FzFgvko4RtmNbuv5DLadsWtravAIywPfnuhYkzP6hTkyzsrJvcyEixc5SE3zDhpnqJ
         MJYQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>

Hello, Waiman.

On Wed, Apr 12, 2023 at 03:52:36PM -0400, Waiman Long wrote:
> There is still a distribution hierarchy as the list of isolation CPUs have
> to be distributed down to the target cgroup through the hierarchy. For
> example,
>=20
> cgroup root
> =A0 +- isolcpus=A0 (cpus 8,9; isolcpus)
> =A0 +- user.slice (cpus 1-9; ecpus 1-7; member)
> =A0=A0=A0  +- user-x.slice (cpus 8,9; ecpus 8,9; isolated)
>      +- user-y.slice (cpus 1,2; ecpus 1,2; member)
>=20
> OTOH, I do agree that this can be somewhat hacky. That is why I post it a=
s a
> RFC to solicit feedback.

Wouldn't it be possible to make it hierarchical by adding another cpumask to
cpuset which lists the cpus which are allowed in the hierarchy but not used
unless claimed by an isolated domain?

Thanks.

--=20
tejun
