From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Thu, 7 Sep 2017 17:42:45 +0100
Message-ID: <20170907164245.GA21177@castle.DHCP.thefacebook.com>
References: <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
 <20170905143021.GA28599@castle.dhcp.TheFacebook.com>
 <20170905151251.luh4wogjd3msfqgf@dhcp22.suse.cz>
 <20170905191609.GA19687@castle.dhcp.TheFacebook.com>
 <20170906084242.l4rcx6n3hdzxvil6@dhcp22.suse.cz>
 <20170906174043.GA12579@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.10.1709061355001.70553@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1709070939340.19539@nuc-kabylake>
 <20170907145239.GA19022@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.20.1709071001580.19736@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=kWafieGZSebo3RHwSecVcMJHfQgrUZM5pZ2poGFR5H0=;
 b=ZldfuFsFmDJyozpbV5QThqNluE+vWRXE78SeSjZRdfMMyTLyMsBp6NljExEqCW37duQC
 E/+YPhKZzRd8qVdHBwxnMQI9xUp7tobzISBKi7a1kBVTUpbcjSsb5T67ADBBsbBVq2qD
 vG1d6fUSrM8V+C2+H1S3SodK0C8xYrFId44= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kWafieGZSebo3RHwSecVcMJHfQgrUZM5pZ2poGFR5H0=;
 b=V3w9hnt9hjO0xsdvA1fUYHssrtVifQQQsHUSbzfwrVkT0Uv4DnN97NI123nCjLzADWp+GETr5231Oy7cUqUyTMOrl6kEyw/HbRdkf+KAlUNamfBMmBYkKWpZJHag0u7hvF6BmjQQOFG8sD8gK4Wze9uEg+3BjHB8NzxbpSIQP2U=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1709071001580.19736@nuc-kabylake>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, nzimmer-sJ/iWh9BUns@public.gmane.org, holt-sJ/iWh9BUns@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sivanich-sJ/iWh9BUns@public.gmane.org

On Thu, Sep 07, 2017 at 10:03:24AM -0500, Christopher Lameter wrote:
> On Thu, 7 Sep 2017, Roman Gushchin wrote:
> 
> > > Really? From what I know and worked on way back when: The reason was to be
> > > able to contain the affected application in a cpuset. Multiple apps may
> > > have been running in multiple cpusets on a large NUMA machine and the OOM
> > > condition in one cpuset should not affect the other. It also helped to
> > > isolate the application behavior causing the oom in numerous cases.
> > >
> > > Doesnt this requirement transfer to cgroups in the same way?
> >
> > We have per-node memory stats and plan to use them during the OOM victim
> > selection. Hopefully it can help.
> 
> One of the OOM causes could be that memory was restricted to a certain
> node set. Killing the allocating task is (was?) default behavior in that
> case so that the task that has the restrictions is killed. Not any task
> that may not have the restrictions and woiuld not experience OOM.

As I can see, it's not the default behavior these days. If we have a way
to select a victim between memcgs/tasks which are actually using
the corresponding type of memory, it's much better than to kill
an allocating task.
