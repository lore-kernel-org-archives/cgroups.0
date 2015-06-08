From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Cgroup hierarchical support
Date: Mon, 08 Jun 2015 17:25:30 +0300
Message-ID: <5575A5DA.7040507@kyup.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Tejun,

I'd like to ask which cgroup controllers actually support "hierarchical
behavior". E.g. the children cgroups to be always bound by the limits of
the ancestor group? So far the only one which seems to have this
behavior is the memory cgroup with use_hierarchy set to 1. Also, I'm
interested in such a behavior on the legacy hierarchy version of the
code - e.g. not "sane_behavior" enabled mounts.

I think such a list might be added to the documentation?

Regards,
Nikolay
