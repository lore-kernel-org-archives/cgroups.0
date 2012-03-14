From: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Subject: Re: [PATCH] cgroup: deprecate remount option changes and "name="
 mount option
Date: Thu, 15 Mar 2012 00:29:25 +0100
Message-ID: <20120314232925.GA16973@tango.0pointer.de>
References: <20120314215228.GI7349@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120314215228.GI7349-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, 14.03.12 14:52, Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:

Heya,

> * "name=" mount option: This has been broken for years before Li fixed
>   it recently.  It has very marginal usefulness (plain bind mount can
>   mostly replace it) and is quite unusual.  Take the chance and mark
>   for deprecation.

Hmm, this is not clear to me. Are you intending to remove the name=
mount option entirely, or just intend to remove that you can change it
in remounts?

systemd uses name=systemd to get its own private cgroup tree, that has
no controller bound, hence we kinda need this option. Or are you
suggesting there was an other way to get a private cgroup tree that
systemd can use for grouping and labelling things?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
