From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 11:32:52 -0700
Message-ID: <20120626183252.GS3869@google.com>
References: <1340717428-9009-1-git-send-email-glommer@parallels.com>
 <20120626181209.GR3869@google.com>
 <4FE9FDCC.80000@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LkUt0CP11MfMauLep+Zsj+5vuOlljC2CDI0ajmZ2CDE=;
        b=q8JXLdmtZAcUbTYmNDXJzpiMWdy7Uo16L8f+cS4OwnbOGffk8t2ekeArKbxqpBtSo4
         t5kixvpweWyB3nSliENmbLqNo4BXS2ZpX4Bh4uRpwsx71fAEibIHd/oW+sQhrqimo/7W
         2tVaMCJ8Ym/cztzUTG7KLMcdytgFiBYiBVhQo7MRaZVqeRd0D+wTBErXjDdEt7gJb2Ro
         YgtIICctOHsKu30QfilVE5ntRFFk+V+5yUYqb/P5YFZCo8ruwEFp6a9+VhjLbe16q25Y
         y7eUaAQvU/WUvEt7q11GQGFxihX6Jhpg5OvbgrtXkuY8x8y4msTO/dwFLDR01LHTmbBK
         0l6w==
Content-Disposition: inline
In-Reply-To: <4FE9FDCC.80000-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Jun 26, 2012 at 10:22:04PM +0400, Glauber Costa wrote:
> I would agree with you if we were changing a fundamental algorithm,
> with no way to resort back to a default setup. We are not removing any
> functionality whatsoever here.
> 
> I would agree with you if we were actually documenting explicitly
> that this is an expected default behavior.
> 
> But we never made the claim that use_hierarchy would default to 0.
> 
> Well, we seldom make claims about default values of any tunables. We
> just expect them to be reasonable values, and we seem to agree that
> this is, indeed, reasonable.

No, we can't change behavior in this major way silently.  Any change
of this scale must be explicit.  The behavior change is not only major
but also subtle at the same time.  If a user is using flat hierarchy
and then boot a new kernel, the user suddenly gets hierarchical
accounting which may or may not cause noticeable problem immediately
and would be difficult like hell to chase down and diagnose.

I don't mind how global switch is implemented but the flip should be
explicit no matter what.  This is something we simply CAN NOT do.

Thanks.

-- 
tejun
