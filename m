From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups v2 cpuset partition bug
Date: Tue, 23 Aug 2022 06:23:32 -1000
Message-ID: <YwT/BNqIdCEyUpFR@slm.duckdns.org>
References: <C98773C9-F5ED-4664-BED1-5C03351130D4@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=H+wq+ieg2zAz6Oh265oix+95YnEXxnYHwGzSgbRpnMk=;
        b=dNfh/WFHo74Na+Pm8EFB0Xu+i/XqeeZ2FCpfKC8Bd83OTkRCURk9jf+0QUL822DPd/
         XuVtyk9kGSVJQUQvyB5q/zBXswN6tcZ6HRuAWadsOWHeqI4MzGx2du87v21T74O0v5yo
         YWS5xS9PWKGao6NCMPlde6iVzIphk4vtwRhjKqW7CUh3eoC78c7GqOODwu5xRtW1ct6m
         WMu/ldIPYmvQPapPBRtmSnscHHCn0NrCgKxy8lYwxSMoz7DeBtz0BomQ6cZMaichB8Ik
         QsBocA8vI5I4iIIwroyA6d3YGI8WQdn1C8Il9nirpVRepyBFsaoG083BOeiV/FXvFwsx
         9XIw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C98773C9-F5ED-4664-BED1-5C03351130D4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Maxim =?utf-8?B?4oCcTUFYUEFJTuKAnQ==?= Makarov <maxpain177-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

(cc'ing Waiman for visibilty)

On Tue, Aug 23, 2022 at 03:13:30PM +0300, Maxim “MAXPAIN” Makarov wrote:
> Hello. I have no idea where I can ask questions about cgroups v2. I have a problem with cpuset partitions.
> Could you please, check this question?
> https://unix.stackexchange.com/questions/714454/cgroups-v2-cpuset-doesnt-take-an-effect-without-process-restart

-- 
tejun
