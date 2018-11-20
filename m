From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 4/7] cgroup: cgroup v2 freezer
Date: Tue, 20 Nov 2018 16:33:11 +0000
Message-ID: <20181120163304.GA21462@tower.DHCP.thefacebook.com>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-5-guro@fb.com>
 <20181120162529.GU2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1QWNwXk+d7gvnjiLHK8+lTv5uCYNdFQcPLt4U9dAXPg=;
 b=MlFk8xXirmkwe93vaKWWevEovJ2oWhsgEmtylHyNGoZ4NlXyDWEqVTQqIcYuM1Bmd5oa
 CzMz80ye4CaUe8XldnqndfFOWjkJ/yiTxSnEUF21areK7akSqe8e6upYWLuFTfELvsVr
 oEwfyy6ZcYL9H4hgekOHTT5yV0gJjAZWj6o= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QWNwXk+d7gvnjiLHK8+lTv5uCYNdFQcPLt4U9dAXPg=;
 b=YzFnXuXTuAQ/WY5FSRJyeJneSTJ0rh87V69wRjWqJ5ZbWRAMmhdHbpfvzlw8Pic5xkmdRPA/fFcE2+TZ04JlHXojsZImGLgdnAeSwxSZ87rQVTBsEHwyIXWaCWF02I7KLQEQTZtiN4dyKGZ6xMzkRRF4c1PriTZMXYT/E5dZB5s=
In-Reply-To: <20181120162529.GU2509588@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <BF46CAD78D143D44BEF5C9251F9041F1@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Nov 20, 2018 at 08:25:29AM -0800, Tejun Heo wrote:
> On Fri, Nov 16, 2018 at 04:38:27PM -0800, Roman Gushchin wrote:
> > +void cgroup_freezer_migrate_task(struct task_struct *task,
> > +				 struct cgroup *src, struct cgroup *dst)
> > +{
> > +	lockdep_assert_held(&css_set_lock);
> > +
> > +	/*
> > +	 * Kernel threads are not supposed to be frozen at all.
> > +	 */
> > +	if (task->flags & PF_KTHREAD)
> > +		return;
> > +
> > +	/*
> > +	 * Adjust counters of freezing and frozen tasks.
> > +	 */
> > +	if (test_bit(CGRP_FREEZE, &src->flags)) {
> > +		src->freezer.nr_tasks_to_freeze--;
> > +		WARN_ON_ONCE(src->freezer.nr_tasks_to_freeze < 0);
> > +	}
> > +
> > +	/*
> > +	 * If the task is frozen, let's bump nr_tasks_to_freeze even
> > +	 * if the target cgroup isn't frozen: the counter will be decreased
> > +	 * in cgroup_leave_frozen().
> > +	 */
> > +	if (test_bit(CGRP_FREEZE, &dst->flags) || task->frozen)
> > +		dst->freezer.nr_tasks_to_freeze++;
> > +
> > +	if (task->frozen) {
> > +		src->freezer.nr_frozen_tasks--;
> > +		dst->freezer.nr_frozen_tasks++;
> > +		WARN_ON_ONCE(src->freezer.nr_frozen_tasks < 0);
> > +		WARN_ON_ONCE(dst->freezer.nr_frozen_tasks >
> > +			     dst->freezer.nr_tasks_to_freeze);
> > +	}
>=20
> If a non-frozen task is being moved into a frozen cgroup, shouldn't
> that also trigger frozen state update?

It does! Just below these lines:

	/*
	 * If the task isn't in the desired state, force it to it.
	 */
	if (task->frozen !=3D test_bit(CGRP_FREEZE, &dst->flags))
		cgroup_freeze_task(task, test_bit(CGRP_FREEZE, &dst->flags));


It's also covered by the 5th kselftest.

Thanks!
