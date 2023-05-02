From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 3 May 2023 00:27:24 +0200
Message-ID: <ZFGOTHQj3k5rzmyR@blackbook>
References: <ZDdYOI9LB87ra2t_@slm.duckdns.org>
 <9862da55-5f41-24c3-f3bb-4045ccf24b2e@redhat.com>
 <226cb2da-e800-6531-4e57-cbf991022477@redhat.com>
 <ZDmFLfII8EUX_ocY@slm.duckdns.org>
 <c61ca9d0-c514-fb07-c2f2-3629e8898984@redhat.com>
 <ZDmOjeBVsIcgSLIV@slm.duckdns.org>
 <60ec12dc-943c-b8f0-8b6f-97c5d332144c@redhat.com>
 <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
 <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
 <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683066446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VYMMl6QukjJ+AWKIxzwYKmP/x77nkL2kqwU3yC0/IAE=;
        b=twfR7/D1Mak2ce6QwCqeTdus/uNI/7WRnQBvtx+NzXxn0Fj5eKkbNVZAK7QhBvYLti8zL7
        AiNmE4199XoBMBtHzSn9dcoznncO9bmqgACe9SnzsjqwNTuCORcM6MUay4wJbyzTFM6rvZ
        bqUL4+t/6cqzpUiWOZiSFZkM3NHvDmY=
Content-Disposition: inline
In-Reply-To: <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>

On Tue, May 02, 2023 at 05:26:17PM -0400, Waiman Long <longman@redhat.com> =
wrote:
> In the new scheme, the available cpus are still directly passed down to a
> descendant cgroup. However, isolated CPUs (or more generally CPUs dedicat=
ed
> to a partition) have to be exclusive. So what the cpuset.cpus.reserve does
> is to identify those exclusive CPUs that can be excluded from the
> effective_cpus of the parent cgroups before they are claimed by a child
> partition. Currently this is done automatically when a child partition is
> created off a parent partition root. The new scheme will break it into 2
> separate steps without the requirement that the parent of a partition has=
 to
> be a partition root itself.

new scheme
  1st step:
  echo C >p/cpuset.cpus.reserve
  # p/cpuset.cpus.effective =3D=3D A-C (1)
  2nd step (claim):
  echo C' >p/c/cpuset.cpus # C'=E2=8A=86C
  echo root >p/c/cpuset.cpus.partition

current scheme
  1st step (configure):
  echo C >p/c/cpuset.cpus
  2nd step (reserve & claim):
  echo root >p/c/cpuset.cpus.partition
  # p/cpuset.cpus.effective =3D=3D A-C (2)

As long as p/c is unpopulated, (1) and (2) are equal situations.
Why is the (different) two step procedure needed?

Also the relaxation of requirement of a parent being a partition
confuses me -- if the parent is not a partition, i.e. it has no
exclusive ownership of CPUs but it can still "give" it to children -- is
child partition meant to be exclusive? (IOW can parent siblings reserve
some same CPUs?)

Thanks,
Michal
