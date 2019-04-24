From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Wed, 24 Apr 2019 22:10:39 +0000
Message-ID: <20190424221034.GB22896@tower.DHCP.thefacebook.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com> <20190424160237.GH16167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wN0uqsOEAlN5gbm42aioBCXkRH3nbdzfGrpFjkDuuC0=;
 b=MpIWquBjh/jiJKO1IO6zE7Zf4pifcKqHvci/TrFOiUPM8PXcJ7japOF7cLMwsXrr+5sJ
 HyOXWQaoLYcxG1JgzDWnW/GssXG0OVolOUSNqRtc+X30mCYTmWV0s5W4Yd+I0cXQfv4b
 i7pTmpySbGNnYas76ZpeLvymdMx9y51p3nU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wN0uqsOEAlN5gbm42aioBCXkRH3nbdzfGrpFjkDuuC0=;
 b=OhbFAyqg98LTgVFSVM7/u9iY5DhfYA/EvGYKfZAU/PBvGTRIR1+zPH2eyZhG7YW12VoWVohsVYQbeZ3yex/hORx0bUq0hBDnsHrPbXJAGngP4CqxmdjD1UZK8DIPwJx5UUYmsSzXFnXaGmr8QgRBwN4qwHe2PevYAmw43sN36kM=
In-Reply-To: <20190424160237.GH16167@redhat.com>
Content-Language: en-US
Content-ID: <035051AE993AB54E989E234EC71E7440@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, Apr 24, 2019 at 06:02:38PM +0200, Oleg Nesterov wrote:
> On 04/05, Roman Gushchin wrote:
> >
> > @@ -5830,6 +5926,12 @@ void cgroup_exit(struct task_struct *tsk)
> >  		spin_lock_irq(&css_set_lock);
> >  		css_set_move_task(tsk, cset, NULL, false);
> >  		cset->nr_tasks--;
> > +
> > +		if (unlikely(cgroup_task_frozen(tsk)))
> > +			cgroup_freezer_frozen_exit(tsk);
> > +		else if (unlikely(cgroup_task_freeze(tsk)))
> > +			cgroup_update_frozen(task_dfl_cgroup(tsk));
> > +

Hello, Oleg!

A good catch! It's actually a leftover from one of the previous versions
of the patchset. In the current iteration I'd replace it with:

	WARN_ON_ONCE(cgroup_task_frozen(tsk));

just to make sure we're not leaking the frozen bit.
Do you agree?

Thank you!

Roman
