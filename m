From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Fri, 22 Nov 2013 15:50:33 +0100
Message-ID: <20131122145033.GE25406@dhcp22.suse.cz>
References: <20131111153943.GA22384@dhcp22.suse.cz>
 <CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg@mail.gmail.com>
 <20131112135844.GA6049@dhcp22.suse.cz>
 <CA+SBX_O4oK1H7Gtb5OFYSn_W3Gz+d-YqF7OmM3mOrRTp6x3pvw@mail.gmail.com>
 <20131118094554.GA32623@dhcp22.suse.cz>
 <CA+SBX_PqdsG5LBQ1uLpPsSUsbjF8TJ+ok4E+Hp_3AdHf+_5e-A@mail.gmail.com>
 <20131118191655.GB12923@dhcp22.suse.cz>
 <CA+SBX_OeGCr5oDbF0n7jSLu-TTY9xpqc=LYp_=18qFYHB-nBdg@mail.gmail.com>
 <20131121164559.GA16703@dhcp22.suse.cz>
 <CA+SBX_PDuU7roist-rQ136Jhx1pr-Nt-r=ULdghJFNHsMWwLrg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+SBX_PDuU7roist-rQ136Jhx1pr-Nt-r=ULdghJFNHsMWwLrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 22-11-13 10:50:11, Markus Blank-Burian wrote:
> > Hmm interesting. Either the output is not complete (because there is no
> > is going offline message for memcg:ffffc9001e5c3000) or this happens
> > before offlining. And there is only one such a place.
> 
> There is indeed no offline for memcg:ffffc9001e5c3000, I checked that
> before sending the relevant part of the trace.
> 
> > mem_cgroup_force_empty which is called when somebody writes into
> > memory.force_empty file. That however doesn't match your previous
> > traces. Maybe yet another issue...
> >
> > Could you apply the patch bellow on top of what you have already?
> 
> I applied the patch and attached the whole trace log, but there is no
> new trace output from mem_cgroup_force_empty present.

Weird! There are no other call sites.

Anyway.
$ grep mem_cgroup_css_offline: trace | sed 's@.*is@@' | sort | uniq -c
    581  going offline now
    580  offline now

So there is entry to offline without finishing. I would assume it would be the one that got stuck but no:
$ grep mem_cgroup_css_offline: trace | sed 's@.*memcg:\([0-9a-f]*\) .*@\1@' | sort | uniq -c | sort -k1 -n | head -n1
      1 ffffc9001e085000

which is not our ffffc9001e2cf000 and it is even not a bit-flip different.
What might be interesting is that
$ grep -B1 ffffc9001e2cf000 trace | head -n2
    kworker/8:13-7244  [008] ....   546.743666: mem_cgroup_css_offline: memcg:ffffc9001e085000 is going offline now
     kworker/2:5-6494  [002] ....   620.277552: mem_cgroup_reparent_charges: memcg:ffffc9001e2cf000 u:4096 k:0 tasks:0

So it is the last offline before and it started quite some time ago
without finishing or looping on mem_cgroup_reparent_charges on usage>0.
Maybe it is stuck on some other blocking operation (you've said you have
the fix for too many workers applied, right?)

It would be interesting to find out whether this is a general pattern
and if yes then check what are the stack traces of the two workers.

Thanks for your patience!
-- 
Michal Hocko
SUSE Labs
