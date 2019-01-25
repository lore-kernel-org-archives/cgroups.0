From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v6 4/7] cgroup: cgroup v2 freezer
Date: Fri, 25 Jan 2019 14:46:00 +0100
Message-ID: <20190125134600.GB18991@redhat.com>
References: <20181222000307.28231-1-guro@fb.com>
 <20181222000307.28231-5-guro@fb.com>
 <20190125122713.GA18218@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190125122713.GA18218@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On 01/25, Oleg Nesterov wrote:
>
> One of the task is killed, it calls leave_frozen(). If I read this code path
> correctly, only ->nr_frozen_tasks will be decremented, so "frozen" will be
> "false" when cgroup_update_frozen() is called.

forgot to mention...

and I do not think cgroup_exit() can "fix" this, see another email I sent a minute
ago...

Oleg.

