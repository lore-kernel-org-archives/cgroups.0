From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] capabilities: audit capability use
Date: Mon, 11 Jul 2016 16:57:03 -0500
Message-ID: <87vb0bbzyo.fsf@x220.int.ebiederm.org>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468235672-3745-1-git-send-email-toiwoton@gmail.com> (Topi
	Miettinen's message of "Mon, 11 Jul 2016 14:14:31 +0300")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-kernel@vger.kernel.org, mladek@suse.com, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, "moderated list:AUDIT SUBSYSTEM" <linux-audit@redhat.com>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Topi Miettinen <toiwoton@gmail.com> writes:

> There are many basic ways to control processes, including capabilities,
> cgroups and resource limits. However, there are far fewer ways to find
> out useful values for the limits, except blind trial and error.
>
> Currently, there is no way to know which capabilities are actually used.
> Even the source code is only implicit, in-depth knowledge of each
> capability must be used when analyzing a program to judge which
> capabilities the program will exercise.
>
> Generate an audit message at system call exit, when capabilities are used.
> This can then be used to configure capability sets for services by a
> software developer, maintainer or system administrator.
>
> Test case demonstrating basic capability monitoring with the new
> message types 1330 and 1331 and how the cgroups are displayed (boot to
> rdshell):

You totally miss the interactions with the user namespace so this won't
give you the information you are aiming for.

Eric
