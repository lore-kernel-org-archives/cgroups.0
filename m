From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup, sched: restructure threadgroup locking and
 replace it with a percpu_rwsem
Date: Mon, 18 May 2015 12:34:40 -0400
Message-ID: <20150518163440.GA24861@htj.duckdns.org>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UGItYletBIHsrKUy7qoF4UR5JmwrT1X4dAtwPnmhLC4=;
        b=CZMpDpNGKHxi//tf6vl4ffGSjRIaa6PoT3YzoVvfxBGMqZSis2BToAaAp3/tqYD8/m
         JlaMrPTG7vIfFGYiEOE/gbmetJ5C1AWbK7oBr5bpZH67XCwgoJPVLRgibFdl3DDnwhdM
         TxDH4nyQxA3E96TOB1qRG0pUcY84Pr0IAKyDMT3Ep3IK+SERePvY1FuBrrmM/acaVRY+
         pEtO+rEK0CnJOVE41Bn00VZd0sxrAqhingsHJ33Kr7cTNt/CbGihtx9NY1EdUyK1Umes
         3kxj6cR9jbrv7y6wcbAPB1HAyl7SQdghX2/k70hkILkGi8vMZi/vjalLdWdwbbmSiWV8
         jscg==
Content-Disposition: inline
In-Reply-To: <1431549318-16756-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 13, 2015 at 04:35:15PM -0400, Tejun Heo wrote:
> threadgroup locking was added because cgroup needs threadgroups to
> stay stable across attach operations.  It was implemented as a
> per-signal_struct generic locking mechanism so that other users which
> require threadgroups stable across blocking operations can use it too;
> however, it hasn't grown any other use cases and still conditionalized
> on CONFIG_CGROUPS.

Ingo, Peter, what do you guys think?  If you guys are okay with the
changes, how do you want to route the patches?  Given that it's mostly
cgroup-specific and there are more cgroup changes depending on these,
it'd be the easiest to route these through the cgroup tree but putting
it elsewhere and pulling into cgroup is fine too.

Thanks.

-- 
tejun
