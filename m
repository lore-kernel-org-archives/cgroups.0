From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] devcg: Store local settings for each device cgroup
Date: Mon, 19 Aug 2013 17:12:07 +0000
Message-ID: <20130819171207.GA2376@mail.hallyn.com>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
 <20130815195941.GA10977@mtj.dyndns.org>
 <20130815204804.GO7878@redhat.com>
 <20130815210937.GB10977@mtj.dyndns.org>
 <20130816152025.GC7878@redhat.com>
 <20130816154757.GG2505@htj.dyndns.org>
 <20130816160204.GE7878@redhat.com>
 <20130816160950.GH2505@htj.dyndns.org>
 <52118892.7050909@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52118892.7050909-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

Quoting Li Zefan (lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org):
> Cc: Serge
> 
> On 2013/8/17 0:09, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Aug 16, 2013 at 12:02:04PM -0400, Aristeu Rozanski wrote:
> >>> Yeah, that's the correct behavior, if I'm not misunderstanding you,
> >>> but to be consistent we also need to allow creating rules which allow
> >>> devices which aren't allowed by ancestors.  It won't be applicable at
> >>> rule creation but may later become effective later on.
> >>
> >> Oh, I see, it's just matter of allowing to set the desired set or rules
> >> locally even if they're not possible at the moment.
> > 
> > Yeah, otherwise, we'd get into situation where setting rules in place
> > isn't allowed but moving it out of hierarchy, setting it and then
> > moving it back would work, which doesn't make much sense.
> > 
> >> So, considering we drop in sane_behavior the allow + exceptions case,
> >> the interface in sane_behavior mode would look like:
> >> - policy: {allow_all,deny}
> >> 	writing either will clear the active aw
> >> - active_whitelist
> >> 	list of in effect rules, read only
> >> - whitelist
> >> 	list of locally set rules, read only
> >> - whitelist_add
> >> 	write only, adds rule to the local list and active lists
> >> - whitelist_remove
> >> 	write only, removes rule from the local and active lists
> >>
> >> What you think?
> > 
> > Yeah, I think that should work although you might also need
> > active_policy and "effective" might be a better choice as prefix.
> 
> As I've started to work on cpuset side, I'm also thinking about
> adding cpuset.effective_cpus and cpuset.effective_mems.
> 
> > Kay, Lennart, what do you guys think?
> > 
> 
> As Serge is the original author of devcg, let's also see how
> Serge feel about the new interfaces?

(Hm, I thought I was subscribed to cgroup list, but I'm not seeing any
of these messages, thanks for the cc)

So long as there is a clear way to tell which interface we have,
(and hopefully it won't be changing again) it seems good.

thanks,
-serge
