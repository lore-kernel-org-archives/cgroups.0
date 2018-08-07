From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v3
Date: Tue, 7 Aug 2018 13:51:32 -0400
Message-ID: <20180807175132.GA27979@cmpxchg.org>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <5576a988-fca9-15a5-5fa8-16f704ea20fb@sony.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UpJ6FyGDkvX9DB3o64kenGl56IYvhdWQ2odl8ODKXXc=;
        b=xUf/RW9PAuGdg/aPmdXZd061y1b6q1zGr+kLQpDEaAEzJooB6827zXKVhjRHGN5n7e
         HIjUtKUyaJOXzgZuXxznZcNUilT1xBZhA5aehh8lQruhFsIUm8GVYWMTmkLoG2UTPfFs
         vXqQAH1vMLhucdZdSZ4omgtizpiFeVV32ipqPL4lUmkAsZCnWsRzwoCDnvuNz8bWCYbl
         uCU6edKUuslSG6p9dY6Byjne8s33D9qm4zN4uqiFICsUB7jHC5eo+Wh79SWpC+5PHWUD
         RNbqEMybZilTZhuktqRbxx2meHfWOn6J2tgPU9iNxja8HbkPqNkIuvqHrNMH4w4IZupg
         IS3Q==
Content-Disposition: inline
In-Reply-To: <5576a988-fca9-15a5-5fa8-16f704ea20fb@sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peter enderborg <peter.enderborg@sony.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Aug 07, 2018 at 01:50:09PM +0200, peter enderborg wrote:
> On 08/01/2018 05:19 PM, Johannes Weiner wrote:
> >
> > A kernel with CONFIG_PSI=y will create a /proc/pressure directory with
> > 3 files: cpu, memory, and io. If using cgroup2, cgroups will also have
> > cpu.pressure, memory.pressure and io.pressure files, which simply
> > aggregate task stalls at the cgroup level instead of system-wide.
> >
> Usually there are objections to add more stuff to /proc. Is this an exception?

It seems like a good fit given that all other system stats of this
type and format are there: loadavg, schedstat, diskstats, uptime etc.

sysfs, and its concept of kernel objects and their attributes, doesn't
really match the type of info exported here. And its breakdown of
complex information into many directories and files can be kind of
tedious to be honest; some information is just more human readable in
a simple table, and still trivial to parse mechanically.

It would also be nice to keep the same file format for both the system
level and cgroups, to avoid having two separate presentations (and two
parsers) for the same type of information at different scopes, but the
sysfs design goals clash with the cgroupfs ones. If we exported the
system stats at the root cgroup level, we'd still need an interface
for !CGROUP systems, and having two ways of reading actually identical
data would again be fairly ugly.
