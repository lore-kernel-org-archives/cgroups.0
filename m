From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Wed, 14 Nov 2018 18:36:11 +0100
Message-ID: <20181114173610.GF13885@redhat.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com>
 <20181113154825.GC30990@redhat.com>
 <20181113215919.GC15590@tower.DHCP.thefacebook.com>
 <20181114165631.GE13885@redhat.com>
 <20181114170558.GA24889@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181114170558.GA24889@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On 11/14, Roman Gushchin wrote:
>
> > No, this is very wrong. Just suppose the caller is killed right before
> > clear_thread_flag(TIF_SIGPENDING).
>
> So, I had TASK_KILLABLE before, but had some issues with ptrace/gdb.
> I'll revisit this option.

Yes, ptrace_signal_wake_up() won't wake a TASK_KILLABLE tracee up...

BTW. Could you explain in the changelog how should a frozen task interact
with ptrace? 0/6 says "ptrace works" but that is all. It is not clear to me
what do we actually want wrt ptrace...

Oleg.

