From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 05 Sep 2012 11:26:49 +0200
Message-ID: <1346837209.2600.14.camel@twins>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
	 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
	 <5047074D.1030104@parallels.com>
	 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <50470A87.1040701@parallels.com>
	 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <50470EBF.9070109@parallels.com>
	 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1346835993.2600.9.camel@twins>
	 <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <50471782.6060800@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <50471782.6060800@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com, ben@decadent.org.uk, pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org

On Wed, 2012-09-05 at 13:12 +0400, Glauber Costa wrote:
> On 09/05/2012 01:11 PM, Tejun Heo wrote:
> > Hello, Peter.
> >=20
> > On Wed, Sep 05, 2012 at 11:06:33AM +0200, Peter Zijlstra wrote:
> >> *confused* I always thought that was exactly what you meant with unifi=
ed
> >> hierarchy.
> >=20
> > No, I never counted out differing granularity.
> >=20
>=20
> Can you elaborate on which interface do you envision to make it work?
> They will clearly be mounted in the same hierarchy, or as said
> alternatively, comounted.
>=20
> If you can turn them on/off on a per-subtree basis, which interface
> exactly do you propose for that?

I wouldn't, screw that. That would result in the exact same problem
we're trying to fix. I want a single hierarchy walk, that's expensive
enough.

> Would a pair of cgroup core files like available_controllers and
> current_controllers are a lot of drivers do, suffice?

No.. its not a 'feature' I care to support for 'my' controllers.

I simply don't want to have to do two (or more) hierarchy walks for
accounting on every schedule event, all that pointer chasing is stupidly
expensive.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
