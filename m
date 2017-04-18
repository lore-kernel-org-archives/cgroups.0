From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: IO throttling with CFQ IO scheduler
Date: Tue, 18 Apr 2017 16:15:45 +0900
Message-ID: <20170418071545.GC3899@wtj.duckdns.org>
References: <CAKtk8hedjVgioThT69ZMtcOdxeP9oCdBtQ6bBtXFEA-j9nAP8Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7saJ4Vb0B5ND9SmAr2yW+WMD4xTV5FPb6h76u/BFwjw=;
        b=oii1Xlerz2g4ohb7uabuv8r3p4sxBUwsOSh3ps4pxlacXe6ozbAqmPqeYQ0u60juFD
         kFyG9IRBJrCr8B0eU0V5uncasMqvtxIPvPciHn3OPd1p4i8OpcUtd4hunAJqmsJLBzxQ
         HVoaQPEzDje3penTmo1VxLkUr6wrX7zo43d9J0L0CiSt4R3IUxRAzZFpYKJj7DnMxdpP
         4O8GeGYcBqNSmKu6B2mKfcaoRB3oTII5MIqJ1OEBPFhJRrXL2w2J+nwKyRM1KF6BopPE
         Rs4Od98emNPVmH1dK+jNn2aqavFMwiArZN+k+1vLNe0bclFa1n5EBbjp4bmIEuAJ5di+
         MqWQ==
Content-Disposition: inline
In-Reply-To: <CAKtk8hedjVgioThT69ZMtcOdxeP9oCdBtQ6bBtXFEA-j9nAP8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Guang Yang <guangyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Apr 04, 2017 at 10:54:41AM -0700, Guang Yang wrote:
> I am experimenting the IO throttling with cgroups, with some good
> reading from online and experiments, I found that we have two options:
>  1. with CFQ IO scheduler, we can set a percentage of serving time one
> group can take, and if one group does not fully take its share, other
> (busy) group can steal the shares from the (ideal) group.
>  2. with deadline IO scheduler, we can set an absolute IOPS and
> bandwidth for one group, however, this does not consider the cost of
> serving the IO (e.g. sequential vs. random) and thus it is hard to
> give fair share between groups.

Yeah, that's correct.

> Neither one seems fully fit into our requirement - we hope that cost
> model is based on the serving time, at the same time, we don't have
> one group be able to steal share from the other.

I see.  You want time based control which isn't work-conserving.

> By looking online, not sure if I missed anything, I didn't see a way
> to configure cgroups IO throttling to achieve the above requirement,
> besides, if it is not supported now, is there anything on the roadmap
> to support it in the future?

It currently isn't supported and I don't think anyone is working on
implementing something like that.  For SSDs, we haven't found a way to
estimate the "serving time" in a scalable manner, so the outlook for
the time based scheduling / control doesn't look too bright.

It's a lot more cumbersome to configure but in a lot of cases limiting
both bandwidth and IOPS can be good enough in limiting usage to some
proportion across different workloads.

Thanks.

-- 
tejun
