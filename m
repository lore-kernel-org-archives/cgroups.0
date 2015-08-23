From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: RE: Bad Reference Semantics in PIDs Controller.
Date: Sun, 23 Aug 2015 22:24:18 +1000
Message-ID: <CAOviyag1ZOgjtNWmnpfMm=fDgkhDn9UGKoJXy6HLWQMGb-tQAg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It turns out that, actually, the can_attach(), cancel_attach() and
attach() code is broken -- we're incrementing a ref on the old_css of
a task in can_attach(). Then we decrement the ref on a *different* css
(because the task has been migrated). This is clearly a bad thing.
Should we make cgroup_migrate() deal with the accounting for us (by
getting it to grab a ref before can_attach() and dropping it after the
attach succeeds or fails?).

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
