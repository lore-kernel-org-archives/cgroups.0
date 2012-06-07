From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: make sure that decisions in __css_put are atomic
Date: Thu, 7 Jun 2012 10:54:30 +0900
Message-ID: <20120607015430.GG21357@google.com>
References: <20120605215019.4722.31817.stgit@dungbeetle.mtv.corp.google.com>
 <4FCF0747.7050000@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=tP1sHisbp+akZXVZEXxbQfx2Xx+tlwDVLT/F4CUM8Ls=;
        b=YTGqVh4xtB6OdnJHPM75yU1Tayq41MRtVNOzje9iKV/sfHn8gFHCfZ2kA9AML2sDuW
         EIabSjY82JWzo+iLSCWPhjV/Qus817dNNdHwxNsAFIHAzcKfXcXp3WLHvF2Gbi9WBHeT
         OeBvLqNysew9ow/E0fk1IqAwEefaTnmzxnPR+7bvFJRuGnTGel4QY66wrGPjimB3CAb3
         OGYvr79vNpN8Viannvaot/14klFAOzW6B9RAhcgad9+6ZONszP2GKkk3BR8S6/aj8Srv
         +K+Mz5ci0lTryUTZtOupnBVwuDtbwkhUSp0eV0tiUO2hrz44n6Jhh4MUXoFDxk57FtkQ
         ZUTA==
Content-Disposition: inline
In-Reply-To: <4FCF0747.7050000-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 06, 2012 at 03:31:19PM +0800, Li Zefan wrote:
> Salman Qazi wrote:
> 
> > __css_put is using atomic_dec on the ref count, and then
> > looking at the ref count to make decisions.  This is prone
> > to races, as someone else may decrement ref count between
> > our decrement and our decision.  Instead, we should base our
> > decisions on the value that we decremented the ref count to.
> > 
> > (This results in an actual race on Google's kernel which I
> > haven't been able to reproduce on the upstream kernel.  Having
> > said that, it's still incorrect by inspection).
> > 
> > Signed-off-by: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> 
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Good catch! This patch should be backported for 3.4.

Applied to for-3.5-fixes w/ stable@ added.

Thanks.

-- 
tejun
