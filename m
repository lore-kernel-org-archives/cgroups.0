From: Christian Brauner <christian.brauner@canonical.com>
Subject: Re: [PATCH] cpuset: Allow cpuset controller in default hierarchy
Date: Fri, 25 Aug 2017 00:58:58 +0200
Message-ID: <20170824225857.ihxvcpgawb4fxda2@gmail.com>
References: <1503585611-13496-1-git-send-email-longman@redhat.com>
 <20170824144322.GP491396@devbig577.frc2.facebook.com>
 <863b01d0-e724-dab6-258e-d5980f985938@redhat.com>
 <20170824150222.GQ491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170824150222.GQ491396@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>, Serge Hallyn <serge@hallyn.com>

On Thu, Aug 24, 2017 at 08:02:22AM -0700, Tejun Heo wrote:
> Hello,
>=20
> On Thu, Aug 24, 2017 at 10:56:21AM -0400, Waiman Long wrote:
> > The main reason for sending out this patch is to figure out what exactly
> > is in your mind before enabling cpuset in v2.
> >=20
> > From my point of view, the exclusive setting makes cpuset behave more
> > like a resource domain that a resource allocated to one cgroup won't be
> > available for another cgroup. So we can argue it both ways whether it
> > violates the basic hierarchy rules or not.
>=20
> It's not even siblings interfering with other siblings.  The resource
> knobs belong to the parent, right?  So, the only thing it's doing is
> restricting the parent itself from creating certain configurations,
> which can be argued to be a feature but it's a really weird policy
> enforcement implemented in kernel.
>=20
> > I will be in the Plumbers Conference next month and we can talk more
> > about this. My goal is to make cgroup v2 ready for prime time hopefully
> > by the end of the year.

Hi,

I've been following this thread and the cpuset controller being enabled on
cgroup v2 is a really important step. As one of many container runtime
maintainers this is obviously a big step for us with a lot of impact. It'd =
be
really nice if we could have a little little discussion just to see what the
plan is like and what sort of features are going to expose to userspace. Th=
is is
all a very rapid development which is good. I'd just like to make sure to k=
now
what we're in for. Sort of like what we did last year at Plumber but less
offical and without microphones and the overhead of having hundreds of peop=
le in
the room. :) Also it likely be way more relaxed given that a lot of the pro=
blems
dicussed back then seem to have been resolved.

CCing Serge and St=C3=A9phane. :)

Thanks!
Christian

>=20
> Sure, the only thing I think we need for cpuset is cutting down the
> interface to the minimal set which provides all the features to
> userspace.
>=20
> Thanks.
>=20
> --=20
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
