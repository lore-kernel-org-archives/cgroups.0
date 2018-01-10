From: Roman Gushchin <guro@fb.com>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Wed, 10 Jan 2018 04:44:14 -0800
Message-ID: <20180110124407.GA26913@castle.DHCP.thefacebook.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
 <CAKgNAkhk-527Rh6tGYJO-U3UXgwBC1+t5nB+5JEq62nTO2p15A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=9krMLsYuZrs+LgfHv/QmBfy1nFaAnMYofh9m+YT+Jj0=;
 b=J2TEPhDoGby4BZ6kZAJ7+FmJe8LRpCejKWBeHx3wIjmQzZbhhSWYBHgHGIR8Gf2uyje9
 KH+XZ1rjQp1hxokrnryZJwQ7t9SH/wASZnIUS4IgwiWUzJdp8I32zYv7uCVn6HlvtSRb
 XA/Ts7CUZQIknwq4W+OCnqJ/LNjmxKZr8IU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9krMLsYuZrs+LgfHv/QmBfy1nFaAnMYofh9m+YT+Jj0=;
 b=W698VLdZYcVA2h+ij3OM3ZQP4HY8pStHhQzMAS+Mt5RYYuFKgW/EgMXIngLodkqxI2gWX/7R28Gq06hWcnpkt73OBmMP8XB0uw7uHl/wJZ4U5oLdQgCE90j2UP26oF8zn85rbKbf1N0Cf/ciMa45zDbpVIX6Cxt84JkUSryz7mk=
Content-Disposition: inline
In-Reply-To: <CAKgNAkhk-527Rh6tGYJO-U3UXgwBC1+t5nB+5JEq62nTO2p15A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

Hello Michael,

On Wed, Jan 10, 2018 at 05:23:32AM +0100, Michael Kerrisk (man-pages) wrote:
> Hello Roman,
> 
> On 8 January 2018 at 22:11, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
> > Hello Roman,
> >
> > I wrote cgroups(7) text below to document the files added by you in
> > Linux 4.15. Could you let me know if the following text is okay please:
> >
> >    /sys/kernel/cgroup files
> >        /sys/kernel/cgroup/delegate (since Linux 4.15)
> >               This file exports a list of the cgroups v2 files  (one  per
> >               line) that are delegatable (i.e., whose ownership should be
> >               changed to the user ID of the delegatee).  In  the  future,
> >               the  set  of delegatable files may change or grow, and this
> >               file provides a way for the  kernel  to  inform  user-space
> >               applications of which files must be delegated.  As at Linux
> >               4.15, one sees the following when inspecting this file:
> >
> >                   $ cat /sys/kernel/cgroup/delegate
> >                   cgroup.procs
> >                   cgroup.subtree_control
> 
> I have a question about /sys/kernel/cgroup/delegate: why does this
> file not list cgroup.threads, since that is also a file that
> (potentially) should be delegated?

cc Tejun

cgroup.threads is not listed because it's not delegatable (doesn't have
CFTYPE_NS_DELEGATABLE flag set). I don't know if it was intended or just
an accident (I believe the latter).

Thanks!

PS In the latter case the following patch should fix it:

From fdf19edb6e9594e48e89d4510767b9eb6ca2d9dd Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Wed, 10 Jan 2018 04:35:12 -0800
Subject: [PATCH] cgroup: make cgroup.threads delegatable

Make cgroup.threads file delegatable.
The behavior of cgroup.threads should follow the behavior of cgroup.procs.

Signed-off-by: Roman Gushchin <guro@fb.com>
Discovered-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0b1ffe147f24..b74d9ee1425c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4449,6 +4449,7 @@ static struct cftype cgroup_base_files[] = {
 	},
 	{
 		.name = "cgroup.threads",
+		.flags = CFTYPE_NS_DELEGATABLE,
 		.release = cgroup_procs_release,
 		.seq_start = cgroup_threads_start,
 		.seq_next = cgroup_procs_next,
-- 
2.14.3
