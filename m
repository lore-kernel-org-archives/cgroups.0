From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Fri, 14 Feb 2020 08:15:37 +0100
Message-ID: <20200214071537.GL31689@dhcp22.suse.cz>
References: <20200130170020.GZ24244@dhcp22.suse.cz>
 <20200203215201.GD6380@cmpxchg.org>
 <20200211164753.GQ10636@dhcp22.suse.cz>
 <20200212170826.GC180867@cmpxchg.org>
 <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213135348.GF88887@mtj.thefacebook.com>
 <20200213154731.GE31689@dhcp22.suse.cz>
 <20200213155249.GI88887@mtj.thefacebook.com>
 <20200213163636.GH31689@dhcp22.suse.cz>
 <20200213165711.GJ88887@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200213165711.GJ88887-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 13-02-20 11:57:11, Tejun Heo wrote:
> Hello,
> 
> On Thu, Feb 13, 2020 at 05:36:36PM +0100, Michal Hocko wrote:
> > AFAIK systemd already offers knobs to configure resource controls [1].
> 
> Yes, it can set up the control knobs as directed but it doesn't ship
> with any material resource configurations or has conventions set up
> around it.

Right. But services might use those knobs, right? And that means that if
somebody wants a memory protection then the service file is going to use 
MemoryLow=$FOO and that is likely not going to work properly without an
an additional hassles, e.g. propagate upwards, which systemd doesn't do
unless I am mistaken.

> > Besides that we are talking about memcg features which are available only
> > unified hieararchy and that is what systemd is using already.
> 
> I'm not quite sure what the above sentence is trying to say.

I meant to say that once the unified hierarchy is used by systemd you
cannot configure it differently to suit your needs without interfering
with systemd.
 
> > > You gotta
> > > change the layout to configure resource control no matter what and
> > > it's pretty easy to do. systemd folks are planning to integrate higher
> > > level resource control features, so my expectation is that the default
> > > layout is gonna change as it develops.
> > 
> > Do you have any pointers to those discussions? I am not really following
> > systemd development.
> 
> There's a plan to integrate streamlined implementation of oomd into
> systemd. There was a thread somewhere but the only thing I can find
> now is a phoronix link.
> 
>   https://www.phoronix.com/scan.php?page=news_item&px=Systemd-Facebook-OOMD

I am not sure I see how that is going to change much wrt. resource
distribution TBH. Is the existing cgroup hierarchy going to change for
the OOMD to be deployed?

[...]

> > Anyway, I am skeptical that systemd can do anything much more clever
> > than placing cgroups with a resource control under the root cgroup. At
> > least not without some tagging which workloads are somehow related.
> 
> Yeah, exactly, all it needs to do is placing scopes / services
> according to resource hierarchy and configure overall policy at higher
> level slices, which is exactly what the memory.low semantics change
> will allow.

Let me ask more specifically. Is there any plan or existing API to allow
to configure which services are related resource wise?

> > That being said, I do not really blame systemd here. We are not making
> > their life particularly easy TBH.
> 
> Do you mind elaborating a bit?

I believe I have already expressed the configurability concern elsewhere
in the email thread. It boils down to necessity to propagate
protection all the way up the hierarchy properly if you really need to
protect leaf cgroups that are organized without a resource control in
mind. Which is what systemd does.
-- 
Michal Hocko
SUSE Labs
