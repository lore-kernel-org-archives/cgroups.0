From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 9/9] devcg: propagate local changes down the
 hierarchy
Date: Wed, 30 Jan 2013 21:35:13 +0000
Message-ID: <20130130213513.GG8507@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130130171102.390708521-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Quoting aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
Still looking over the code changes, but:

>  static int devcgroup_access_write(struct cgroup *cgrp, struct cftype *cft,
> --- github.orig/Documentation/cgroups/devices.txt	2013-01-29 14:39:17.721843991 -0500
> +++ github/Documentation/cgroups/devices.txt	2013-01-30 10:03:30.536076528 -0500
> @@ -50,3 +50,69 @@ task to a new cgroup.  (Again we'll prob
>  
>  A cgroup may not be granted more permissions than the cgroup's
>  parent has.
> +
> +4. Hierarchy
> +
> +device cgroups maintain hierarchy by making sure never a cgroup has more

making sure a cgroup never has...

> +access permissions than its parent.  Every time an entry is written to
> +a cgroup's devices.deny file, all its children will have that entry removed
> +from the the whitelist and all the locally set whitelist entries re-evaluated.

s/the the/their/

and

...whitelist entries will be re-evaluated.

> +In case one of the locally set whitelist entries would provide more access
> +than the cgroup's parent, it'll be removed from the whitelist.
> +
> +Example:
> +      A
> +     / \
> +        B
> +
> +    group        behavior	exceptions
> +    A            allow		"b 8:* rwm", "c 116:1 rw"
> +    B            deny		"c 1:3 rwm", "c 116:2 rwm", "b 3:* rwm"
> +
> +If a device is denied in group A:
> +	# echo "c 116:* r" > A/devices.deny
> +it'll propagate down and after revalidating B's entries, the whitelist entry
> +"c 116:2 rwm" will be removed:
> +
> +    group        whitelist entries                        denied devices
> +    A            all                                      "b 8:* rwm", "c 116:* rw"
> +    B            "c 1:3 rwm", "b 3:* rwm"                 all the rest
> +
> +In case parent behavior or exceptions change and local settings are not
> +allowed anymore, they'll be deleted.
> +
> +Notice that new whitelist entries will not be propagated:
> +      A
> +     / \
> +        B
> +
> +    group        whitelist entries                        denied devices
> +    A            "c 1:3 rwm", "c 1:5 r"                   all the rest
> +    B            "c 1:3 rwm", "c 1:5 r"                   all the rest
> +
> +when adding "c *:3 rwm":
> +	# echo "c *:3 rwm" >A/devices.allow
> +
> +the result:
> +    group        whitelist entries                        denied devices
> +    A            "c *:3 rwm", "c 1:5 r"                   all the rest
> +    B            "c 1:3 rwm", "c 1:5 r"                   all the rest
> +
> +but not it'll be possible to add new entries to B:

"but now" ?

> +	# echo "c 2:3 rwm" >B/devices.allow
> +	# echo "c 50:3 r" >B/devices.allow
> +or even
> +	# echo "c *:3 rwm" >B/devices.allow
> +
> +4.1 Hierarchy (internal implementation)
> +
> +device cgroups is implemented internally using a behavior (ALLOW, DENY) and a
> +list of exceptions.  The internal state is controlled using the same user
> +interface to preserve compatibility.  A change in behavior (writing "a" to

... to preserve compatibility with the previous whitelist-only
implementation.

> +devices.deny or devices.allow) will be propagated down the hierarchy as well

"as well as" ?

> +new exceptions that will reduce the access to devices (an exception when
> +behavior is ALLOW).  Each cgroup will have its local behavior and exception
> +list to keep track what was set by the user for that cgroup in specific.  For
> +every propagated change, the effective rules will be built starting with
> +parent's rules and the locally set behavior and exceptions in case they still
> +apply, otherwise those will be lost.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
