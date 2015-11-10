From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 12:29:15 -0500
Message-ID: <20151110172915.GA13740@mtj.duckdns.org>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
 <20151110151223.GA17938@mtj.duckdns.org>
 <20151110153746.GA20758@rabbit.intern.cm-ag>
 <20151110170612.GA21582@rabbit.intern.cm-ag>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nsbZTnMlXWpabSwSdX7MH9icAOIBPTo9bbd/587pDNQ=;
        b=y61/TIbZEprtaCBvHViid6YpB5SGm7SL+Oa8L3hPDOmXYj1/aJsU5v08OKVlU5MbwX
         XRkmYgRi5AeLDplFNojGVINd9fKyZ4KpBDFg89YkczVz106TqII/4uYEKKyOdiEDVYtj
         NAnWhqZ1VDOResCoxxBf7f6sgbFulFsOPmlOF2+3WX/LR3DUxf1N62o8bXPSSl7QHemi
         lkuBFhIQ0Si/JD6ULkyzkgSLBMjIy4tOBVGkH1C/AooALUD/f+SXIqwHlSsUzk/dumf7
         lFsbD5HujO9icw/X1iYX995isHVmEZ+DcEXBrh63JRJO6QNe7g4g/aXsHl/WEJ8mCUPb
         Qjzg==
Content-Disposition: inline
In-Reply-To: <20151110170612.GA21582@rabbit.intern.cm-ag>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Max Kellermann <mk@cm4all.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 10, 2015 at 06:06:12PM +0100, Max Kellermann wrote:
> No, Tejun, the "cpu" controller does not do what my feature does: like
> I said, it only changes the priority, or let's rephrase (to account
> for the "absolute CPU cycle bandwith" thing): it changes the amount of
> CPU cycles a process gets every period.
> 
> But it does NOT put an upper limit on total consumed CPU cycles!  It
> will only slow down a frantic process, but it will not stop it.
> Stopping it is what I want.  Once process crosses the limits I
> configured, there's no point in keeping it running.

It's not a stateful resource.  Of course the resource is controlled in
terms of bandwidth not absoulte amount consumed.  That's what we do
with all stateless resources.  It's absurd to limit absoulte amount
for CPU cycles.  The only action possible from there on would be
terminating the group.  If you wanna do that, do so from userspace.

> You may disagree that the feature I implemented is useful, and you may
> not want it merged, but do not say that I missed a kernel feature,
> because that's not true.
>
> The Linux kernel currently does not have a feature that can emulate
> the fork limit that I implemented.  Useful or not, it doesn't exist.

The point is that the missing "feature" is really a non-starter.  What
if the process falls into infinite loop on fork failures?  It's just a
silly thing to implement.

Thanks.

-- 
tejun
