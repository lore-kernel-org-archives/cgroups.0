From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Thu, 21 Feb 2019 09:34:22 -0800
Message-ID: <20190221173422.GY50184@devbig004.ftw2.facebook.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190220143748.GA9477@redhat.com>
 <20190220220020.GA16335@castle.DHCP.thefacebook.com>
 <20190221162923.GA26064@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dZd5V90RuKK+ZbKvrS8KZJwldBEBUcHT50D54ZP9GEs=;
        b=hK9JSeTVv0HCK65Qnku4+5Kl4Tc7KVtEQV68EPlOVwGF/ZY1amMKgBdiIrDc/PLk4X
         Wkka0YqLmFOToI1gEeSo2PDxU1yOz7ka8tlrFeB9n9LPfFHH+u7jQLJN17qWnraLO2v1
         SCVYD1h/iC5xcvt7Zy/MKztao0MuT68+1CYYafmm3WJPl+wYIR+wIej1nGDVK8/NokUB
         7FCryMTYRVLITDtzKwN6drLI2TbNfWvevtUYzGjr0AkWGwJHYZfdkicZhpiBXOd5Wrc8
         m3Vz4ofkNF0iyrVOBEGQmoxAVNKE6x91UdPSIItQM1Llp9cCsTqAFeKuPw0rsz+uvosD
         xDtA==
Content-Disposition: inline
In-Reply-To: <20190221162923.GA26064@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>, Roman Gushchin <guroan@gmail.com>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hello, Oleg.

On Thu, Feb 21, 2019 at 05:29:24PM +0100, Oleg Nesterov wrote:
> But to me this is a reasonable trade-off because this way we do not add
> additional complexity to the kernel.

So, I really wanna avoid allowing userspace to cause D state sleeps.
It's not impossible to work around but becomes really nasty.  For
example, imagine a memory pressure based userspace oom handler issuer
kills based on per-cgroup pressure metric (as oomd would do).  It
might not necessarily have the insight that a victim cgroup is frozen
or whether it can move out its members to a different cgroup (in a lot
of cases that will cause a lot of confusion in management software).

The frozen state in cgroup1 is a new task state which is different
from all others and in a nasty way and it has been causing various
confusions and mistakes from its users.  We really should make it
closer to the existing stop behaviors even if that means more
complexity in the implementation.

> Actually, "killable" is not that difficult afaics. "ptraceable" looks more
> problematic to me. Again, user-space can do
> 
> 	1. PTRACE_SEIZE
> 	2. move the tracee to the root cgroup
> 	3. do anything with the tracee
> 	4. move it back

which is fine.  The goal isn't trying to block userspace from doing
things that it explicitly wants to do.  That's fine.  We just want
things like killing and ptracing to behave similarly to other stopped
states (ie. avoid introducing completely new behaviors).

> But there is another case. If admin wants to freeze a cgroup then it is not
> clear why a user which can send SIGKILL to a frozen process should wake it up.
> 
> ------------------------------------------------------------------------------
> Again, it is not that I hate the idea of killable/ptraceable freezer. Just I
> personally think it's not worth the trouble. Perhaps I am wrong, but so far
> I do not see a good implementation...
> 
> And, apart from reading/writing the registers, what can ptrace do with a frozen
> tracee? This doesn't look like a "must have" feature to me.
> 
> At least, may I ask you again to make (if possible) a separate patch which adds
> the ability to kill/ptrace?

ptrace support is a lot less important than kill for sure but if at
all possible I think it'd be better to have it because that makes the
frozen state closer to other stopped states and thus less surprising.

To summarize, the ideal result is the frozen state to be "stuck in
jobctl stop loop" but except for looping in it no different from
regular jobctl stop.  Plus, register state examination is already
useful for frozen cgroups for debbugging purposes in itself.

Thanks.

-- 
tejun
