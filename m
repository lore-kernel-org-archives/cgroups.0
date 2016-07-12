From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] capabilities: audit capability use
Date: Tue, 12 Jul 2016 08:16:51 -0500
Message-ID: <878tx79et8.fsf@x220.int.ebiederm.org>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
	<87vb0bbzyo.fsf@x220.int.ebiederm.org>
	<ab56ac20-1d56-714c-eb54-9a43db496526@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ab56ac20-1d56-714c-eb54-9a43db496526@gmail.com> (Topi
	Miettinen's message of "Tue, 12 Jul 2016 08:54:41 +0000")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-kernel@vger.kernel.org, pmladek@suse.com, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "moderated list:AUDIT SUBSYSTEM" <linux-audit@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Topi Miettinen <toiwoton@gmail.com> writes:

> On 07/11/16 21:57, Eric W. Biederman wrote:
>> Topi Miettinen <toiwoton@gmail.com> writes:
>> 
>>> There are many basic ways to control processes, including capabilities,
>>> cgroups and resource limits. However, there are far fewer ways to find
>>> out useful values for the limits, except blind trial and error.
>>>
>>> Currently, there is no way to know which capabilities are actually used.
>>> Even the source code is only implicit, in-depth knowledge of each
>>> capability must be used when analyzing a program to judge which
>>> capabilities the program will exercise.
>>>
>>> Generate an audit message at system call exit, when capabilities are used.
>>> This can then be used to configure capability sets for services by a
>>> software developer, maintainer or system administrator.
>>>
>>> Test case demonstrating basic capability monitoring with the new
>>> message types 1330 and 1331 and how the cgroups are displayed (boot to
>>> rdshell):
>> 
>> You totally miss the interactions with the user namespace so this won't
>> give you the information you are aiming for.
>
> Please correct me if this is not right:
>
> There are two cases:
> a) real capability use as seen outside the namespace
> b) use of capabilities granted by the namespace
> Both cases could be active independently.
>
> For auditing purposes, we're  mostly interested in a) and log noise from
> b) could be even seen a distraction.
>
> For configuration purposes, both cases can be interesting, a) for the
> configuration of  services and b) in case where the containerized
> configuration is planned to be deployed outside. I'd still only log
> a).
>
>
> The same logic should apply with cgroup namespaces.

Not logging capabilities outside of the initial user namespace is
certainly the conservative place to start, and what selinux does.

You should also be logging capability use from cap_capable.  Not
ns_capable.  You are missing several kinds of capability use as
a quick review of kernel/capability.c should have shown you.

Eric
