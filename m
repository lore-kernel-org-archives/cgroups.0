From: Guang Yang <guangyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IO throttling with CFQ IO scheduler
Date: Tue, 18 Apr 2017 09:52:09 -0700
Message-ID: <CAKtk8hdqkrG8LeP8kPie_39XLyxcftLb-Hpac=UMaaqFw_QtOg@mail.gmail.com>
References: <CAKtk8hedjVgioThT69ZMtcOdxeP9oCdBtQ6bBtXFEA-j9nAP8Q@mail.gmail.com>
 <20170418071545.GC3899@wtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=vzzqkUiFmPXqi4tlYY0G5nkeKvKE0ad0IjaqV331H+Q=;
        b=Nzbp2UkFZJQLaFgMsVz29nYCQzx4iMCRedp69QnxCcGQyOerJ0imt1v0Cgfb0GbL7I
         TRa6T35AkfPk+9K7JidcnwHotIGLcZjLLwhs+lAbrbwJm+oq5L8/spi5SvflOAYbLi+s
         zWE2cVehLwjRR3klU+3yrjKAFMBfbRxTyhOMIRxhS8Z1a86jumPL5v3O1rAYu2t7dHVY
         qOhiUXZbjCGVIwC8UhKRQ7lAisqlVM6vf2Evazh/8G1EK55Z+TESsMxzHewFcdPBWY6v
         7AAcN00MAWzc6El73U264lrscXzpI12nA0nbRx58KNOhhwRw8zQTauJmTrs2wmDWbM5q
         tKbw==
In-Reply-To: <20170418071545.GC3899-U58pm7aPsJ1N0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,
Thank you very much for the reply. We will try to explore some
alternatives at application side for this purpose.

Thanks,
Guang

On Tue, Apr 18, 2017 at 12:15 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Tue, Apr 04, 2017 at 10:54:41AM -0700, Guang Yang wrote:
>> I am experimenting the IO throttling with cgroups, with some good
>> reading from online and experiments, I found that we have two options:
>>  1. with CFQ IO scheduler, we can set a percentage of serving time one
>> group can take, and if one group does not fully take its share, other
>> (busy) group can steal the shares from the (ideal) group.
>>  2. with deadline IO scheduler, we can set an absolute IOPS and
>> bandwidth for one group, however, this does not consider the cost of
>> serving the IO (e.g. sequential vs. random) and thus it is hard to
>> give fair share between groups.
>
> Yeah, that's correct.
>
>> Neither one seems fully fit into our requirement - we hope that cost
>> model is based on the serving time, at the same time, we don't have
>> one group be able to steal share from the other.
>
> I see.  You want time based control which isn't work-conserving.
>
>> By looking online, not sure if I missed anything, I didn't see a way
>> to configure cgroups IO throttling to achieve the above requirement,
>> besides, if it is not supported now, is there anything on the roadmap
>> to support it in the future?
>
> It currently isn't supported and I don't think anyone is working on
> implementing something like that.  For SSDs, we haven't found a way to
> estimate the "serving time" in a scalable manner, so the outlook for
> the time based scheduling / control doesn't look too bright.
>
> It's a lot more cumbersome to configure but in a lot of cases limiting
> both bandwidth and IOPS can be good enough in limiting usage to some
> proportion across different workloads.
>
> Thanks.
>
> --
> tejun
