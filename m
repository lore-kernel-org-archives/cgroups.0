From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 2/6] cgroup/cpuset: Properly handle partition root tree
Date: Fri, 13 Aug 2021 06:07:11 -1000
Message-ID: <YRaYr0sf9L1GY7i5@mtj.duckdns.org>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-3-longman@redhat.com>
 <YRQSKZB8rQUsfF2K@slm.duckdns.org>
 <b7897818-8fe6-8dd8-3ff6-6b15401162ba@redhat.com>
 <YRWeQH6gY5PqIanD@slm.duckdns.org>
 <55f61b66-5159-7e13-6e41-33df042612b0@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2HZmfNWRvGEoCRS06cZMTLlzgFfVxMJbsV7IaJqnVhg=;
        b=InkfaLY0ZCFXGoifgEOs48VdU5Jc2nx9zdixJj7MXoz71NPOd9R/5Djc+ydBfpFtC4
         U7i7R7lQHGegengPSWbI6FBgclDyJ+QYg9Y3rQAL5n4XXy6FmCv4P2ja1DedF1M1k566
         3sQ7P/9K4G8wvzRsUlBkW+9SrhtPKBNAMQIUziuOLTeiSRAaIgzdb+NO+xIj9Dhc1DlX
         +GT31B2T0I3oFoJ4SlosCJtzNHRwgl6oRkFCvuePaOQ06nPvp5u1k73RPa/4MkwkiXja
         NzXKhkthXwFpZyoJSqkiBLKSmxL/qsBDP4SY9Uou84ybT+2MWIlJibdv8EG0Y4da47oA
         xN3A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <55f61b66-5159-7e13-6e41-33df042612b0@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <llong@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Thu, Aug 12, 2021 at 06:56:00PM -0400, Waiman Long wrote:
> That sounds reasonable. My current idea is to add invalid partition reason
> string to cpuset. So when users read cpuset.cpus.partition of an invalid
> partition, it will read something like "root invalid=A0 (<reason>)".
>=20
> What do you think?

Sounds good to me.

Thanks.

--=20
tejun
