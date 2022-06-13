From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 13 Jun 2022 07:28:25 -1000
Message-ID: <YqdzuSQuAeiPXQvy@slm.duckdns.org>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
 <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
 <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
 <YqarMyNo9oHxhZFh@slm.duckdns.org>
 <20220613142452.GB6910@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yv4/HdDYVjkX/YAztaZebjL1a0eQClbhVe6udK7q55Q=;
        b=R4KQhc65mAGubUVJTJuWOM9bF5a4E4aR2gWSHzop0dE6laiurPYFF44248RO1CN/49
         WGb5A/2tKnAUyTlNMto07nWaja1JSdE0p5FCaIOBCx0GpqRcN6UnwOfVVvtl9+g0krxZ
         UyaGiIURgykSXcIYLf9MJ59TgoMP3BburahgZgyuOCcoEL5Wno83fRLSagiwcmEG8Z7L
         t+D45/nsuHfvfQfooZUVeKI2gOrZlvXwlvj0TJmpMa5ttYI7M3o7z2+dC2wBOYu6NLWy
         f1G3g8SRqYk7jGR6uWZj9DZV2Cm8hnqHoeEfoRwikam2u3kgDwXnQ1m0xEMETKYD9EI3
         X91Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220613142452.GB6910@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

Hello,

On Mon, Jun 13, 2022 at 04:24:52PM +0200, Michal Koutn=FD wrote:
> On Sun, Jun 12, 2022 at 05:12:51PM -1000, Tejun Heo <tj@kernel.org> wrote:
> > On Sun, Jun 12, 2022 at 11:02:38PM -0400, Waiman Long wrote:
> > > That is the behavior enforced by setting the CPU_EXCLUSIVE bit in cgr=
oup v1.
> > > I haven't explicitly change it to make it different in cgroup v2. The=
 major
> > > reason is that I don't want change to one cpuset to affect a sibling
> > > partition as it may make the code more complicate to validate if a pa=
rtition
> > > is valid.
> >=20
> > If at all possible, I'd really like to avoid situations where a parent =
can't
> > withdraw resources due to something that a descendant does.
>=20
> My understanding of the discussed paragraph is that the changes are only
> disallowed only among siblings on one level (due to exclusivity rule,
> checked in validate_change()). A change in parent won't affect
> (non)exclusivity of (valid) children so it's simply allowed.
>=20
> So the docs (and implementation by a quick look) is sensible.

I see. Is this part even necessary? All the .cpus files of the siblings are
owned by the parent who's responsible for configuring both the mode that the
cgroup subtree is gonna be in and their cpumasks. Given that all the other
errors it can make are notified through "invalid (REASON)" in the mode file,
wouldn't it fit better to notify cpus configuration error the same way too?

Thanks.

--=20
tejun
