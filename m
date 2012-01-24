From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC 0/4] per-namespace allowed filesystems list
Date: Mon, 23 Jan 2012 16:04:06 -0800
Message-ID: <m1vco2m0eh.fsf@fess.ebiederm.org>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1327337772-1972-1-git-send-email-glommer@parallels.com> (Glauber
	Costa's message of "Mon, 23 Jan 2012 20:56:08 +0400")
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr, pjt@google.com, mzxreary@0pointer.de, xemul@parallels.com, James.Bottomley@HansenPartnership.com, tj@kernel.org, eric.dumazet@gmail.com

Glauber Costa <glommer@parallels.com> writes:

> This patch creates a list of allowed filesystems per-namespace.
> The goal is to prevent users inside a container, even root,
> to mount filesystems that are not allowed by the main box admin.
>
> My main two motivators to pursue this are:
>  1) We want to prevent a certain tailored view of some virtual
>     filesystems, for example, by bind-mounting files with userspace
>     generated data into /proc. The ability of mounting /proc inside
>     the container works against this effort, while disallowing it
>     via capabilities would have the effect of disallowing other
>     mounts as well.
>
> 2) Some filesystems are known not to behave well under a container
>    environment. They require changes to work in a safe-way. We can
>    whitelist only the filesystems we want.
>
> This works as a whitelist. Only filesystems in the list are allowed
> to be mounted. Doing a blacklist would create problems when, say,
> a module is loaded. The whitelist is only checked if it is enabled first.
> So any setup that was already working, will keep working. And whoever
> is not interested in limiting filesystem mount, does not need
> to bother about it.

My first impression is that this looks like a hack to avoid finishing
the user namespace.

This is a terrible way to go about implementing unprivileged mounts.

If there are technical reasons why it is unsafe to mount filesystems
that we need to whitelist/blacklist filesystems in the kernel where we
can check things.

Why in the world would anyone want the ability to not mount a specific
filesystem type?

Using netlink as an interface when you are talking filesystems to
filesystem is pretty horrid.  Netlink is great for networking developers
they get networking, but filesystem people understand filesystems and
you want to use netlink?  

Eric
