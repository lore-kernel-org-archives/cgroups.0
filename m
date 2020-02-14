From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Fri, 14 Feb 2020 16:13:18 +0100
Message-ID: <20200214151318.GC31689@dhcp22.suse.cz>
References: <20200211164753.GQ10636@dhcp22.suse.cz>
 <20200212170826.GC180867@cmpxchg.org>
 <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213135348.GF88887@mtj.thefacebook.com>
 <20200213154731.GE31689@dhcp22.suse.cz>
 <20200213155249.GI88887@mtj.thefacebook.com>
 <20200213163636.GH31689@dhcp22.suse.cz>
 <20200213165711.GJ88887@mtj.thefacebook.com>
 <20200214071537.GL31689@dhcp22.suse.cz>
 <20200214135728.GK88887@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200214135728.GK88887-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri 14-02-20 08:57:28, Tejun Heo wrote:
[...]

Sorry to skip over a large part of your response. The discussion in this
thread got quite fragmented already and I would really like to conclude
to something.

> > I believe I have already expressed the configurability concern elsewhere
> > in the email thread. It boils down to necessity to propagate
> > protection all the way up the hierarchy properly if you really need to
> > protect leaf cgroups that are organized without a resource control in
> > mind. Which is what systemd does.
> 
> But that doesn't work for other controllers at all. I'm having a
> difficult time imagining how making this one control mechanism work
> that way makes sense. Memory protection has to be configured together
> with IO protection to be actually effective.

Please be more specific. If the protected workload is mostly in-memory,
I do not really see how IO controller is relevant. See the example of
the DB setup I've mentioned elsewhere.

> As for cgroup hierarchy being unrelated to how controllers behave, it
> frankly reminds me of cgroup1 memcg flat hierarchy thing I'm not sure
> how that would actually work in terms of resource isolation. Also, I'm
> not sure how systemd forces such configurations and I'd think systemd
> folks would be happy to fix them if there are such problems. Is the
> point you're trying to make "because of systemd, we have to contort
> how memory controller behaves"?

No, I am just saying and as explained in reply to Johannes, there are
practical cases where the cgroup hierarchy reflects organizational
structure as well.
-- 
Michal Hocko
SUSE Labs
