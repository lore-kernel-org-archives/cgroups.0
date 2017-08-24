From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] cpuset: Allow cpuset controller in default hierarchy
Date: Thu, 24 Aug 2017 19:33:11 +0200
Message-ID: <1503595991.5278.11.camel@gmx.de>
References: <1503585611-13496-1-git-send-email-longman@redhat.com>
         <20170824144322.GP491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170824144322.GP491396@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2017-08-24 at 07:43 -0700, Tejun Heo wrote:
> Hello, Waiman.
>=20
> On Thu, Aug 24, 2017 at 10:40:11AM -0400, Waiman Long wrote:
> > Given the fact that thread mode is now queued for 4.14, it is now
> > time to enable cpuset to be used in the default hierarchy (cgroup v2)
> > as it is clearly threaded.
>=20
> I'm not sure we want things like exclusive settings in v2 as it
> directly violates basic hierarchy rules (a sibling shouldn't be able
> to affect what another sibling can or can't do).  We need to think
> more about what should be exposed in v2.

I was wondering when this was gonna come up. =C2=A0The cpu/cpuacct stuff
seems well on its way to resolution, but partitioning (critical) is sti
ll dangling in the breeze.

	-Mike
