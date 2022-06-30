From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Fri, 1 Jul 2022 07:53:55 +0900
Message-ID: <Yr4pgxUTmg+UN35F@mtj.duckdns.org>
References: <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
 <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
 <YqarMyNo9oHxhZFh@slm.duckdns.org>
 <20220613142452.GB6910@blackbody.suse.cz>
 <YqdzuSQuAeiPXQvy@slm.duckdns.org>
 <20220613175548.GB21665@blackbody.suse.cz>
 <Yqd7WMFj6AEyV3Cy@slm.duckdns.org>
 <20220614115345.GA6771@blackbody.suse.cz>
 <YroApRMPV/6zO5I8@mtj.duckdns.org>
 <20220630143211.GA22105@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ywGXGSeAdHaxOG0hHw1tcJMSEkflmye5hh+2B4JWTp0=;
        b=mNLr4nkPZCDYuI2fSYGchP6gg6SX6mc4w6ytuuvcRaoApa6emQ7mzzj6Thc0PX2xjP
         5T20a8tNMdamJX78/HhIM+zs5fa6Sf4Z3eSCkhjArJSzl6mCGuicVAyrUpiIxC3WXyla
         HRNIlPRXxR1PaF6qZe2t4b/ZgygdqNI/KLflZGCJFfRCZnVIXU+74OCV19a4/JeCs8AF
         uWx7283rnfiPKAB/NTQLC0CPPqMpQ6uQSHJH/TCadJV/frfEIidBAI/UqsA5oRhHb8et
         R/8g3HAEmIz0tlGqHjiFSQxNcyvAgyO9T0QcwI+OTs0N8iGMSFt58HKXjRM6EDmaepP0
         0hVg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220630143211.GA22105@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

Hello,

On Thu, Jun 30, 2022 at 04:32:11PM +0200, Michal Koutn=FD wrote:
> file				owner
> parent/				user (mkdir)
> `- cpuset.cpus			root
> `- cpuset.cpus.partition	root	(P)
> `- child_1/			user
>   ` cpuset.cpus			user	(*)
> `- child_2/			user
>   ` cpuset.cpus			user	(*)
>=20
> The writes to child cpuset.cpus may/may not invalidate parent's (P)
> partition validity (whether a cpu is left to it to host possible tasks).
> child_1 vs child_2 overlap affects only whether the children cgroups are
> a valid partition.
>=20
> I think you mean: writes to children cpuset.cpus should be allowed,
> possible exclusivity violation should be reported in
> parent/cpuset.cpus.partition.

I see.

> What I thought was OK: prevent (fail) writes to children cpuset.cpus
> that'd violate the exclusivity (or would take the last cpu from parent
> if it's necessary to host a task).
> IMO, it's similar to failed writes to parent/cgroup.subtree_control in a
> delegated subtree if the parent still has some tasks (that'd violate
> internal node constraint).
>=20
> What I think might still be OK: allow writes to children cpuset.cpus
> that violate exclusivity and report that in children's
> cpuset.cpus.partition. Writes that'd take last cpu from parent should
> still fail (similar to the failing subtree_control writes above).

Yeah, this one.

So, here, one important question is who owns cpuset.cpus.partition
file - is it a konb which is owned by the parent like other resource
control knobs including cpuset.cpus or is it a knob which is owned by
the cgroup itself for selecting its own operation like cgroup.procs or
cgroup.subtree_control.

In the former case, the parent being able to say that "my children
can't overlap" makes sense although I'm not a big fan of the current
interface (again, who owns that knob?). In the latter case, it doesn't
really make sense cuz it'd be declaring "I can't make my children
overlap" - well, then, don't.

Thanks.

--=20
tejun
