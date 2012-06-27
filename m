From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: "Regression" with cd3d09527537
Date: Wed, 27 Jun 2012 16:08:23 -0700
Message-ID: <20120627230823.GU15811@google.com>
References: <4FE9AE57.4090007@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xO/ZD6P5iLxAMcHYANJmV+i9eMATv4ILCcGNqAfSH34=;
        b=YyP/VaFFnNDX1g4rGtFug0f35uWzTT47twwO1slO33Vof+kdH6cWMjiLWaHuyLx5m+
         RQAleyjDQWiHIUM99ufLu+pDqX1Z2GZfuqsIGXsfLZcKeg2wa6+0qbzfs04gJ+LUwfEK
         7JtZNEkMlzwtxqZtVdLCB/Liz1kjifHzB40/m52kNjSToVfoWoB2UuwqP+fNUb50fd90
         a1/bl3wyX5lQA9qrELf5HGtvL5gVT33HosoCglSro2Ty4NGZgCK5YDbrMimTUVcWl6Vc
         +dbq7ALRmPQd3v1MqgxasBf+75NuAvdFqDiMeSYgdV1+z3TiCYcqsI5/0Po8ohF0b+HT
         abHQ==
Content-Disposition: inline
In-Reply-To: <4FE9AE57.4090007-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jun 26, 2012 at 04:43:03PM +0400, Glauber Costa wrote:
> Hi,
> 
> I've recently started seeing a lockdep warning at the end of *every*
> "init 0" issued in my machine. Actually, reboots are fine, and
> that's probably why I've never seen it earlier. The log is quite
> extensively, but shows the following dependency chain:
> 
> [   83.982111] -> #4 (cpu_hotplug.lock){+.+.+.}:
> [...]
> [   83.982111] -> #3 (jump_label_mutex){+.+...}:
> [...]
> [   83.982111] -> #2 (sk_lock-AF_INET){+.+.+.}:
> [...]
> [   83.982111] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
> [...]
> [   83.982111] -> #0 (cgroup_mutex){+.+.+.}:
> 
> I've recently fixed bugs with the lock ordering imposed by cpusets
> on cpu_hotplug.lock through jump_label_mutex, and initially thought
> it to be the same kind of issue. But that was not the case.
> 
> I've omitted the full backtrace for readability, but I run this with
> all cgroups disabled but the cpuset, so it can't be sock memcg
> (after my initial reaction of "oh, fuck, not again"). That
> jump_label is there for years, and it comes from the code that
> disables socket timestamps.
> (net_enable_timestamp)

Yeah, there are multiple really large locks at play here - jump label,
threadgroup and cgroup_mutex.  It isn't pretty.  Can you please post
the full lockdep dump?  The above only shows single locking chain.
I'd like to see the other.

Thanks.

-- 
tejun
