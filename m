From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Mon, 27 Jun 2016 23:57:02 -0500
Message-ID: <87por1syg1.fsf@x220.int.ebiederm.org>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
	<20160623213819.GP3262@mtj.duckdns.org>
	<53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
	<20160624154830.GX3262@mtj.duckdns.org>
	<20160624155916.GA8759@mail.hallyn.com>
	<20160624163527.GZ3262@mtj.duckdns.org>
	<20160624165910.GA9675@mail.hallyn.com>
	<87mvmaa4f6.fsf@x220.int.ebiederm.org>
	<3003f67c-f998-8056-f25d-d4708eda44a0@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <3003f67c-f998-8056-f25d-d4708eda44a0@gmail.com> (Topi
	Miettinen's message of "Sun, 26 Jun 2016 19:03:11 +0000")
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, luto@kernel.org, keescook@chromium.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Topi Miettinen <toiwoton@gmail.com> writes:

> On 06/24/16 17:21, Eric W. Biederman wrote:
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>> 
>>> Quoting Tejun Heo (tj@kernel.org):
>>>> Hello,
>>>>
>>>> On Fri, Jun 24, 2016 at 10:59:16AM -0500, Serge E. Hallyn wrote:
>>>>> Quoting Tejun Heo (tj@kernel.org):
>>>>>> But isn't being recursive orthogonal to using cgroup?  Why not account
>>>>>> usages recursively along the process hierarchy?  Capabilities don't
>>>>>> have much to do with cgroup but everything with process hierarchy.
>>>>>> That's how they're distributed and modified.  If monitoring their
>>>>>> usages is necessary, it makes sense to do it in the same structure.
>>>>>
>>>>> That was my argument against using cgroups to enforce a new bounding
>>>>> set.  For tracking though, the cgroup process tracking seems as applicable
>>>>> to this as it does to systemd tracking of services.  It tracks a task and
>>>>> the children it forks.
>>>>
>>>> Just monitoring is less jarring than implementing security enforcement
>>>> via cgroup, but it is still jarring.  What's wrong with recursive
>>>> process hierarchy monitoring which is in line with the whole facility
>>>> is implemented anyway?
>>>
>>> As I think Topi pointed out, one shortcoming is that if there is a short-lived
>>> child task, using its /proc/self/status is racy.  You might just miss that it
>>> ever even existed, let alone that the "application" needed it.
>>>
>>> Another alternative we've both mentioned is to use systemtap.  That's not
>>> as nice a solution as a cgroup, but then again this isn't really a common
>>> case, so maybe it is precisely what a tracing infrastructure is meant for.
>> 
>> Hmm.
>> 
>> We have capability use wired up into auditing.  So we might be able to
>> get away with just adding an appropriate audit message in
>> commoncap.c:cap_capable that honors the audit flag and logs an audit
>> message.  The hook in selinux already appears to do that.
>> 
>> Certainly audit sounds like the subsystem for this kind of work, as it's
>> whole point in life is logging things, then something in userspace can
>> just run over the audit longs and build a nice summary.
>
> Even simpler would be to avoid the complexity of audit subsystem and
> just printk() when a task starts using a capability first time (not on
> further uses by same task). There are not that many capability bits nor
> privileged processes, meaning not too many log entries. I know as this
> was actually my first approach. But it's also far less user friendly
> than just reading a summarized value which could be directly fed back to
> configuration.

Your loss.

> Logging/auditing approach also doesn't work well for other things I'd
> like to present meaningful values for the user. For example, consider
> RLIMIT_AS, where my goal is also to enable the users to be able to
> configure this limit for a service. Should there be an audit message
> whenever the address space limit grows (i.e. each mmap())? What about
> when it shrinks? For RLIMIT_NOFILE we'd have to report each
> open()/close()/dup()/socket()/etc. and track how many are opened at the
> same time. I think it's better to store the fully cooked (meaningful to
> user) value in kernel and present it only when asked.

That doesn't have anything to do with anything.

My suggestion was very much to do with capabilities which are already
logged with the audit subsystem with selinux.  The idea was to move
those audit calls into commoncap where they arguably belong allow anyone
to use them for anything.

That is a non-controversial code cleanup that happens to cover your
special case.  That is enough to build a tool in userspace that will
tell you which capabilities you need without penalizing the kernel, or
the vast majority of everyone who does not use your feature.

From what I have seen of this conversation there is not and will not be
one interface to rule them all.

Eric
