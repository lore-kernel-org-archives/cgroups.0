From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 0/4] devcg: Store local settings for each device cgroup
Date: Thu, 15 Aug 2013 11:34:10 -0400
Message-ID: <1376580854-30929-1-git-send-email-aris@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

This patchset makes possible for device cgroups to store locally set rules to
be reapplied whenever possible. This is also desired when moving device cgroups
around.

Consider:

          A
        /
       B

Behavior in both is deny. 'A' has this exception list:
	b 1:* rw
	c *:* rw
One can explicitely set on 'B':
	b 1:5 r
If for some reason 'A' removes 'b 1:* rw', 'B' exception 'b 1:5 r' will be
removed because it's not allowed anymore and would be forever lost.

Now, consider that in the parent more fine grained exceptions were added:
	b 1:1 r
	b 1:2 rw
	b 1:4 rwc
	b 1:5 r

B would still be out of exceptions (we only propagate restrictions, not added
access).

With this patchset, the 'b 1:5 r' exception will be kept and whenever possible
(more specifically when the parent gets access to more devices) it'll be
re-evaluated and applied if allowed. In this specific case, since it's allowed
again, the exception 'b 1:5 r' will be reapplied to B.

This patchset is based on for-3.12 branch on Tejun's tree
(bd8815a6d802fc16a7a106e170593aa05dc17e72) and it's available for review on my
git tree:
	git://github.com/aristeu/linux-2.6.git
	branch: devcg-rename

Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
