From: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Tue, 23 Apr 2013 05:51:36 -0700
Message-ID: <CANN689FaGBi+LmdoSGBf3D9HmLD8Emma1_M3T1dARSD6=75B0w@mail.gmail.com>
References: <20130420002620.GA17179@mtj.dyndns.org>
	<20130420031611.GA4695@dhcp22.suse.cz>
	<20130421022321.GE19097@mtj.dyndns.org>
	<CANN689GuN_5QdgPBjr7h6paVmPeCvLHYfLWNLsJMWib9V9G_Fw@mail.gmail.com>
	<20130422042445.GA25089@mtj.dyndns.org>
	<20130422153730.GG18286@dhcp22.suse.cz>
	<20130422154620.GB12543@htj.dyndns.org>
	<20130422155454.GH18286@dhcp22.suse.cz>
	<CANN689Hz5A+iMM3T76-8RCh8YDnoGrYBvtjL_+cXaYRR0OkGRQ@mail.gmail.com>
	<51765FB2.3070506@parallels.com>
	<20130423114020.GC8001@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=tXvqo/xDKjZNMX5lZc9ludgL2s6WatgmAEqYu4nzlRM=;
        b=iOqw5ui+11Foq0iY4ZsMxePa3o5RdJMwgYgwyIQAgDszvugeK/sndXFaVzVxxUI2SM
         4PuY7j/BcQXFDDx8lPDLD4xrTodOdoeSgwHxmTeY18MbQPcGJDQ6atzuRwZ5Ra1Yn9u3
         Xx+Dnr4cU/9Pe0A4rojSeI0T9pmqJ9MpYgx/eqFxRhieSn3upOooL8J3al0XZYwwmGNo
         2yQLoKcnWz0yzJNqNcbSxXO/QApwOGXpC26myKWnusSbiSamKXmL4kwhL8USF3lnS61I
         o/qMYSb19gjjDHBO2LbiyTosj7ErS4shaQuCtCBS5GYWWvuYpj0xuZB9w9An097iU8n9
         IOOQ==
In-Reply-To: <20130423114020.GC8001-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 23, 2013 at 4:40 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Tue 23-04-13 14:17:22, Glauber Costa wrote:
>> On 04/23/2013 01:58 PM, Michel Lespinasse wrote:
>> > On Mon, Apr 22, 2013 at 8:54 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>> >> On Mon 22-04-13 08:46:20, Tejun Heo wrote:
>> >>> Oh, if so, I'm happy.  Sorry about being brash on the thread; however,
>> >>> please talk with google memcg people.  They have very different
>> >>> interpretation of what "softlimit" is and are using it according to
>> >>> that interpretation.  If it *is* an actual soft limit, there is no
>> >>> inherent isolation coming from it and that should be clear to
>> >>> everyone.
>> >>
>> >> We have discussed that for a long time. I will not speak for Greg & Ying
>> >> but from my POV we have agreed that the current implementation will work
>> >> for them with some (minor) changes in their layout.
>> >> As I have said already with a careful configuration (e.i. setting the
>> >> soft limit only where it matters - where it protects an important
>> >> memory which is usually in the leaf nodes)
>> >
>> > I don't like your argument that soft limits work if you only set them
>> > on leaves. To me this is just a fancy way of saying that hierarchical
>> > soft limits don't work.
>> >
>> > Also it is somewhat problematic to assume that important memory can
>> > easily be placed in leaves. This is difficult to ensure when
>> > subcontainer destruction, for example, moves the memory back into the
>> > parent.
>> >
>>
>> Michal,
>>
>> For the most part, I am siding with you in this discussion.
>> But with this only-in-leaves thing, I am forced to flip (at least for this).
>>
>> You are right when you say that in a configuration with A being parent
>> of B and C, A being over its hard limit will affect reclaim in B and C,
>> and soft limits should work the same.
>>
>> However, "will affect reclaim" is a big vague. More specifically, if the
>> sum of B and C's hard limit is smaller or equal A's hard limit, the only
>> way of either B or C to trigger A's hard limit is for them, themselves,
>> to go over their hard limit.
>
> Which is an expectation that you cannot guarantee. You can have B+C>A.
>
>> *This* is the case you you are breaking when you try to establish a
>> comparison between soft and hard limits - which is, per se, sane.
>>
>> Translating this to the soft limit speech, if the sum of B and C's soft
>> limit is smaller or equal A's soft limit, and one of them is over the
>> soft limit, that one should be reclaimed. The other should be left alone.
>
> And yet again. Nothing will prevent you from setting B+C>A. Sure if you
> configure your hierarchy sanely then everything will just work.

Let's all stop using words such as "sanely" and "work" since we don't
see to agree on how they apply here :)

The issue I see is that even when people configure soft limits B+C <
A, your current proposal still doesn't "leave the other alone" as
Glauber and I think we should.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
