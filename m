From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC v3 18/22] cgroup,landlock: Add CGRP_NO_NEW_PRIVS to handle
 unprivileged hooks
Date: Wed, 14 Sep 2016 11:27:48 -0700
Message-ID: <CALCETrXBDVe9AzHnD1B5r=GGVNsU5gsC92iqD0S94mQBZOzOBQ@mail.gmail.com>
References: <20160914072415.26021-1-mic@digikod.net> <20160914072415.26021-19-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o4UCPPG+vwg9uCmkBAn7kqwwHgm7ciZmCaVqt2/cuvo=;
        b=V1aI+IM9MvJTMMK+UjYUlgdYDQC2AEMGPmXJjrNn93HFtKul7nTlgBrZQYwsEh1mNO
         K4wYNAFNAbp6mUoYsEMBBvxYPQGKgrSZH36HAFvupqPgyxmj4sIpOZBVsq+O5Y84MSF2
         PIY1MRiqDD3rqMiIIn6wJN7W9bFo2UflsE0sETdlfL7s1dcJzQYR2R04zMT9sPN56whh
         JWR54lfmMOJwI0y3Y7evWFLsvt9WnhNeJqKoOhdH9l1le7UzwHNgIVA/ALNZlU7Va3kj
         qONLGsyfU4HN+zU2myOlAlyr3ml0G8BwAyiCneNmC1IspZmcf0jGdaF+s6MSjGuyjFxd
         6T+w==
In-Reply-To: <20160914072415.26021-19-mic@digikod.net>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux API <linu>

On Wed, Sep 14, 2016 at 12:24 AM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net=
> wrote:
> Add a new flag CGRP_NO_NEW_PRIVS for each cgroup. This flag is initially
> set for all cgroup except the root. The flag is clear when a new process
> without the no_new_privs flags is attached to the cgroup.
>
> If a cgroup is landlocked, then any new attempt, from an unprivileged
> process, to attach a process without no_new_privs to this cgroup will
> be denied.

Until and unless everyone can agree on a way to properly namespace,
delegate, etc cgroups, I think that trying to add unprivileged
semantics to cgroups is nuts.  Given the big thread about cgroup v2,
no-internal-tasks, etc, I just don't see how this approach can be
viable.

Can we try to make landlock work completely independently of cgroups
so that it doesn't get stuck and so that programs can use it without
worrying about cgroup v1 vs v2, interactions with cgroup managers,
cgroup managers that (supposedly?) will start migrating processes
around piecemeal and almost certainly blowing up landlock in the
process, etc?

I have no problem with looking at prototypes for how landlock +
cgroups would work, but I can't imagine the result being mergeable.
