From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: hierarchical soft limit reclaim
Date: Fri, 13 Jan 2012 13:45:30 -0800
Message-ID: <CALWz4iyj4SMMyYhbuZ3HUq-jvcZUCGarceYY7vxm4b7X=yvCMg@mail.gmail.com>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
	<1326207772-16762-3-git-send-email-hannes@cmpxchg.org>
	<20120113120406.GC17060@tiehlicka.suse.cz>
	<20120113155001.GB1653@cmpxchg.org>
	<20120113163423.GG17060@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:x-system-of-record:content-type:content-transfer-encoding;
        bh=t4Z7HJpkDoiRrr5yS7q/iJ5wwepsDIBlKmBl1FqTfAU=;
        b=yZoGq89exe8cllfKn1mllg85y/UIubLpilsJ/FbBnBVe/lF/lwp/hSGQ7108F34Mn3
         7sk9PM+Uwnm4oYGNW75eE4B7avEA4sifQWzCGF3SjSKF9Lgmymr4ftjP1Byf4YPJGLOa
         qfnYc3UTziZUY5M6TeibmXBtdZDt2bS7bP9JU=
In-Reply-To: <20120113163423.GG17060-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 13, 2012 at 8:34 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Fri 13-01-12 16:50:01, Johannes Weiner wrote:
>> On Fri, Jan 13, 2012 at 01:04:06PM +0100, Michal Hocko wrote:
>> > On Tue 10-01-12 16:02:52, Johannes Weiner wrote:
> [...]
>> > > +bool mem_cgroup_over_softlimit(struct mem_cgroup *root,
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct mem_cgro=
up *memcg)
>> > > +{
>> > > + if (mem_cgroup_disabled())
>> > > + =A0 =A0 =A0 =A0 return false;
>> > > +
>> > > + if (!root)
>> > > + =A0 =A0 =A0 =A0 root =3D root_mem_cgroup;
>> > > +
>> > > + for (; memcg; memcg =3D parent_mem_cgroup(memcg)) {
>> > > + =A0 =A0 =A0 =A0 /* root_mem_cgroup does not have a soft limit =
*/
>> > > + =A0 =A0 =A0 =A0 if (memcg =3D=3D root_mem_cgroup)
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > > + =A0 =A0 =A0 =A0 if (res_counter_soft_limit_excess(&memcg->res)=
)
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
>> > > + =A0 =A0 =A0 =A0 if (memcg =3D=3D root)
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > > + }
>> > > + return false;
>> > > +}
>> >
>> > Well, this might be little bit tricky. We do not check whether mem=
cg and
>> > root are in a hierarchy (in terms of use_hierarchy) relation.
>> >
>> > If we are under global reclaim then we iterate over all memcgs and=
 so
>> > there is no guarantee that there is a hierarchical relation betwee=
n the
>> > given memcg and its parent. While, on the other hand, if we are do=
ing
>> > memcg reclaim then we have this guarantee.
>> >
>> > Why should we punish a group (subtree) which is perfectly under it=
s soft
>> > limit just because some other subtree contributes to the common pa=
rent's
>> > usage and makes it over its limit?
>> > Should we check memcg->use_hierarchy here?
>>
>> We do, actually. =A0parent_mem_cgroup() checks the res_counter paren=
t,
>> which is only set when ->use_hierarchy is also set.
>
> Of course I am blind.. We do not setup res_counter parent for
> !use_hierarchy case. Sorry for noise...
> Now it makes much better sense. I was wondering how !use_hierarchy co=
uld
> ever work, this should be a signal that I am overlooking something
> terribly.
>
> [...]
>> > > @@ -2121,8 +2121,16 @@ static void shrink_zone(int priority, str=
uct zone *zone,
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .mem_cgroup =3D memcg,
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .zone =3D zone,
>> > > =A0 =A0 =A0 =A0 =A0 };
>> > > + =A0 =A0 =A0 =A0 int epriority =3D priority;
>> > > + =A0 =A0 =A0 =A0 /*
>> > > + =A0 =A0 =A0 =A0 =A0* Put more pressure on hierarchies that exc=
eed their
>> > > + =A0 =A0 =A0 =A0 =A0* soft limit, to push them back harder than=
 their
>> > > + =A0 =A0 =A0 =A0 =A0* well-behaving siblings.
>> > > + =A0 =A0 =A0 =A0 =A0*/
>> > > + =A0 =A0 =A0 =A0 if (mem_cgroup_over_softlimit(root, memcg))
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 epriority =3D 0;
>> >
>> > This sounds too aggressive to me. Shouldn't we just double the pre=
ssure
>> > or something like that?
>>
>> That's the historical value. =A0When I tried priority - 1, it was no=
t
>> aggressive enough.
>
> Probably because we want to reclaim too much. Maybe we should do
> reduce nr_to_reclaim (ugly) or reclaim only overlimit groups until ce=
rtain
> priority level as Ying suggested in her patchset.

I plan to post that change on top of this, and this patch set does the
basic stuff to allow us doing further improvement.

I still like the design to skip over_soft_limit cgroups until certain
priority. One way to set up the soft limit for each cgroup is to base
on its actual working set size, and we prefer to punish A first with
lots of page cache ( cold file pages above soft limit) than reclaiming
anon pages from B ( below soft limit ). Unless we can not get enough
pages reclaimed from A, we will start reclaiming from B.

This might not be the ideal solution, but should be a good start. Thoug=
hts?

--Ying

> --
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9
> Czech Republic
