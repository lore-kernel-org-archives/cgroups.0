From: Tomasz Buchert <tomasz.buchert-MZpvjPyXg2s@public.gmane.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Date: Thu, 17 Nov 2011 18:03:46 +0100
Message-ID: <4EC53E72.5040408@inria.fr>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz> <4EC4DE9D.3040703@inria.fr> <20111117161318.GA1233@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111117161318.GA1233-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Le 17/11/2011 17:13, Michal Hocko a =E9crit :
> On Thu 17-11-11 11:14:53, Tomasz Buchert wrote:
>> Hi,
>> I'm trying to understand now why I did that change in
>>
>> 2d3cbf8bc (the bug itself was in the if-the-else clause in
>> update_if_frozen , anyway).
>> Well, when I look at this now I think that there is nothing wrong
>> with your patch.
>> You can try my testcases from 2d3cbf8bc and 0bdba580, but it should =
be ok.
> Yes, I have tried it before sending the patch.
>
>> One thing I am not sure completely of is the following situation. So
>> the group is frozen
>> with the STOPPED task inside. There are few questions:
>> * if you send SIGCONT to the task now, will it wake up?
> No, it will enter refrigerator and wake up on thawing the group. Chec=
k
> out `goto relock' after do_signal_stop returns.
>
I've checked your patch empirically few hours before :).
Also I've read get_signal_to_deliver() and you are right - it's gonna b=
e=20
fine.
The decision is not mine, of course, but I suggest to merge it.
Good work!

Tomek
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
