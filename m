From: Odin Ugedal <odin@uged.al>
Subject: Re: [PATCH v2] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Thu, 3 Jun 2021 15:55:29 +0200
Message-ID: <CAFpoUr3=v9L-0QqKJeR=P_PvPnSAxrKObwj3ZS+ypMyMd17jsA@mail.gmail.com>
References: <20210603113847.163512-1-odin@uged.al> <CAKfTPtAK3gEqChUmoUXo7KLqPAFo=shH4Yi=QLjrwpuu6Ow6-Q@mail.gmail.com>
 <CAFpoUr2HBexs5784nU7hyDSs0eNiEut=-4wWcnpMtSVtFeaLLA@mail.gmail.com> <CAKfTPtDLiN2GXxPG9AhxAihx++jV+W6VeBRdYgVwNmb8RiTkhQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fFoCEkJHlYaCqbo7kftj3nQYJl4JAya0mNURfk0G9Fo=;
        b=iOGRGKMMJ7mjrGAdEcby7lsIBWbsY9FmTD/4P6CUXobrP5vRdX5NYZlmK1uLe9dvLm
         z1YBOrXjyC64sc+6mGqhkgxtKmepkCsmdBv5T1o8rkEUgNLLB3G1th843k76n+w7wHd+
         wBxBLE9mapL58Sm8CD8BxlTz4dg7g3OzYg5zu1jJpMfAT1rIWGWNmJ6u55SGUEFkKclh
         HSKpx6Dyn20lsWeyWlv8dS05FWBs9MzSCS2jCUsGC3/IyBZrQVetFMVgDLEFwVPdDCmt
         VEFQd4XCnOAdznbWTJ7tKlTjnPFWvqvNoJk32txKZ4ZL09ETySALU4AfVW13V++mNOlH
         oRqw==
In-Reply-To: <CAKfTPtDLiN2GXxPG9AhxAihx++jV+W6VeBRdYgVwNmb8RiTkhQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Odin Ugedal <odin@uged.al>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

> If it's only a matter of waiting other PELT patches to be merged, we
> should use cfs_rq_is_decayed().

ACK. will post a v3.

> if load_avg!=0, we will update it periodically and sync
> tg_load_avg_contrib with the former. So it's not a problem.
>
> The other way was a problem because we stop updating load_avg and
> tg_load_avg_contrib when load_avg/load_sum is null so the
> tg_load_avg_contrib is stalled with a possibly very old value

Yeah, that makes sense.

Thanks
Odin
