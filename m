From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [BUG/RFC] mm/memcg: Possible cgroup migrate/signal deadlock
Date: Tue, 1 Feb 2022 14:11:49 -0800
Message-ID: <YfmwJe9cUQnBV311@carbon.dhcp.thefacebook.com>
References: <20220201205623.1325649-1-jeremy.linton@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/FzfVYFaP95kBfMHn/Q8NqoSQIdZb538e0pa76Luzq4=;
 b=HYzRIU/uVOb/fSL1nv5ZUuWddWhdgGh603bNMROVdhfqts11h401GQD4smb2z2ChlAf8
 rWLiw49sOsQDXWz0l3Uq2iGjnerZyXCQhQScrcUcvWdU7yZvVJfjwxo/+O+sGTPxJWV0
 mhYsCNuYMiPtIXbzRidt384FtjI8x7X9nS8= 
Content-Disposition: inline
In-Reply-To: <20220201205623.1325649-1-jeremy.linton-5wv7dgnIgG8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Feb 01, 2022 at 02:56:23PM -0600, Jeremy Linton wrote:
> With CONFIG_MEMCG_KMEM and CONFIG_PROVE_LOCKING enabled (fedora
> rawhide kernel), running a simple podman test tosses a circular
> locking dependency warning. The podman container in question simpy
> contains the echo command and the libc/ld-linux needed to run it. The
> warning can be duplicated with just a single `podman build --network
> host --layers=false -t localhost/echo .` command, although the exact
> sequence that triggers the warning needs the task state to be changing
> the frozen state as well. So, its easier to duplicate with a slightly
> longer test case.
> 
> I've attempted to trigger the actual deadlock with some standalone
> code and been unsuccessful, but looking at the code it appears to be a
> legitimate deadlock if a signal is being sent to the process from
> another thread while the task is migrating between cgroups.
> 
> Attached is a fix which I'm confident fixes the problem, but I'm not
> really that confident in the fix since I don't fully understand all
> the possible states in the cgroup code. The fix avoids the deadlock by
> shifting the objcg->list manipulation to another spinlock and then
> using list_del_rcu in obj_cgroup_release.
> 
> There is a bit more information in the actual BZ
> https://bugzilla.redhat.com/show_bug.cgi?id=2033016 including a shell
> script with the podman test/etc.

Hi Jeremy!

Thank you for the report and the patch!

We've discussed this issue some time ago and I posted a very similar patch:
https://marc.info/?l=linux-cgroups&m=164221633621286&w=2 .

Also I did resend the latest version few hours ago, but somehow the
mail didn't make it to the mailing lists. Anyway, I've added you
explicitly to cc@ and just resent.

Thanks!
