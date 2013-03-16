From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 3/4] fs: allow mknod in user namespaces
Date: Fri, 15 Mar 2013 19:23:18 -0500
Message-ID: <20130316002318.GA11997@sergelap>
References: <1363338823-25292-1-git-send-email-glommer@parallels.com>
 <1363338823-25292-4-git-send-email-glommer@parallels.com>
 <87a9q4gzs1.fsf@xmission.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87a9q4gzs1.fsf@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com, Serge Hallyn <serge.hallyn@canonical.com>, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, Aristeu Rozanski <aris@redhat.com>

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Glauber Costa <glommer@parallels.com> writes:
> 
> > Since we have strict control on who access the devices, it should be
> > no problem to allow the device to appear.
> 
> Having cgroups or user namespaces grant privileges makes me uneasy.
> 
> With these patches it looks like I can do something evil like.
> 
> 1. Create a devcgroup.
> 2. Put a process in it.
> 3. Create a usernamespace.
> 4. Run a container in that user namespace.
> 5. As an unprivileged user in that user namespace create another user namespace.
> 6. Call mknod and have it succeed.

not if the devcgroup forbids it.

> Or in short I don't think this handles nested user namespaces at all.
> With or without Serge's suggested change.

Yeah my change doesn't help, other than to stop the unpriv user from
creating the device in an fs he doesn't own...

> At a practical level now is not the right time to be granting more
> permissions to user namespaces.  Lately too many silly bugs have been
> found in what is already there.

I agree.

I realize this doesn't help the centos old-udev situation, but otherwise
bind mounting device files works fine, so I agree we should wait.
Sorry.

-serge
