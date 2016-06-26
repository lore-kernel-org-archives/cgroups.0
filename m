From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Sun, 26 Jun 2016 19:03:11 +0000
Message-ID: <3003f67c-f998-8056-f25d-d4708eda44a0@gmail.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org>
 <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
 <20160624154830.GX3262@mtj.duckdns.org>
 <20160624155916.GA8759@mail.hallyn.com>
 <20160624163527.GZ3262@mtj.duckdns.org>
 <20160624165910.GA9675@mail.hallyn.com>
 <87mvmaa4f6.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=XfTedJCy7SjozYm4RV1kWHh//f8v3E8HJby7JbFWnr8=;
        b=JNVYKxiaGVeBqop28jZPF7VqeOkXXPhZ4wcX64Qwj0F5V48OVvz+mwSqPyp9sVKuXT
         5QMOA1qJKChqaXoL4rHwP1vtdEHGn7J1dGDYGrKJ0Plh4U/cS7Acpsm0TERbrTp1EGf6
         cilCKk6e9XSXLo8o72wDt1WggbYi9DAttl31WHXhLI0teg/SyYvWFFzYpaniU9i5X3NT
         2deb/E1pmIUnvQrFEoomCT0ErDd0bi3W/yD2z0AKZgD4H+hl8udAGLtcgIYCHJJjKcPQ
         zfvMcKAMDwxWoKu9zPMkv4+umTSTXYkH5xrv85GQ6phyqObS/RutWvpKrpIworhq9Mzs
         P60w==
In-Reply-To: <87mvmaa4f6.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 06/24/16 17:21, Eric W. Biederman wrote:
> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> 
>> Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
>>> Hello,
>>>
>>> On Fri, Jun 24, 2016 at 10:59:16AM -0500, Serge E. Hallyn wrote:
>>>> Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
>>>>> But isn't being recursive orthogonal to using cgroup?  Why not account
>>>>> usages recursively along the process hierarchy?  Capabilities don't
>>>>> have much to do with cgroup but everything with process hierarchy.
>>>>> That's how they're distributed and modified.  If monitoring their
>>>>> usages is necessary, it makes sense to do it in the same structure.
>>>>
>>>> That was my argument against using cgroups to enforce a new bounding
>>>> set.  For tracking though, the cgroup process tracking seems as applicable
>>>> to this as it does to systemd tracking of services.  It tracks a task and
>>>> the children it forks.
>>>
>>> Just monitoring is less jarring than implementing security enforcement
>>> via cgroup, but it is still jarring.  What's wrong with recursive
>>> process hierarchy monitoring which is in line with the whole facility
>>> is implemented anyway?
>>
>> As I think Topi pointed out, one shortcoming is that if there is a short-lived
>> child task, using its /proc/self/status is racy.  You might just miss that it
>> ever even existed, let alone that the "application" needed it.
>>
>> Another alternative we've both mentioned is to use systemtap.  That's not
>> as nice a solution as a cgroup, but then again this isn't really a common
>> case, so maybe it is precisely what a tracing infrastructure is meant for.
> 
> Hmm.
> 
> We have capability use wired up into auditing.  So we might be able to
> get away with just adding an appropriate audit message in
> commoncap.c:cap_capable that honors the audit flag and logs an audit
> message.  The hook in selinux already appears to do that.
> 
> Certainly audit sounds like the subsystem for this kind of work, as it's
> whole point in life is logging things, then something in userspace can
> just run over the audit longs and build a nice summary.

Even simpler would be to avoid the complexity of audit subsystem and
just printk() when a task starts using a capability first time (not on
further uses by same task). There are not that many capability bits nor
privileged processes, meaning not too many log entries. I know as this
was actually my first approach. But it's also far less user friendly
than just reading a summarized value which could be directly fed back to
configuration.

Logging/auditing approach also doesn't work well for other things I'd
like to present meaningful values for the user. For example, consider
RLIMIT_AS, where my goal is also to enable the users to be able to
configure this limit for a service. Should there be an audit message
whenever the address space limit grows (i.e. each mmap())? What about
when it shrinks? For RLIMIT_NOFILE we'd have to report each
open()/close()/dup()/socket()/etc. and track how many are opened at the
same time. I think it's better to store the fully cooked (meaningful to
user) value in kernel and present it only when asked.

-Topi

> 
> Eric
> 
