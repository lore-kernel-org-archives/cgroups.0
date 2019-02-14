From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v7 0/7] freezer for cgroup v2
Date: Thu, 14 Feb 2019 17:30:19 +0100
Message-ID: <20190214163018.GD19102@redhat.com>
References: <20190212184807.20304-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190212184807.20304-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On 02/12, Roman Gushchin wrote:
>
>   - handle properly the case, when a task is both stopped and frozen

I didn't read this version yet, just looked at

	+static void cgroup_update_frozen(struct cgroup *cgrp)
	+{
	+	bool frozen;
	+
	+	lockdep_assert_held(&css_set_lock);
	+
	+	/*
	+        * If the cgroup has to be frozen (CGRP_FREEZE bit set),
	+        * and all tasks are frozen and/or stopped, let's consider
	+        * the cgroup frozen. Otherwise it's not frozen.
	+        */
	+	frozen = test_bit(CGRP_FREEZE, &cgrp->flags) &&
	+               cgrp->freezer.nr_frozen_tasks +
	+	        cgrp->freezer.nr_stopped_tasks >=
	+	        cgrp->freezer.nr_tasks_to_freeze;

if this is the only change which should handle this case correctly, I doubt it can
help. See another email I sent you a minute ago...

Oleg.

