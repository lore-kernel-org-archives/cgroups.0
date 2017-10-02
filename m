From: Tim Hockin <thockin@hockin.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 2 Oct 2017 13:00:54 -0700
Message-ID: <CAAAKZwtfXBEe=K93J0U35aMeFaBS8eJ9yN3kRE9=+yKzNnV_Nw@mail.gmail.com>
References: <CAAAKZws88uF2dVrXwRV0V6AH5X68rWy7AfJxTxYjpuiyiNJFWA@mail.gmail.com>
 <20170927074319.o3k26kja43rfqmvb@dhcp22.suse.cz> <CAAAKZws2CFExeg6A9AzrGjiHnFHU1h2xdk6J5Jw2kqxy=V+_YQ@mail.gmail.com>
 <20170927162300.GA5623@castle.DHCP.thefacebook.com> <CAAAKZwtApj-FgRc2V77nEb3BUd97Rwhgf-b-k0zhf1u+Y4fqxA@mail.gmail.com>
 <CALvZod7iaOEeGmDJA0cZvJWpuzc-hMRn3PG2cfzcMniJtAjKqA@mail.gmail.com>
 <20171002122434.llbaarb6yw3o3mx3@dhcp22.suse.cz> <CALvZod65LYZZYy6uE=DQaQRPXYAhAci=NMG_w=ZANPGATgRwfg@mail.gmail.com>
 <20171002192814.sad75tqklp3nmr4m@dhcp22.suse.cz> <CALvZod4=+GVg+hrT4ubp9P4b+LUZ+q9mz4ztC=Fc_cmTZmvpcw@mail.gmail.com>
 <20171002195601.3jeocmmzyf2jl3dw@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=+jIBRX1AwKtljbme4qLeZTIZAf2B0Hn4zhitib+bB18=;
        b=RQDcVRvqYC7NI+HsOPMPLeK1MJr7/mXwIcMMCwQmJC56AObanme7X5GeggW6SfFiwa
         R+JtknIYC24LoL8t58Y6d+DKpHWWDFHbJci3w/fT/vAoYRGC4HrZxnjYlpNK1JX5bj8+
         XHbeFErqTsvIacDKUvJ5pHP+U3qKkUuc1UwTgdH+isJbSyn3bwmWoNULy+Q6C69Hs9W+
         CzI1Z3iLC0koPMGhzNVnfazmMrXJf9Xq2FSXdlt71yDLUBCBvwMV96QN+0llU4VuJp+1
         fz6pWb9q2d5N48fPD6n17LkPwuhbVnfq9TmexhNd5UlMmKHs8QH42Y4J5h0UMKPZEcFw
         Gzrg==
In-Reply-To: <20171002195601.3jeocmmzyf2jl3dw@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

In the example above:

       root
       /    \
     A      D
     / \
   B   C

Does oom_group allow me to express "compare A and D; if A is chosen
compare B and C; kill the loser" ?  As I understand the proposal (from
reading thread, not patch) it does not.

On Mon, Oct 2, 2017 at 12:56 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 02-10-17 12:45:18, Shakeel Butt wrote:
>> > I am sorry to cut the rest of your proposal because it simply goes over
>> > the scope of the proposed solution while the usecase you are mentioning
>> > is still possible. If we want to compare intermediate nodes (which seems
>> > to be the case) then we can always provide a knob to opt-in - be it your
>> > oom_gang or others.
>>
>> In the Roman's proposed solution we can already force the comparison
>> of intermediate nodes using 'oom_group', I am just requesting to
>> separate the killall semantics from it.
>
> oom_group _is_ about killall semantic.  And comparing killable entities
> is just a natural thing to do. So I am not sure what you mean
>
> --
> Michal Hocko
> SUSE Labs
