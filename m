From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: FWD: cgroups: pids v5 patchset review
Date: Wed, 25 Mar 2015 07:31:47 +1100
Message-ID: <CAOviyaihmVVSPBOfZ+VRiyyVw9R5vE1vQ2xyJ0kAHN-xCg5NSw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The patchset (and all discussion) was not CC'd to the mailing list, so
here's a quick summary of the main points:

Tejun:
1. We should filter for_each_subsys using a bitmask (with a new helper
macro), so that the needs_*_callbacks aren't an all-in or all-out
thing for every subsystem.
2. We need to cancel_fork if we fail in the middle of a set of
can_forks that succeeded.
3. We should only revert/reapply for subsystems whose association
changed (and we should let the subsystem handle it).
4. We need to pin the css_set ref to make sure that it isn't freed
underneath us between can_fork, cancel_fork and post_fork.
4i. However, we should *really* be passing around an opaque pointer
(although I'm not sure how we should go about doing this).
5. Move the initialisation code to css_alloc, and drop css_online.
6. (RE: pids_try_charge failure) Revert up to and including the failed
css in the revert path to make the code cleaner.
7. Use PIDS_MAX* instead of PIDS_UNLIMITED* for the macro names.
8. Use the maximum value of pid_t, not PID_MAX_LIMIT as the maximum
value of the pids.max value.

Aleksa:
1. (RE: 4i) Why don't we just pass around an opaque struct pointer
that stores the css_set, and cgroups deals with bumping and dropping
the refcount of the css_set snapshot? This seems like we'd be passing
around the pids css *specifically* in the fork() path and passing it
into the generic callback.
2. (RE: 8) Where can I reference the maximum value of pid_t, should I
do some macro magic to calculate it?

Tejun:
1. (RE: 1) Different callbacks would have to be able to pass their own
opaque token. I'm not quite sure how this should be done. A naive
implementation would use an array of opaque pointers, but since not
every subsystem uses them this isn't very efficient.
2. (RE: 8) Just use INT_MAX for now.
3. Please FWD this discussion to the mailing lists with a summary.

--
Aleksa Sarai (cyphar)
www.cyphar.com
