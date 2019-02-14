From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v6 4/7] cgroup: cgroup v2 freezer
Date: Thu, 14 Feb 2019 16:41:05 +0000
Message-ID: <20190214164100.GA8688@tower.DHCP.thefacebook.com>
References: <20181222000307.28231-1-guro@fb.com>
 <20181222000307.28231-5-guro@fb.com> <20190125122713.GA18218@redhat.com>
 <CALo0P13XnGiFykMXY3ZKu158ZqnBwHru0gyhQUrJSHEprnmiHQ@mail.gmail.com>
 <20190130165200.GA4131@redhat.com>
 <20190211213036.GA26063@tower.DHCP.thefacebook.com>
 <20190214162612.GC19102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KPdz73e855N+NeDZITgo6wZDKYSeeAFYIkTCWfsaUEc=;
 b=TPFr9EhP9LO8QuYm2evzCxLCMAgf6LHZ/oAv5epvaKmgZHI9AKNH9uYYQd31iRZDTw5J
 cyi9JcOBo3jOELdGKUZ2eHuesmuls+dHWPphasyrA+Xgxg9fLFzhhBfZ1aqan3KF8Vkq
 apyYLAP0XKdtX47l1ELPzEBBGroWMNxKG7U= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPdz73e855N+NeDZITgo6wZDKYSeeAFYIkTCWfsaUEc=;
 b=PEF4hkBlFsDENBpmjc/Y7In4d/neXHATSqQYkXRTiCdqKjnY4Sxwi/OPCoklfhryhX1M4qBLac72Pp+Gkp6t68rtQxgPRVfaxwdQj4i4S++ax3gpr8JdL1RDB2QS3p12GPhCysbYJn+KAADampMhAyxzCi9hIGIPy6WsRBMGya8=
In-Reply-To: <20190214162612.GC19102@redhat.com>
Content-Language: en-US
Content-ID: <D3889F53817B344196DC0BAE5EFAC3AC@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Feb 14, 2019 at 05:26:13PM +0100, Oleg Nesterov wrote:
> On 02/11, Roman Gushchin wrote:
> >
> > On Wed, Jan 30, 2019 at 05:52:01PM +0100, Oleg Nesterov wrote:
> > >
> > > Worse, this looks just wrong. In the latter case, cgroup becomes CGRP=
_FROZEN
> > > right after a 2nd task migrates to this cgroup, before this new task =
calls
> > > do_freezer_trap() or cgroup_enter_stopped().
> >
> > You're right. So, it looks like the problem is in the equation
> > nr_tasks_frozen + nr_tasks_stopped =3D=3D nr_tasks_to_freeze ,
> > because a task can be frozen and stopped simultaneously.
> >
> > So, basically it has to be
> > nr_tasks_frozen + nr_tasks_stopped >=3D nr_tasks_to_freeze instead.
>=20
> It seems you didn't read the paragraph above, or I missed something...
>=20
> How can "frozen + stopped >=3D to_freeze" fix the problem with the falsel=
y true
> CGRP_FROZEN ?

It helps with the problem when cgroup is mistakenly reported as non-frozen,
and adding a task makes it frozen due to increased nr_tasks_to_freeze.

But you're right, it's not correct. I have to think more how to make
the accounting work correctly with stopped tasks.

Roman
