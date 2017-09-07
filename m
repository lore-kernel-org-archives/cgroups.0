From: David Rientjes <rientjes@google.com>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Thu, 7 Sep 2017 14:55:56 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709071454220.141461@chino.kir.corp.google.com>
References: <20170904142108.7165-1-guro@fb.com> <20170904142108.7165-6-guro@fb.com> <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz> <20170905143021.GA28599@castle.dhcp.TheFacebook.com> <20170905151251.luh4wogjd3msfqgf@dhcp22.suse.cz>
 <20170905191609.GA19687@castle.dhcp.TheFacebook.com> <20170906084242.l4rcx6n3hdzxvil6@dhcp22.suse.cz> <20170906174043.GA12579@castle.DHCP.thefacebook.com> <alpine.DEB.2.10.1709061355001.70553@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1709070939340.19539@nuc-kabylake>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=YmzZfYc2x4uGpQB7wNs1theszJ2Glo3n4/pd7tuCvOs=;
        b=JVYCUjNXMxqIwLxeZTtxlSS3qAYkUXP2ALtP+9EuMznZWyWmxxnsQgN4/VOWf872XO
         TZtR1jCT5lyka+SInm4iTpkaKCuF2FwZ3ikIlBiWAjsDYNA3AI2W5huNkSA1b7GQObpP
         sDF/QDHgESFUvYuGOOf7q1i2lg/KnL0YyUOoZtm25HQvwflXBv21BIZP1UQ9NgRExVWF
         1hZcgDATWI8/BK/lvMDCad58xAuSvvXhJ6RW8JAU9NtDJI8OKhRZ8ngosNqXTU1AOR9Y
         z+Js25FHG9Qk8KrbfAA6JcIr8NV7mwB1Dp+50QJfu4J76m7xtHXMurPHy2KNcCQMFc5M
         U9hw==
In-Reply-To: <alpine.DEB.2.20.1709070939340.19539@nuc-kabylake>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl@linux.com>
Cc: Roman Gushchin <guro@fb.com>, nzimmer@sgi.com, holt@sgi.com, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, sivanich@sgi.com

On Thu, 7 Sep 2017, Christopher Lameter wrote:

> > SGI required it when it was introduced simply to avoid the very expensive
> > tasklist scan.  Adding Christoph Lameter to the cc since he was involved
> > back then.
> 
> Really? From what I know and worked on way back when: The reason was to be
> able to contain the affected application in a cpuset. Multiple apps may
> have been running in multiple cpusets on a large NUMA machine and the OOM
> condition in one cpuset should not affect the other. It also helped to
> isolate the application behavior causing the oom in numerous cases.
> 
> Doesnt this requirement transfer to cgroups in the same way?
> 
> Left SGI in 2008 so adding Dimitri who may know about the current
> situation. Robin Holt also left SGI as far as I know.
> 

It may have been Paul Jackson, but I remember the oom_kill_allocating_task 
knob being required due to very slow oom killer due to the very lengthy 
iteration of the tasklist.  It would be helpful if someone from SGI could 
confirm whether or not they actively use this sysctl.
