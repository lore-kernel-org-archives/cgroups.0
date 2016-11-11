From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Fri, 11 Nov 2016 18:30:08 +0530
Message-ID: <CAG53R5WWDzbdVtynHbgsbGxGC7HS+XdzU1XbOnPcvtcC7hBx0g@mail.gmail.com>
References: <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com>
 <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com>
 <HE1PR0501MB2812298C05431B08B0F408EEB1A60@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAG53R5XqZwrYsdX=JQ1D4cDB0h65RDQVb=VCiaR5TXuf_uoO0Q@mail.gmail.com>
 <20161110163837.GE28957@leon.nu> <20161110164638.GC26105@htj.duckdns.org>
 <CAG53R5UGfhGHc3-jgUjH5taFzTHg3BOgXi25QjuQfUFc0U7tgw@mail.gmail.com>
 <20161110173217.GD26105@htj.duckdns.org> <CAG53R5Wk2zbL=0_EcYCOXQ4dK-k_w=sLOFAKD98NnnbAAnu2=A@mail.gmail.com>
 <20161110192344.GA4805@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=zcd6b879SkM9HlW++zmFZjzdd3rLoqIHhla64bhB3b0=;
        b=kaAIVSsut3sBbL3HTPZMqpHvesmKpVPXS1lg4lgS0vzqtCDObwVpNx1KOo7NXuz9lb
         MI3r0zl8w5Bm1eFoCwRl/rr5Os0ei7tinDHLQERS+q71FZfTOwuMXogZnZw1vfzuYIy8
         3yl4LQfdeuyYY1HH6A+pl34N9SeI8zCgWztOy41r+qITLoQ8KV6qMpLqoCnTivRnAC9/
         UAeHlcpX0eaM5NN0f8HZ9h6jVM7HtQh+l8Vl42lKPhPIvj487zH4qoLzJ0okD+Ua74bV
         ojo/5UEVWCVCiwsba4oad/TZ6tddwJElWQCPXY/eakMimn364497f7TXYNRd99ZJXO7u
         u1+w==
In-Reply-To: <20161110192344.GA4805-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Tejun,

On Fri, Nov 11, 2016 at 12:53 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Thu, Nov 10, 2016 at 11:26:28PM +0530, Parav Pandit wrote:
>> > That looks great to me from cgroup side.  Do you have plans for
>> > exposing the maximum numbers available?
>>
>> If I have to expose max limits, I need new file interface as rdma.limit.
>> Because once rdma.max is set, user space cannot get back the old value.
>> It needs to cache it. user space tools might have been restarted and
>> so on, so store in other file etc.
>> So such user space solutions are just ugly.
>>
>> Getting and setting values in device agnostic way, through cgroup
>> files is desirable, however its not must. It can fallback on using
>> verb based API.
>>
>> So if there is no objection, I prefer to have rdma.limit file as
>> incremental patch once base version is merged.
>
> How about something like RESOURCE.available field in rdma.stat file?
> Its value can be what's maximally available at that level when max is
> unlimited and there is no competition.  At top level cgroups, it'd be
> the total resources available in the system.  At sub levels, it'd be
> min of what's available to the grandparent and parent's limit on the
> resource.
>
> This would be in line with cgroup conventions and would behave the
> same way nested making things easier for containers.
>
Yes. This is what is needed. Awesome.
I will include in follow on patch after first round of functionality.
Patch_v13 will have base functionality similar to v12. This new file
will be once code is merged.


> Thanks.
>
> --
> tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
