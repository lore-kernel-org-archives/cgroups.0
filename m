From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 7/7] cgroup: implement the PIDs subsystem
Date: Sat, 6 Jun 2015 05:57:29 +1000
Message-ID: <CAOviyaji+nEt53PSnyyX_LnWw5FE2p9AbdZrYz6eH2xcWuZCNw@mail.gmail.com>
References: <1431749621-30451-1-git-send-email-cyphar@cyphar.com>
	<1431749621-30451-8-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431749621-30451-8-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Hello Tejun,

Is it safe for us to task_get_css() every task in the tset in
->can_attach() and then put_css() in ->attach() and ->cancel_attach()?
In other words: if we have a ref to a task's css, are we guaranteed
that the task_css() will return the same thing every time? Here's what
I'm currently doing:

static int pids_can_attach(struct cgroup_subsys_state *css,
                           struct cgroup_taskset *tset)
{
        struct pids_cgroup *pids = css_pids(css);
        struct task_struct *task, *fail_task;
        int err;

        cgroup_taskset_for_each(task, tset) {
                struct cgroup_subsys_state *old_css;
                struct pids_cgroup *old_pids;

                old_css = task_get_css(task, pids_cgrp_id);
                old_pids = css_pids(old_css);

                err = pids_try_charge(pids, 1);
                if (err)
                        goto out_fail;

                pids_uncharge(old_pids, 1);
                continue;

out_fail:
                fail_task = task;
                goto err_revert;
        }

        return 0;

err_revert:
        cgroup_taskset_for_each(task, tset) {
                css_put(task_css(task, pids_cgrp_id));
                if (task == fail_task)
                        break;
                pids_uncharge(pids, 1);
        }

        return err;
}

static void pids_cancel_attach(struct cgroup_subsys_state *css,
                               struct cgroup_taskset *tset)
{
        struct pids_cgroup *pids = css_pids(css);
        struct task_struct *task;

        cgroup_taskset_for_each(task, tset) {
                struct cgroup_subsys_state *old_css;
                struct pids_cgroup *old_pids;

                old_css = task_css(task, pids_cgrp_id);
                old_pids = css_pids(old_css);

                pids_charge(old_pids, 1);
                pids_uncharge(pids, 1);
                css_put(old_css);
        }
}

static void pids_attach(struct cgroup_subsys_state *css,
                        struct cgroup_taskset *tset)
{
        struct task_struct *task;

        cgroup_taskset_for_each(task, tset)
                css_put(task_css(task, pids_cgrp_id));
}


--
Aleksa Sarai (cyphar)
www.cyphar.com
