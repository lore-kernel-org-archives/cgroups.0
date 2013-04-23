From: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Tue, 23 Apr 2013 05:45:05 -0700
Message-ID: <CANN689G47EFiSpH-d=yQSiUxPcHXveBi_aCL=o3yoHSa8K7LbQ@mail.gmail.com>
References: <20130420002620.GA17179@mtj.dyndns.org>
	<20130420031611.GA4695@dhcp22.suse.cz>
	<20130421022321.GE19097@mtj.dyndns.org>
	<CANN689GuN_5QdgPBjr7h6paVmPeCvLHYfLWNLsJMWib9V9G_Fw@mail.gmail.com>
	<20130422042445.GA25089@mtj.dyndns.org>
	<20130422153730.GG18286@dhcp22.suse.cz>
	<20130422154620.GB12543@htj.dyndns.org>
	<20130422155454.GH18286@dhcp22.suse.cz>
	<CANN689Hz5A+iMM3T76-8RCh8YDnoGrYBvtjL_+cXaYRR0OkGRQ@mail.gmail.com>
	<20130423113216.GB8001@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=sKeYJEmt+5tViOryDr9Nvr1jZPXdO4/+5I43W+hVNAQ=;
        b=GuUXVSe6dBgOBsCnjUZfogOGKb5Frygi4QQBahtodQYScZ7bzywNIrRl3zWB8l7czd
         LPeOBZmx06LF3eQp0Czda2h1UDhOSYqhhjx77Z0jTyYNYyAp5JlY3b4uhz8FP93TGiIf
         TYWCVbFslrTj1AAjHg8EcA1xE/K9oZDd9pDXw7bIk0KB9hwzbaTHkDJ4i4Oj6131dvcZ
         pI8M9LpfL5XIwlnF65vipKJ837pTuoaYE79F50Pg0cICxKd4hxugPZv0ad5aQtZs62ko
         V0ck5n7TfyBPWjD3fAEMghc3DR+C5xhXKy7+pKrjHIItnjPwB/WdAB0XKIkBg0o8fi4s
         hH4g==
In-Reply-To: <20130423113216.GB8001-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 23, 2013 at 4:32 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Tue 23-04-13 02:58:19, Michel Lespinasse wrote:
>> On Mon, Apr 22, 2013 at 8:54 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>> > On Mon 22-04-13 08:46:20, Tejun Heo wrote:
>> >> Oh, if so, I'm happy.  Sorry about being brash on the thread; however,
>> >> please talk with google memcg people.  They have very different
>> >> interpretation of what "softlimit" is and are using it according to
>> >> that interpretation.  If it *is* an actual soft limit, there is no
>> >> inherent isolation coming from it and that should be clear to
>> >> everyone.
>> >
>> > We have discussed that for a long time. I will not speak for Greg & Ying
>> > but from my POV we have agreed that the current implementation will work
>> > for them with some (minor) changes in their layout.
>> > As I have said already with a careful configuration (e.i. setting the
>> > soft limit only where it matters - where it protects an important
>> > memory which is usually in the leaf nodes)
>>
>> I don't like your argument that soft limits work if you only set them
>> on leaves.
>
> I didn't say that. Please read it again. "where it protects an important
> memory which is _usaully_ in the leaf nodes". Intermediate nodes can of
> course contain some important memory as well and you can well "protect"
> them by the soft limit you just have to be very careful because what you
> have in the result is quite complicated structure. You have a node that
> has some portion of its own memory mixed with reparented pages. You
> cannot distinguish those two of course so protection is somehow harder
> to achieve. That is the reason why I encourage not using any limit on
> the intermediate node which means reclaim the node with my patchset.
>
>> To me this is just a fancy way of saying that hierarchical soft limits
>> don't work.
>
> It works same as the hard limit it just triggers later.
>
>> Also it is somewhat problematic to assume that important memory can
>> easily be placed in leaves. This is difficult to ensure when
>> subcontainer destruction, for example, moves the memory back into the
>> parent.
>
> Is the memory still important then? The workload which uses the memory
> is done. So this ends up being just a cached data.

Well, even supposing the parent only holds non-important cached data
and the leaves have important data... your proposal implies that soft
limits on the leaves won't protect their data from reclaim, because
the cached data in the parent might cause the parent to go over its
own soft limit. If the leaves stay under their own soft limits, I
would prefer that the parent's cached data gets reclaimed first.

>> > you can actually achieve
>> > _high_ probability for not being reclaimed after the rework which was not
>> > possible before because of the implementation which was ugly and
>> > smelled.
>>
>> So, to be clear, what we (google MM people) want from soft limits is
>> some form of protection against being reclaimed from when your cgroup
>> (or its parent) is below the soft limit.
>>
>> I don't like to call it a guarantee either, because we understand that
>> it comes with some limitations - for example, if all user pages on a
>> given node are yours then allocations from that node might cause some
>> of your pages to be reclaimed, even when you're under your soft limit.
>> But we want some form of (weak) guarantee that can be made to work
>> good enough in practice.
>>
>> Before your change, soft limits didn't actually provide any such form
>> of guarantee, weak or not, since global reclaim would ignore soft
>> limits.
>>
>> With your proposal, soft limits at least do provide the weak guarantee
>> that we want, when not using hierarchies. We see this as a very clear
>> improvement over the previous situation, so we're very happy about
>> your patchset !
>>
>> However, your proposal takes that weak guarantee away as soon as one
>> tries to use cgroup hierarchies with it, because it reclaims from
>> every child cgroup as soon as the parent hits its soft limit. This is
>> disappointing and also, I have not heard of why you want things to
>> work that way ?
>
> Sigh. Because if children didn't follow parent's limit then they could
> easily escape from the reclaim pushing back to an unrelated hierarchies
> in the tree as the parent wouldn't be able to reclaim down to its limit.

To clarify: to you see us having this problem without administrative
delegation of the child cgroup configuration ?

>> Is this an ease of implementation issue or do you consider that
>> requirement as a bad idea ? And if it's the later, what's your
>> counterpoint, is it related to delegation or is it something else that
>> I haven't heard of ?
>
> The implementation can be improved and child groups might be reclaimed
> _only_ if parent cannot satisfy its soft limit this is not a target of
> the current re-implementation though. The limit has to be preserved
> though.

I'm actually OK with doing things that way; it's only talk about
disallowing these further steps that makes me very worried...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
