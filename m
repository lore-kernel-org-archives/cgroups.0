From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 1 Dec 2021 06:39:34 -1000
Message-ID: <YaelRiqWOIzT5uRs@slm.duckdns.org>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
 <YaZbXArNIMNvwJD/@slm.duckdns.org>
 <2347fe66-dc68-6d58-e63b-7ed2b8077b48@redhat.com>
 <20211201141350.GA54766@blackbody.suse.cz>
 <ec6e2b89-385a-fcc7-7cfa-7e9119fc34bc@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1EkC39adlEEsimMF8WAtkbLkh0JLAwJ99PUzWQZRq4M=;
        b=S4K6E60fowwK12pVSXDSezUToCQTbvMryZ9jCQjZdt8YBwTBgNsYvIktXGYED/SMI3
         VgJF3XTd8qW6MKe9OMmyat1BHCQiLqnkvcPtTavJrnjPTjO6h4yQ8goQdWB22s3zocqK
         Wl5E8OgrGvetUa6XHhgvfrYB+vbkzprmjM4Gs6VW1+5q5391x/rHz6T8kzBfnj9MHpc8
         hOVO7aI27QXPDn6ABgwCkknX8xtE+H4KWIbm9ae6e9+4ddYjSkRirXz6ZDYR+ylg0/9q
         g9MJbO+Gy1BPaqtpOKsrNe9CzPYLfINyLm/U/Hayo9rNcrY1urCnq00+/Vl+Z/Sl93bS
         nVvA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ec6e2b89-385a-fcc7-7cfa-7e9119fc34bc@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

On Wed, Dec 01, 2021 at 09:56:21AM -0500, Waiman Long wrote:
> Right, I shouldn't say corner cases. Having task in an intermediate
> partition is possible depending on event sequence. I am aware that there =
are
> code in the cpuset code to prevent that, but it didn't block all cases.
> > > A valid parent partition may distribute out all its CPUs to
> > >  =A0its child partitions as long as there is no task associated with =
it.
> > Assuming there's always at least one kernel thread in the root cgroup
> > that can't be migrated anyway.]
>=20
> I am aware of that. That is why I said root cgroup must have at least one
> cpu in its "cpuset.cpus.effective".

In that case, let's explicitly describe that condition.

Thanks.

--=20
tejun
