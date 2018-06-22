From: David Howells <dhowells@redhat.com>
Subject: Re: [16/32] kernfs, sysfs, cgroup, intel_rdt: Support fs_context [ver #8]
Date: Fri, 22 Jun 2018 13:52:16 +0100
Message-ID: <29799.1529671936@warthog.procyon.org.uk>
References: <20180621184754.GB21326@outlook.office365.com> <152720682792.9073.14747437198191460035.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621184754.GB21326@outlook.office365.com>
Content-ID: <29798.1529671936.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Andrei Vagin <avagin@virtuozzo.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

Andrei Vagin <avagin@virtuozzo.com> wrote:

>                 ret = 0;
> +               ctx->root = root;
>                 goto out_unlock;

Okay, I can see that.

>                 percpu_ref_reinit(&root->cgrp.self.refcnt);
>                 mutex_unlock(&cgroup_mutex);
>         }
> +       cgroup_get(&root->cgrp);

This probably needs to be conditional on ret == 0.

Which version are you testing btw?  The patches in git have been fixed a
little from what was last posted.

David
