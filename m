From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] capabilities: audit capability use
Date: Wed, 13 Jul 2016 07:30:18 +0000
Message-ID: <d882bf1d-e00d-3722-5695-12f257a15224@gmail.com>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
 <87vb0bbzyo.fsf@x220.int.ebiederm.org>
 <ab56ac20-1d56-714c-eb54-9a43db496526@gmail.com>
 <878tx79et8.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=kOQ1Dodp1CpPNbSdmiBbEVoFuAhJMT6/QXXZwKGdkZk=;
        b=tBp/72cAKLtGaw3RVVJmX+rS2z6MireQkIsjFmB9Sr1qcw7U7kA/EhuDH6ObrHLXol
         Y06wCdjkcezx8nbvmjKsB3LI3YJMYz4ZzAfePDzln0SHZsNHfAbZ9hi2XrqA7+BMWOFk
         BfNwe4vvDiw7/0tVBFAtbpxtAFakXhlrVaeKyP0fMVNDxJ6srHpLV6f2RXFGhOzbdANi
         cSNyPoSt3Kv3pTfJZMcMpFbrHIhY43mogn+pzCMv5YtO7/5bW0MfbIjNJSN4GjXXBO9+
         6CQRC+ZPfYxdJGnl6PMbIwAKBeQr3zJsvMA7vDvVLk4kjrMwWC9VeT08MQTCaYJfDmjk
         Wkbg==
In-Reply-To: <878tx79et8.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "moderated list:AUDIT SUBSYSTEM" <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 07/12/16 13:16, Eric W. Biederman wrote:
> Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> 
>> On 07/11/16 21:57, Eric W. Biederman wrote:
>>> Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>>
>>>> There are many basic ways to control processes, including capabilities,
>>>> cgroups and resource limits. However, there are far fewer ways to find
>>>> out useful values for the limits, except blind trial and error.
>>>>
>>>> Currently, there is no way to know which capabilities are actually used.
>>>> Even the source code is only implicit, in-depth knowledge of each
>>>> capability must be used when analyzing a program to judge which
>>>> capabilities the program will exercise.
>>>>
>>>> Generate an audit message at system call exit, when capabilities are used.
>>>> This can then be used to configure capability sets for services by a
>>>> software developer, maintainer or system administrator.
>>>>
>>>> Test case demonstrating basic capability monitoring with the new
>>>> message types 1330 and 1331 and how the cgroups are displayed (boot to
>>>> rdshell):
>>>
>>> You totally miss the interactions with the user namespace so this won't
>>> give you the information you are aiming for.
>>
>> Please correct me if this is not right:
>>
>> There are two cases:
>> a) real capability use as seen outside the namespace
>> b) use of capabilities granted by the namespace
>> Both cases could be active independently.
>>
>> For auditing purposes, we're  mostly interested in a) and log noise from
>> b) could be even seen a distraction.
>>
>> For configuration purposes, both cases can be interesting, a) for the
>> configuration of  services and b) in case where the containerized
>> configuration is planned to be deployed outside. I'd still only log
>> a).
>>
>>
>> The same logic should apply with cgroup namespaces.
> 
> Not logging capabilities outside of the initial user namespace is
> certainly the conservative place to start, and what selinux does.
> 
> You should also be logging capability use from cap_capable.  Not

But cap_capable is not called from apparmor aa_capable or selinux
selinux_capable, how about security_capable()?

> ns_capable.  You are missing several kinds of capability use as
> a quick review of kernel/capability.c should have shown you.

Right, sorry about that.

-Topi

> 
> Eric
> 
